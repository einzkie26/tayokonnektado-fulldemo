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

        public async Task<object> GetActivityLogsAsync(DateTime? since = null)
        {
            var roleByUser = await _context.UserRoles
                .Join(
                    _context.Roles,
                    ur => ur.RoleId,
                    r => r.Id,
                    (ur, r) => new { ur.UserId, RoleName = r.Name ?? string.Empty })
                .GroupBy(x => x.UserId)
                .Select(g => new
                {
                    UserId = g.Key,
                    Role = g
                        .OrderBy(x => (x.RoleName ?? string.Empty).ToLower() == "superadmin" ? 0 : (x.RoleName ?? string.Empty).ToLower() == "admin" ? 1 : (x.RoleName ?? string.Empty).ToLower() == "staff" ? 2 : 3)
                        .Select(x => x.RoleName)
                        .FirstOrDefault()
                })
                .ToDictionaryAsync(x => x.UserId, x => x.Role ?? string.Empty);

            var logsQuery = _context.ActivityLogs
                .AsNoTracking()
                .Include(l => l.User)
                .AsQueryable();

            if (since.HasValue)
            {
                var sinceUtc = DateTime.SpecifyKind(since.Value, DateTimeKind.Utc);
                logsQuery = logsQuery.Where(l => l.Timestamp > sinceUtc);
            }

            var logs = await logsQuery
                .OrderByDescending(l => l.Timestamp)
                .Take(1000)
                .ToListAsync();

            var loginHistoryQuery = _context.LoginHistory
                .AsNoTracking()
                .Include(h => h.User)
                .AsQueryable();

            if (since.HasValue)
            {
                var sinceUtc = DateTime.SpecifyKind(since.Value, DateTimeKind.Utc);
                loginHistoryQuery = loginHistoryQuery.Where(h => h.LoginTime > sinceUtc);
            }

            var loginHistory = await loginHistoryQuery
                .OrderByDescending(h => h.LoginTime)
                .Take(500)
                .ToListAsync();

            var activityEntries = logs.Select(l => new ActivityLogView
            {
                LogID = l.LogID,
                UserID = l.UserID,
                UserEmail = l.User?.Email,
                User = l.User == null
                    ? "Unknown"
                    : !string.IsNullOrWhiteSpace((l.User.FirstName + " " + l.User.LastName).Trim())
                        ? (l.User.FirstName + " " + l.User.LastName).Trim()
                        : (l.User.Email ?? "Unknown"),
                UserRole = roleByUser.TryGetValue(l.UserID, out var resolvedRole)
                    ? resolvedRole
                    : (l.User != null && !string.IsNullOrWhiteSpace(l.User.Role) ? l.User.Role : "Customer"),
                Action = l.Action,
                Type = l.Type,
                IPAddress = l.IPAddress,
                Timestamp = l.Timestamp
            });

            var loginEntries = loginHistory.Select(h => new ActivityLogView
            {
                LogID = -h.LoginHistoryID,
                UserID = h.UserID,
                UserEmail = h.User?.Email,
                User = h.User == null
                    ? "Unknown"
                    : !string.IsNullOrWhiteSpace((h.User.FirstName + " " + h.User.LastName).Trim())
                        ? (h.User.FirstName + " " + h.User.LastName).Trim()
                        : (h.User.Email ?? "Unknown"),
                UserRole = roleByUser.TryGetValue(h.UserID, out var resolvedRole)
                    ? resolvedRole
                    : (h.User != null && !string.IsNullOrWhiteSpace(h.User.Role) ? h.User.Role : "Customer"),
                Action = "Logged in",
                Type = "Login",
                IPAddress = h.IPAddress,
                Timestamp = h.LoginTime
            });

            return activityEntries
                .Concat(loginEntries)
                .Where(x => !string.Equals(x.UserRole, "SuperAdmin", StringComparison.OrdinalIgnoreCase))
                .OrderByDescending(x => x.Timestamp)
                .Take(1000)
                .Select(x => new
                {
                    x.LogID,
                    x.UserID,
                    x.UserEmail,
                    x.User,
                    x.UserRole,
                    x.Action,
                    x.Type,
                    x.IPAddress,
                    x.Timestamp
                })
                .ToList();
        }

        private sealed class ActivityLogView
        {
            public int LogID { get; set; }
            public string UserID { get; set; } = string.Empty;
            public string? UserEmail { get; set; }
            public string User { get; set; } = "Unknown";
            public string UserRole { get; set; } = "Customer";
            public string Action { get; set; } = string.Empty;
            public string Type { get; set; } = "View";
            public string? IPAddress { get; set; }
            public DateTime Timestamp { get; set; }
        }
    }
}
