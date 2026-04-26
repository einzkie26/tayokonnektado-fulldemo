using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services.Admin
{
    public class DashboardService
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;

        public DashboardService(ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        public async Task<object> GetDashboardStatsAsync()
        {
            var totalCustomers = await _userManager.Users
                .Where(u => u.Role == null || (u.Role != "SuperAdmin" && u.Role != "Admin" && u.Role != "Staff"))
                .CountAsync();
            var activeSubscriptions = await _context.Subscriptions.CountAsync(s => s.Status == "Active");
            var openTickets = await _context.SupportTickets.CountAsync(t => t.Status == "Open");
            var totalRevenue = await _context.Payments.SumAsync(p => p.AmountPaid);

            return new
            {
                totalCustomers,
                activeSubscriptions,
                openTickets,
                totalRevenue
            };
        }

        public async Task<object> GetActiveServicesAsync()
        {
            var subscriptions = await _context.Subscriptions
                .Include(s => s.User)
                .Include(s => s.Plan)
                .Select(s => new
                {
                    s.SubscriptionID,
                    Customer = s.User.FirstName + " " + s.User.LastName,
                    Service = s.Plan.PlanName,
                    s.Status,
                    InstallDate = s.StartDate,
                    s.UserID,
                    Type = "Subscription"
                })
                .ToListAsync();

            var prepaidWiFi = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                    .ThenInclude(sa => sa.Device)
                        .ThenInclude(d => d.User)
                .Select(p => new
                {
                    SubscriptionID = p.PrepaidLoadID,
                    Customer = p.ServiceAccount.Device.User.FirstName + " " + p.ServiceAccount.Device.User.LastName,
                    Service = "Prepaid WiFi",
                    Status = p.ServiceAccount.Status ?? "Active",
                    InstallDate = (DateTime?)p.ServiceAccount.ActivatedAt,
                    UserID = p.ServiceAccount.Device.UserID,
                    Type = "PrepaidWiFi",
                    p.PhoneNumber,
                    p.LoadAmount,
                    p.RemainingBalance,
                    p.LastReloadBalance,
                    MACAddress = p.ServiceAccount.Device.MACAddress
                })
                .ToListAsync();

            return subscriptions.Cast<object>().Concat(prepaidWiFi.Cast<object>()).ToList();
        }

        public async Task<object> GetAllInvoicesAsync()
        {
            return await _context.Invoices
                .Include(i => i.User)
                .Include(i => i.Subscription)
                .Select(i => new
                {
                    i.InvoiceID,
                    i.SubscriptionID,
                    User = i.User != null ? new { i.User.FirstName, i.User.LastName, i.User.Email } : null,
                    i.Amount,
                    i.DueDate,
                    i.Status,
                    i.CreatedAt
                })
                .OrderByDescending(i => i.CreatedAt)
                .ToListAsync();
        }

        public async Task<object> GetPaymentMethodsStatsAsync()
        {
            return await _context.Payments
                .Where(p => p.Status == "Completed")
                .GroupBy(p => p.PaymentMethod)
                .Select(g => new
                {
                    Name = g.Key,
                    Transactions = g.Count(),
                    Revenue = g.Sum(p => p.AmountPaid)
                })
                .ToListAsync();
        }

        public async Task<object> GetActivityLogsAsync()
        {
            return await _context.ActivityLogs
                .Include(l => l.User)
                .OrderByDescending(l => l.Timestamp)
                .Take(100)
                .Select(l => new
                {
                    l.LogID,
                    User = l.User.FirstName + " " + l.User.LastName,
                    l.Action,
                    l.Type,
                    l.IPAddress,
                    l.Timestamp
                })
                .ToListAsync();
        }
    }
}
