using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services.Admin
{
    public class CustomerManagementService
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly EmailService _emailService;

        public CustomerManagementService(ApplicationDbContext context, UserManager<ApplicationUser> userManager, EmailService emailService)
        {
            _context = context;
            _userManager = userManager;
            _emailService = emailService;
        }

        public async Task<List<object>> GetAllCustomersAsync()
        {
            var users = await _userManager.Users.ToListAsync();
            var customers = users.Where(u => u.Role != "Admin" && u.Role != "SuperAdmin" && u.Role != "Staff").ToList();
            
            var customersWithDetails = new List<object>();
            
            foreach (var user in customers)
            {
                var subscriptions = await _context.Subscriptions
                    .Include(s => s.Plan)
                    .Where(s => s.UserID == user.Id)
                    .Select(s => new
                    {
                        s.SubscriptionID,
                        PlanName = s.Plan.PlanName,
                        s.Plan.SpeedMbps,
                        MonthlyFee = s.Plan.Price,
                        s.Status,
                        s.StartDate
                    })
                    .ToListAsync();
                
                var totalBalance = await _context.Invoices
                    .Where(i => i.UserID == user.Id && i.Status == "Pending")
                    .SumAsync(i => i.Amount);
                
                customersWithDetails.Add(new
                {
                    user.Id,
                    user.FirstName,
                    user.LastName,
                    user.Email,
                    Address = user.Address ?? string.Empty,
                    ProfilePictureUrl = user.ProfilePictureUrl ?? string.Empty,
                    user.Status,
                    user.CreatedAt,
                    Subscriptions = subscriptions,
                    TotalBalance = totalBalance
                });
            }
            
            return customersWithDetails;
        }

        public async Task<object?> GetCustomerByIdAsync(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null) return null;
            
            var subscriptions = await _context.Subscriptions
                .Include(s => s.Plan)
                .Where(s => s.UserID == id)
                .Select(s => new
                {
                    s.SubscriptionID,
                    PlanName = s.Plan.PlanName,
                    s.Plan.SpeedMbps,
                    MonthlyFee = s.Plan.Price,
                    s.Status,
                    s.StartDate
                })
                .ToListAsync();
            
            var totalBalance = await _context.Invoices
                .Where(i => i.UserID == id && i.Status == "Pending")
                .SumAsync(i => i.Amount);
            
            return new 
            { 
                user.Id, 
                user.FirstName, 
                user.LastName, 
                user.Email,
                Address = user.Address ?? string.Empty,
                ProfilePictureUrl = user.ProfilePictureUrl ?? string.Empty,
                user.CreatedAt,
                user.Status,
                Subscriptions = subscriptions,
                TotalBalance = totalBalance
            };
        }

        public async Task<bool> UpdateCustomerAsync(string id, string firstName, string lastName, string email, string status)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null) return false;

            var oldStatus = user.Status;
            user.FirstName = firstName;
            user.LastName = lastName;
            user.Email = email;
            user.UserName = email;
            user.NormalizedEmail = email.ToUpper();
            user.NormalizedUserName = email.ToUpper();
            user.Status = status;
            await _userManager.UpdateAsync(user);

            // Send email notification if status changed
            if (oldStatus != status)
            {
                var statusMessage = status switch
                {
                    "Active" => "Your account has been activated. You can now access all services.",
                    "Freeze" => "Your account has been frozen due to late payments. Please contact support or pay your outstanding balance to restore access.",
                    "Inactive" => "Your account has been set to inactive. Please contact support for assistance.",
                    _ => $"Your account status has been changed to {status}."
                };

                var emailBody = $@"
                    <h2>Account Status Update</h2>
                    <p>Hello {user.FirstName} {user.LastName},</p>
                    <p>{statusMessage}</p>
                    <p>If you have any questions, please contact our support team.</p>
                    <br>
                    <p>Best regards,<br>TayoKonnektado Team</p>
                ";

                try
                {
                    await _emailService.SendEmailAsync(user.Email!, "Account Status Update - TayoKonnektado", emailBody);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Failed to send status change email: {ex.Message}");
                }
            }

            return true;
        }

        public async Task<bool> DeleteCustomerAsync(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null) return false;

            await _userManager.DeleteAsync(user);
            return true;
        }
    }
}
