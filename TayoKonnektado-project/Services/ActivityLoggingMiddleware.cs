using System.Globalization;
using System.Security.Claims;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services
{
    public class ActivityLoggingMiddleware
    {
        private readonly RequestDelegate _next;

        public ActivityLoggingMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context, ApplicationDbContext dbContext)
        {
            var shouldLog = ShouldLogRequest(context.Request);

            await _next(context);

            if (!shouldLog)
                return;

            if (context.Response.StatusCode < StatusCodes.Status200OK || context.Response.StatusCode >= StatusCodes.Status400BadRequest)
                return;

            var userId = context.User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrWhiteSpace(userId))
                return;

            try
            {
                var type = GetActivityType(context.Request);
                var action = BuildAction(context.Request, type);

                dbContext.ActivityLogs.Add(new ActivityLog
                {
                    UserID = userId,
                    Action = action,
                    Type = type,
                    IPAddress = context.Connection.RemoteIpAddress?.ToString(),
                    Timestamp = DateTime.UtcNow
                });

                await dbContext.SaveChangesAsync();
            }
            catch
            {
                // Do not block API responses because of activity logging failures.
            }
        }

        private static bool ShouldLogRequest(HttpRequest request)
        {
            if (!request.Path.StartsWithSegments("/api", StringComparison.OrdinalIgnoreCase))
                return false;

            var path = request.Path.Value?.ToLowerInvariant() ?? string.Empty;

            // Prevent recursive/noisy logs.
            if (path.StartsWith("/api/admin/activity-logs")
                || path.StartsWith("/api/activity/log")
                || path.StartsWith("/api/admin/notifications")
                || path.StartsWith("/api/admin/dashboard/stats")
                || path.StartsWith("/api/auth/onboarding-status")
                || path.StartsWith("/api/customer/notifications")
                || path.StartsWith("/api/customer/profile"))
                return false;

            return request.Method is "GET" or "POST" or "PUT" or "PATCH" or "DELETE";
        }

        private static string GetActivityType(HttpRequest request)
        {
            var path = request.Path.Value?.ToLowerInvariant() ?? string.Empty;

            if (path.Contains("/auth/login") || path.Contains("/auth/google-login") || path.Contains("/auth/verify-2fa-login"))
                return "Login";

            return request.Method switch
            {
                "GET" => "View",
                "POST" => "Create",
                "PUT" or "PATCH" => "Update",
                "DELETE" => "Delete",
                _ => "View"
            };
        }

        private static string BuildAction(HttpRequest request, string type)
        {
            var path = request.Path.Value?.ToLowerInvariant() ?? string.Empty;

            if (path.Contains("/auth/login")) return "Logged in";
            if (path.Contains("/auth/register")) return "Registered account";
            if (path.Contains("/auth/google-login")) return "Logged in with Google";
            if (path.Contains("/auth/verify-email")) return "Verified email address";
            if (path.Contains("/auth/verify-2fa-login")) return "Completed two-factor login";

            if (path.Contains("/customer/tickets") && type == "Create") return "Created support ticket";
            if (path.Contains("/customer/tickets") && type == "Update") return "Updated support ticket";
            if (path.Contains("/customer/tickets") && type == "Delete") return "Deleted support ticket";

            if (path.Contains("/admin/tickets") && type == "Update") return "Updated support ticket status";
            if (path.Contains("/admin/payments") && path.Contains("approve")) return "Approved payment";
            if (path.Contains("/admin/payments") && path.Contains("reject")) return "Rejected payment";
            if (path.Contains("/admin/staff") && type == "Create") return "Created staff account";
            if (path.Contains("/admin/staff") && type == "Update") return "Updated staff account";
            if (path.Contains("/admin/staff") && type == "Delete") return "Deleted staff account";
            if (path.Contains("/admin/customers") && type == "Update") return "Updated customer account";
            if (path.Contains("/admin/customers") && type == "Delete") return "Deleted customer account";

            var segments = request.Path.Value?
                .Split('/', StringSplitOptions.RemoveEmptyEntries)
                .Skip(1) // Skip "api"
                .ToArray() ?? Array.Empty<string>();

            if (segments.Length == 0)
                return type == "Create" ? "Created data" : type == "Update" ? "Updated data" : "Deleted data";

            var resourceParts = segments
                .Take(Math.Min(2, segments.Length))
                .Select(s => s.Replace('-', ' '))
                .Select(s => CultureInfo.InvariantCulture.TextInfo.ToTitleCase(s));

            var resource = string.Join(" ", resourceParts);

            return type switch
            {
                "Create" => $"Created {resource}",
                "Update" => $"Updated {resource}",
                "Delete" => $"Deleted {resource}",
                _ => $"Viewed {resource}"
            };
        }
    }
}
