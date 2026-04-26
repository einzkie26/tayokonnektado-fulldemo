using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services.Admin
{
    public class SubscriptionManagementService
    {
        private readonly ApplicationDbContext _context;
        private readonly EmailService _emailService;

        public SubscriptionManagementService(ApplicationDbContext context, EmailService emailService)
        {
            _context = context;
            _emailService = emailService;
        }

        public async Task<object> GetAllSubscriptionsAsync()
        {
            return await _context.Subscriptions
                .Include(s => s.User)
                .Include(s => s.Plan)
                .Select(s => new
                {
                    s.SubscriptionID,
                    s.UserID,
                    s.PlanID,
                    s.StartDate,
                    s.EndDate,
                    s.Status,
                    User = new { s.User.FirstName, s.User.LastName, s.User.Email },
                    Plan = new { s.Plan.PlanName, s.Plan.SpeedMbps, Price = s.Plan.Price }
                })
                .ToListAsync();
        }

        public async Task<bool> UpdateSubscriptionAsync(int id, string status, int? planId, string? endDate)
        {
            var subscription = await _context.Subscriptions
                .Include(s => s.Plan)
                .Include(s => s.User)
                .FirstOrDefaultAsync(s => s.SubscriptionID == id);
            if (subscription == null) return false;

            var oldStatus = subscription.Status;
            var wasNotActive = subscription.Status != "Active";
            subscription.Status = status;
            if (planId.HasValue) subscription.PlanID = planId.Value;
            
            if (string.IsNullOrEmpty(endDate))
            {
                subscription.EndDate = null;
                Console.WriteLine($"Clearing EndDate for subscription {id}");
            }
            else
            {
                try
                {
                    subscription.EndDate = DateTime.Parse(endDate);
                    Console.WriteLine($"Setting EndDate to {subscription.EndDate} for subscription {id}");
                }
                catch
                {
                    // Invalid date format, skip
                }
            }
            
            await _context.SaveChangesAsync();
            Console.WriteLine($"Subscription {id} EndDate after save: {subscription.EndDate}");

            // Send email notification if status changed
            if (oldStatus != status && subscription.User != null)
            {
                var planName = subscription.Plan?.PlanName ?? "Your subscription";
                var statusMessage = status switch
                {
                    "Active" => $"Your subscription ({planName}) has been activated. You can now enjoy your internet service.",
                    "Freeze" => $"Your subscription ({planName}) has been frozen. Please contact support or pay your outstanding balance to restore access.",
                    "Inactive" => $"Your subscription ({planName}) has been set to inactive. Please contact support for assistance.",
                    _ => $"Your subscription ({planName}) status has been changed to {status}."
                };

                var emailBody = $@"
                    <h2>Subscription Status Update</h2>
                    <p>Hello {subscription.User.FirstName} {subscription.User.LastName},</p>
                    <p>{statusMessage}</p>
                    <p>If you have any questions, please contact our support team.</p>
                    <br>
                    <p>Best regards,<br>TayoKonnektado Team</p>
                ";

                try
                {
                    await _emailService.SendEmailAsync(subscription.User.Email!, "Subscription Status Update - TayoKonnektado", emailBody);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Failed to send subscription status email: {ex.Message}");
                }
            }

            return true;
        }

        public async Task<bool> DeleteSubscriptionAsync(int id)
        {
            try
            {
                var subscription = await _context.Subscriptions
                    .FirstOrDefaultAsync(s => s.SubscriptionID == id);
                if (subscription == null) return false;

                // Delete payments for invoices of this subscription
                var invoiceIds = await _context.Invoices
                    .Where(i => i.SubscriptionID == id)
                    .Select(i => i.InvoiceID)
                    .ToListAsync();
                
                var payments = await _context.Payments
                    .Where(p => invoiceIds.Contains(p.InvoiceID ?? 0))
                    .ToListAsync();
                _context.Payments.RemoveRange(payments);

                // Delete invoices
                var invoices = await _context.Invoices
                    .Where(i => i.SubscriptionID == id)
                    .ToListAsync();
                _context.Invoices.RemoveRange(invoices);

                // Delete subscription
                _context.Subscriptions.Remove(subscription);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (DbUpdateException ex)
            {
                Console.WriteLine($"DbUpdateException: {ex.Message}");
                Console.WriteLine($"InnerException: {ex.InnerException?.Message}");
                if (ex.InnerException is SqlException sqlEx)
                {
                    Console.WriteLine($"SQL Error: {sqlEx.Message}");
                    foreach (SqlError error in sqlEx.Errors)
                    {
                        Console.WriteLine($"Error Number: {error.Number}, Message: {error.Message}");
                    }
                }
                throw;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error deleting subscription: {ex.Message}\n{ex.InnerException?.Message}");
                throw;
            }
        }
    }
}
