using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services.Admin
{
    public class PaymentManagementService
    {
        private readonly ApplicationDbContext _context;
        private readonly PayMongoService _payMongoService;
        private readonly EmailService _emailService;

        public PaymentManagementService(ApplicationDbContext context, PayMongoService payMongoService, EmailService emailService)
        {
            _context = context;
            _payMongoService = payMongoService;
            _emailService = emailService;
        }

        public async Task<object> GetAllPaymentsAsync()
        {
            return await _context.Payments
                .Include(p => p.User)
                .Include(p => p.Invoice)
                .OrderByDescending(p => p.PaymentDate)
                .Select(p => new
                {
                    p.PaymentID,
                    p.InvoiceID,
                    p.UserID,
                    p.AmountPaid,
                    p.PaymentMethod,
                    p.ReferenceNum,
                    p.PaymentDate,
                    p.Status,
                    p.IsArchived,
                    User = new
                    {
                        p.User.Email,
                        p.User.FirstName,
                        p.User.LastName,
                        p.User.Status
                    }
                })
                .ToListAsync();
        }

        public async Task<(bool success, string message)> ApprovePaymentAsync(int id)
        {
            var payment = await _context.Payments
                .Include(p => p.Invoice)
                .Include(p => p.User)
                .FirstOrDefaultAsync(p => p.PaymentID == id);
            
            if (payment == null) return (false, "Payment not found");
            if (payment.Status != "Pending") return (false, "Payment is not pending");

            // If reference starts with "pay_" it's already a PayMongo payment object — confirm directly
            if (!string.IsNullOrEmpty(payment.ReferenceNum) && payment.ReferenceNum.StartsWith("pay_"))
            {
                payment.Status = "Completed";
                if (payment.Invoice != null) payment.Invoice.Status = "Completed";
                await _context.SaveChangesAsync();

                // Generate next month's invoice
                await GenerateNextInvoiceAsync(payment);

                await SendReceiptEmailAsync(payment);
                await CreateNotificationAsync(payment);
                return (true, "Payment confirmed");
            }

            // GCash Source (src_...) — try to charge via PayMongo
            if (!string.IsNullOrEmpty(payment.ReferenceNum) && payment.ReferenceNum.StartsWith("src_"))
            {
                try
                {
                    var status = await _payMongoService.GetSourceStatus(payment.ReferenceNum);

                    if (status == "chargeable")
                    {
                        var description = payment.InvoiceID.HasValue ? $"Invoice #{payment.InvoiceID}" : "Payment";
                        var paymentId = await _payMongoService.CreatePayment(payment.ReferenceNum, payment.AmountPaid, description);
                        payment.ReferenceNum = paymentId;
                    }
                    // In TEST MODE: GCash sources stay "pending" — allow admin to manually confirm
                    else if (status != "chargeable")
                    {
                        Console.WriteLine($"[TEST MODE] GCash source status is '{status}'. Allowing manual admin confirmation.");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"PayMongo source check failed: {ex.Message}. Proceeding with manual confirmation.");
                }
            }

            // Mark confirmed (works for test mode and production)
            payment.Status = "Completed";
            if (payment.Invoice != null) payment.Invoice.Status = "Completed";
            await _context.SaveChangesAsync();

            // Auto-generate next month's invoice for the subscription
            await GenerateNextInvoiceAsync(payment);

            await SendReceiptEmailAsync(payment);
            await CreateNotificationAsync(payment);
            return (true, "Payment confirmed");
        }

        public async Task<bool> RejectPaymentAsync(int id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null || payment.Status != "Pending") return false;

            payment.Status = "Rejected";
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ArchivePaymentAsync(int id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null) return false;

            payment.IsArchived = true;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UnarchivePaymentAsync(int id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null) return false;

            payment.IsArchived = false;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeletePaymentAsync(int id)
        {
            var payment = await _context.Payments.FindAsync(id);
            if (payment == null || !payment.IsArchived) return false;

            _context.Payments.Remove(payment);
            await _context.SaveChangesAsync();
            return true;
        }

        private async Task GenerateNextInvoiceAsync(Payment payment)
        {
            try
            {
                if (payment.Invoice == null) return;

                var subscriptionId = payment.Invoice.SubscriptionID;
                if (subscriptionId == null) return;

                // Check if a next pending invoice already exists for this subscription
                var existingNext = await _context.Invoices
                    .FirstOrDefaultAsync(i => i.SubscriptionID == subscriptionId && i.Status == "Pending");
                if (existingNext != null) return;

                // Get the subscription with its plan price
                var subscription = await _context.Subscriptions
                    .Include(s => s.Plan)
                    .FirstOrDefaultAsync(s => s.SubscriptionID == subscriptionId && s.Status == "Active");
                if (subscription == null) return;

                var amount = subscription.Plan?.Price ?? payment.AmountPaid;
                var currentDueDate = payment.Invoice.DueDate ?? DateTime.UtcNow;
                var nextDueDate = currentDueDate.AddMonths(1);

                var nextInvoice = new Invoice
                {
                    SubscriptionID = subscriptionId,
                    UserID = payment.UserID,
                    Amount = amount,
                    DueDate = nextDueDate,
                    Status = "Pending"
                };
                _context.Invoices.Add(nextInvoice);
                await _context.SaveChangesAsync();

                Console.WriteLine($"Next invoice generated for subscription {subscriptionId}. Due: {nextDueDate:d}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to generate next invoice: {ex.Message}");
            }
        }

        private async Task SendReceiptEmailAsync(Payment payment)
        {
            try
            {
                // Convert UTC time to Philippine time (UTC+8) for display
                var phOffset = TimeSpan.FromHours(8);
                var phPaymentDate = payment.PaymentDate.ToUniversalTime().Add(phOffset);
                var emailBody = $@"
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }}
        .container {{ max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
        .header {{ background: linear-gradient(135deg, #003366 0%, #00509E 100%); color: white; padding: 30px; text-align: center; }}
        .header h1 {{ margin: 0; font-size: 28px; }}
        .content {{ padding: 30px; }}
        .receipt-box {{ background-color: #E6F0FF; border-left: 4px solid #003366; padding: 20px; margin: 20px 0; border-radius: 4px; }}
        .receipt-row {{ display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #ccc; }}
        .receipt-row:last-child {{ border-bottom: none; font-weight: bold; font-size: 18px; color: #003366; }}
        .label {{ color: #666; }}
        .value {{ color: #003366; font-weight: 600; }}
        .success-badge {{ background-color: #10B981; color: white; padding: 8px 16px; border-radius: 20px; display: inline-block; margin: 20px 0; }}
        .footer {{ background-color: #f8f9fa; padding: 20px; text-align: center; color: #666; font-size: 12px; }}
        .button {{ background-color: #FDB913; color: #003366; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; margin: 20px 0; font-weight: bold; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>Payment Receipt</h1>
            <p style='margin: 10px 0 0 0; opacity: 0.9;'>TayoKonnektado Internet Services</p>
        </div>
        <div class='content'>
            <div style='text-align: center;'>
                <div class='success-badge'>✓ PAYMENT CONFIRMED</div>
            </div>
            <p>Dear {payment.User.FirstName} {payment.User.LastName},</p>
            <p>Thank you for your payment! Your transaction has been successfully processed.</p>
            
            <div class='receipt-box'>
                <h3 style='margin-top: 0; color: #003366;'>Payment Details</h3>
                <div class='receipt-row'>
                    <span class='label'>Receipt Number:</span>
                    <span class='value'>#{payment.PaymentID.ToString().PadLeft(6, '0')}</span>
                </div>
                <div class='receipt-row'>
                    <span class='label'>Invoice Number:</span>
                    <span class='value'>#{payment.InvoiceID}</span>
                </div>
                <div class='receipt-row'>
                    <span class='label'>Payment Date:</span>
                    <span class='value'>{phPaymentDate:MMMM dd, yyyy}</span>
                </div>
                <div class='receipt-row'>
                    <span class='label'>Payment Method:</span>
                    <span class='value'>{payment.PaymentMethod}</span>
                </div>
                <div class='receipt-row'>
                    <span class='label'>Reference Number:</span>
                    <span class='value'>{payment.ReferenceNum}</span>
                </div>
                <div class='receipt-row'>
                    <span class='label'>Amount Paid:</span>
                    <span class='value'>₱{payment.AmountPaid:N2}</span>
                </div>
            </div>

            <p style='color: #666; font-size: 14px; margin-top: 30px;'>
                Your service will continue uninterrupted. If you have any questions about this payment, 
                please don't hesitate to contact our support team.
            </p>

            <div style='text-align: center;'>
                <a href='#' class='button'>View Account Dashboard</a>
            </div>
        </div>
        <div class='footer'>
            <p><strong>TayoKonnektado</strong></p>
            <p>Connecting Communities, Empowering Lives</p>
            <p style='margin-top: 15px;'>This is an automated receipt. Please do not reply to this email.</p>
        </div>
    </div>
</body>
</html>";

                await _emailService.SendEmailAsync(
                    payment.User.Email!,
                    "Payment Receipt - TayoKonnektado",
                    emailBody
                );
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to send receipt email: {ex.Message}");
            }
        }

        private async Task CreateNotificationAsync(Payment payment)
        {
            var notification = new Notification
            {
                UserID = payment.UserID,
                Message = payment.InvoiceID.HasValue 
                    ? $"Payment receipt for Invoice #{payment.InvoiceID} has been sent to your email ({payment.User.Email})"
                    : $"Payment receipt has been sent to your email ({payment.User.Email})",
                Type = "Payment Completed",
                Status = "Unread"
            };
            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();
        }
    }
}
