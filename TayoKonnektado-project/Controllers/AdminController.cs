using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;
using TayoKonnektado_project.Services.Admin;

namespace TayoKonnektado_project.Controllers
{
    [Authorize(Roles = "SuperAdmin,Admin,Staff")]
    [ApiController]
    [Route("api/[controller]")]
    public class AdminController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly CustomerManagementService _customerService;
        private readonly TicketManagementService _ticketService;
        private readonly PaymentManagementService _paymentService;
        private readonly SubscriptionManagementService _subscriptionService;
        private readonly StaffManagementService _staffService;
        private readonly DashboardService _dashboardService;
        private readonly PlanManagementService _planService;
        private readonly FAQManagementService _faqService;

        public AdminController(
            ApplicationDbContext context,
            CustomerManagementService customerService,
            TicketManagementService ticketService,
            PaymentManagementService paymentService,
            SubscriptionManagementService subscriptionService,
            StaffManagementService staffService,
            DashboardService dashboardService,
            PlanManagementService planService,
            FAQManagementService faqService)
        {
            _context = context;
            _customerService = customerService;
            _ticketService = ticketService;
            _paymentService = paymentService;
            _subscriptionService = subscriptionService;
            _staffService = staffService;
            _dashboardService = dashboardService;
            _planService = planService;
            _faqService = faqService;
        }

        [Authorize(Roles = "SuperAdmin,Admin")]
        [HttpGet("customers")]
        public async Task<IActionResult> GetCustomers() => Ok(await _customerService.GetAllCustomersAsync());

        [Authorize(Roles = "SuperAdmin,Admin")]
        [HttpGet("customers/{id}")]
        public async Task<IActionResult> GetCustomer(string id)
        {
            var customer = await _customerService.GetCustomerByIdAsync(id);
            return customer == null ? NotFound() : Ok(customer);
        }

        [Authorize(Roles = "SuperAdmin,Admin")]
        [HttpPut("customers/{id}")]
        public async Task<IActionResult> UpdateCustomer(string id, [FromBody] UpdateCustomerRequest request)
        {
            var success = await _customerService.UpdateCustomerAsync(id, request.FirstName, request.LastName, request.Email, request.Status);
            return success ? Ok(new { message = "Customer updated successfully" }) : NotFound();
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpDelete("customers/{id}")]
        public async Task<IActionResult> DeleteCustomer(string id)
        {
            var success = await _customerService.DeleteCustomerAsync(id);
            return success ? Ok(new { message = "Customer deleted successfully" }) : NotFound();
        }

        [Authorize(Roles = "SuperAdmin,Admin,Staff")]
        [HttpGet("tickets")]
        public async Task<IActionResult> GetAllTickets() => Ok(await _ticketService.GetAllTicketsAsync());

        [HttpPut("tickets/{id}")]
        public async Task<IActionResult> UpdateTicket(int id, [FromBody] UpdateTicketRequest request)
        {
            var success = await _ticketService.UpdateTicketAsync(id, request.Status, request.AssignedStaffID);
            return success ? Ok(new { message = "Ticket updated successfully" }) : NotFound();
        }

        [HttpPost("tickets/{id}/reply")]
        public async Task<IActionResult> ReplyToTicket(int id, [FromBody] ReplyTicketRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (userId == null) return Unauthorized();

            var success = await _ticketService.ReplyToTicketAsync(id, userId, request.Message);
            return success ? Ok(new { message = "Reply sent successfully" }) : NotFound();
        }

        [HttpPost("tickets/{id}/archive")]
        public async Task<IActionResult> ArchiveTicket(int id)
        {
            var success = await _ticketService.ArchiveTicketAsync(id);
            return success ? Ok(new { message = "Ticket archived successfully" }) : BadRequest(new { message = "Only closed tickets can be archived" });
        }

        [HttpPost("tickets/{id}/unarchive")]
        public async Task<IActionResult> UnarchiveTicket(int id)
        {
            var success = await _ticketService.UnarchiveTicketAsync(id);
            return success ? Ok(new { message = "Ticket restored successfully" }) : NotFound();
        }

        [HttpDelete("tickets/{id}")]
        public async Task<IActionResult> DeleteTicket(int id)
        {
            var success = await _ticketService.DeleteTicketAsync(id);
            return success ? Ok(new { message = "Ticket deleted successfully" }) : BadRequest(new { message = "Only closed tickets can be deleted" });
        }

        [Authorize(Roles = "SuperAdmin,Admin,Staff")]
        [HttpGet("payments")]
        public async Task<IActionResult> GetAllPayments() => Ok(await _paymentService.GetAllPaymentsAsync());

        [HttpPost("payments/{id}/approve")]
        public async Task<IActionResult> ApprovePayment(int id)
        {
            var (success, message) = await _paymentService.ApprovePaymentAsync(id);
            return success ? Ok(new { message }) : BadRequest(new { message });
        }

        [HttpPost("payments/{id}/confirm")]
        public async Task<IActionResult> ConfirmPayment(int id) => await ApprovePayment(id);

        [HttpPost("payments/{id}/reject")]
        public async Task<IActionResult> RejectPayment(int id)
        {
            var success = await _paymentService.RejectPaymentAsync(id);
            return success ? Ok(new { message = "Payment rejected" }) : BadRequest(new { message = "Payment is not pending" });
        }

        [HttpPost("payments/{id}/archive")]
        public async Task<IActionResult> ArchivePayment(int id)
        {
            var success = await _paymentService.ArchivePaymentAsync(id);
            return success ? Ok(new { message = "Payment archived" }) : NotFound();
        }

        [HttpPost("payments/{id}/unarchive")]
        public async Task<IActionResult> UnarchivePayment(int id)
        {
            var success = await _paymentService.UnarchivePaymentAsync(id);
            return success ? Ok(new { message = "Payment restored" }) : NotFound();
        }

        [HttpDelete("payments/{id}")]
        public async Task<IActionResult> DeletePayment(int id)
        {
            var success = await _paymentService.DeletePaymentAsync(id);
            return success ? Ok(new { message = "Payment deleted" }) : BadRequest(new { message = "Only archived payments can be deleted" });
        }

        [Authorize(Roles = "SuperAdmin,Admin,Staff")]
        [HttpGet("subscriptions")]
        public async Task<IActionResult> GetAllSubscriptions() => Ok(await _subscriptionService.GetAllSubscriptionsAsync());

        [HttpPut("subscriptions/{id}")]
        public async Task<IActionResult> UpdateSubscription(int id, [FromBody] UpdateSubscriptionRequest request)
        {
            try
            {
                var success = await _subscriptionService.UpdateSubscriptionAsync(id, request.Status, request.PlanID, request.EndDate);
                return success ? Ok(new { message = "Subscription updated successfully" }) : NotFound();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpDelete("subscriptions/{id}")]
        public async Task<IActionResult> DeleteSubscription(int id)
        {
            try
            {
                var success = await _subscriptionService.DeleteSubscriptionAsync(id);
                if (!success)
                {
                    return NotFound(new { message = "Subscription not found" });
                }
                return Ok(new { message = "Subscription deleted successfully" });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Delete subscription error: {ex.Message}\n{ex.InnerException?.Message}");
                return BadRequest(new { message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        // Dashboard & Reports
        [Authorize(Roles = "SuperAdmin,Admin")]
        [HttpGet("dashboard/stats")]
        public async Task<IActionResult> GetDashboardStats() => Ok(await _dashboardService.GetDashboardStatsAsync());

        [HttpGet("active-services")]
        public async Task<IActionResult> GetActiveServices() => Ok(await _dashboardService.GetActiveServicesAsync());

        [HttpGet("invoices")]
        public async Task<IActionResult> GetAllInvoices() => Ok(await _dashboardService.GetAllInvoicesAsync());

        [HttpGet("payment-methods-stats")]
        public async Task<IActionResult> GetPaymentMethodsStats() => Ok(await _dashboardService.GetPaymentMethodsStatsAsync());

        [Authorize(Roles = "SuperAdmin,Admin")]
        [HttpGet("activity-logs")]
        public async Task<IActionResult> GetActivityLogs([FromQuery] DateTime? since = null)
        {
            Response.Headers.CacheControl = "no-store, no-cache, must-revalidate";
            Response.Headers.Pragma = "no-cache";
            Response.Headers.Expires = "0";

            return Ok(await _dashboardService.GetActivityLogsAsync(since));
        }

        [Authorize(Roles = "SuperAdmin,Admin")]
        [HttpDelete("activity-logs/{id}")]
        public async Task<IActionResult> DeleteActivityLog(int id)
        {
            var log = await _context.ActivityLogs.FindAsync(id);
            if (log == null) return NotFound();
            _context.ActivityLogs.Remove(log);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Activity log deleted" });
        }

        [HttpPost("activity-logs")]
        public async Task<IActionResult> CreateActivityLog([FromBody] CreateActivityLogRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrWhiteSpace(userId))
                return Unauthorized();

            var actionText = !string.IsNullOrWhiteSpace(request.Action)
                ? request.Action
                : request.Description;

            if (string.IsNullOrWhiteSpace(actionText))
                return BadRequest(new { message = "Action or description is required" });

            var activityLog = new ActivityLog
            {
                UserID = userId,
                Action = actionText,
                Type = string.IsNullOrWhiteSpace(request.Type) ? "Update" : request.Type,
                IPAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                Timestamp = DateTime.UtcNow
            };

            _context.ActivityLogs.Add(activityLog);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Activity logged successfully" });
        }

        // Plan Management
        [HttpGet("plans")]
        public async Task<IActionResult> GetPlans() => Ok(await _planService.GetAllPlansAsync());

        [Authorize(Roles = "SuperAdmin,Admin")]
        [HttpPut("plans/{id}")]
        public async Task<IActionResult> UpdatePlan(int id, [FromBody] UpdatePlanRequest request)
        {
            var success = await _planService.UpdatePlanAsync(id, request.PlanName, request.SpeedMbps ?? 0, request.Price ?? 0);
            return success ? Ok(new { message = "Plan updated successfully" }) : NotFound();
        }

        [Authorize(Roles = "SuperAdmin,Admin")]
        [HttpDelete("plans/{id}")]
        public async Task<IActionResult> DeletePlan(int id)
        {
            var success = await _planService.DeletePlanAsync(id);
            return success ? Ok(new { message = "Plan deleted successfully" }) : NotFound();
        }

        // Staff Management
        [Authorize(Roles = "SuperAdmin")]
        [HttpGet("staff")]
        public async Task<IActionResult> GetStaff() => Ok(await _staffService.GetAllStaffAsync());

        [Authorize(Roles = "SuperAdmin")]
        [HttpPost("staff")]
        public async Task<IActionResult> CreateStaff([FromBody] CreateStaffRequest request)
        {
            var (success, message) = await _staffService.CreateStaffAsync(request.Email, request.FirstName, request.LastName, request.Password, request.Role);
            return success ? Ok(new { message }) : BadRequest(new { message });
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpPut("staff/{id}")]
        public async Task<IActionResult> UpdateStaff(string id, [FromBody] UpdateStaffRequest request)
        {
            var success = await _staffService.UpdateStaffAsync(id, request.FirstName, request.LastName, request.Status, request.Role, request.Password);
            return success ? Ok(new { message = "Staff updated successfully" }) : NotFound();
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpDelete("staff/{id}")]
        public async Task<IActionResult> DeleteStaff(string id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound(new { message = "Staff not found" });

            if (user.Role == "SuperAdmin")
            {
                var superAdminCount = await _context.Users.CountAsync(u => u.Role == "SuperAdmin");
                if (superAdminCount <= 2)
                    return BadRequest(new { message = "Cannot delete SuperAdmin. Minimum 2 SuperAdmins required." });
            }

            var success = await _staffService.DeleteStaffAsync(id);
            return success ? Ok(new { message = "Staff deleted successfully" }) : NotFound();
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpPut("roles/{roleName}")]
        public async Task<IActionResult> UpdateRole(string roleName, [FromBody] UpdateRoleRequest request)
        {
            if (string.IsNullOrWhiteSpace(roleName) || request?.Permissions == null)
                return BadRequest(new { message = "Invalid role or permissions" });

            try
            {
                var existingPermissions = await _context.RolePermissions
                    .Where(rp => rp.RoleName == roleName)
                    .ToListAsync();

                _context.RolePermissions.RemoveRange(existingPermissions);

                var newPermissions = request.Permissions.Select(p => new RolePermission
                {
                    RoleName = roleName,
                    PermissionName = p,
                    CreatedAt = DateTime.UtcNow
                }).ToList();

                _context.RolePermissions.AddRange(newPermissions);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Role permissions updated successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [Authorize(Roles = "SuperAdmin,Admin,Staff")]
        [HttpGet("roles")]
        public async Task<IActionResult> GetRoles()
        {
            var adminUsers = await _context.Users
                .Where(u => u.Role == "Admin")
                .Select(u => new { id = u.Id, name = $"{u.FirstName} {u.LastName}", email = u.Email })
                .ToListAsync();

            var staffUsers = await _context.Users
                .Where(u => u.Role == "Staff")
                .Select(u => new { id = u.Id, name = $"{u.FirstName} {u.LastName}", email = u.Email })
                .ToListAsync();

            var adminPermissions = await _context.RolePermissions
                .Where(rp => rp.RoleName == "Admin")
                .Select(rp => rp.PermissionName)
                .ToListAsync();

            var staffPermissions = await _context.RolePermissions
                .Where(rp => rp.RoleName == "Staff")
                .Select(rp => rp.PermissionName)
                .ToListAsync();

            var roles = new object[]
            {
                new
                {
                    id = 1,
                    name = "Admin",
                    users = adminUsers.Count,
                    members = adminUsers,
                    permissions = adminPermissions.Count > 0 ? adminPermissions : new List<string>(),
                    color = "red"
                },
                new
                {
                    id = 2,
                    name = "Staff",
                    users = staffUsers.Count,
                    members = staffUsers,
                    permissions = staffPermissions.Count > 0 ? staffPermissions : new List<string>(),
                    color = "blue"
                }
            };

            return Ok(roles);
        }

        // FAQ Management
        [HttpGet("faqs")]
        public async Task<IActionResult> GetFAQs() => Ok(await _faqService.GetAllFAQsAsync());

        [HttpPost("faqs")]
        public async Task<IActionResult> CreateFAQ([FromBody] CreateFAQRequest request)
        {
            await _faqService.CreateFAQAsync(request.Question, request.Answer, request.Category, request.Status);
            return Ok(new { message = "FAQ created successfully" });
        }

        [HttpPut("faqs/{id}")]
        public async Task<IActionResult> UpdateFAQ(int id, [FromBody] UpdateFAQRequest request)
        {
            var success = await _faqService.UpdateFAQAsync(id, request.Question, request.Answer, request.Category, request.Status);
            return success ? Ok(new { message = "FAQ updated successfully" }) : NotFound();
        }

        [HttpDelete("faqs/{id}")]
        public async Task<IActionResult> DeleteFAQ(int id)
        {
            var success = await _faqService.DeleteFAQAsync(id);
            return success ? Ok(new { message = "FAQ deleted successfully" }) : NotFound();
        }

        // Prepaid WiFi Management

        // Promo Offer Management (templates customers can purchase)
        [HttpGet("promo-offers")]
        public async Task<IActionResult> GetPromoOffers()
        {
            var offers = await _context.PromoOffers
                .OrderByDescending(o => o.CreatedAt)
                .ToListAsync();
            return Ok(offers);
        }

        [HttpPost("promo-offers")]
        public async Task<IActionResult> CreatePromoOffer([FromBody] CreatePromoOfferRequest request)
        {
            var offer = new PromoOffer
            {
                Title = request.Title,
                Description = request.Description,
                Price = request.Price,
                Data = request.Data,
                Validity = request.Validity,
                Badge = request.Badge,
                Color = request.Color ?? "from-blue-500 to-blue-600",
                IsActive = true,
                CreatedAt = DateTime.UtcNow
            };
            _context.PromoOffers.Add(offer);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Promo offer created successfully", promoOfferID = offer.PromoOfferID });
        }

        [HttpPut("promo-offers/{id}")]
        public async Task<IActionResult> UpdatePromoOffer(int id, [FromBody] UpdatePromoOfferRequest request)
        {
            var offer = await _context.PromoOffers.FindAsync(id);
            if (offer == null) return NotFound(new { message = "Promo offer not found" });

            offer.Title = request.Title;
            offer.Description = request.Description;
            offer.Price = request.Price;
            offer.Data = request.Data;
            offer.Validity = request.Validity;
            offer.Badge = request.Badge;
            offer.Color = request.Color ?? offer.Color;
            offer.IsActive = request.IsActive;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Promo offer updated successfully" });
        }

        [HttpDelete("promo-offers/{id}")]
        public async Task<IActionResult> DeletePromoOffer(int id)
        {
            var offer = await _context.PromoOffers.FindAsync(id);
            if (offer == null) return NotFound(new { message = "Promo offer not found" });

            _context.PromoOffers.Remove(offer);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Promo offer deleted successfully" });
        }

        [HttpPost("prepaid/{id}/topup")]
        public async Task<IActionResult> AdminTopUpPrepaid(int id, [FromBody] AdminTopUpRequest request)
        {
            var prepaid = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id);

            if (prepaid == null) return NotFound(new { message = "Prepaid service not found" });
            if (request.Amount <= 0) return BadRequest(new { message = "Amount must be greater than 0" });

            prepaid.LoadAmount += request.Amount;
            prepaid.RemainingBalance = (prepaid.RemainingBalance ?? 0) + request.Amount;
            prepaid.LastReloadBalance = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Top-up successful",
                loadAmount = prepaid.LoadAmount,
                remainingBalance = prepaid.RemainingBalance,
                lastReload = prepaid.LastReloadBalance
            });
        }

        [HttpPut("prepaid/{id}/status")]
        public async Task<IActionResult> UpdatePrepaidStatus(int id, [FromBody] UpdatePrepaidStatusRequest request)
        {
            var prepaid = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id);

            if (prepaid == null) return NotFound(new { message = "Prepaid service not found" });

            prepaid.ServiceAccount.Status = request.Status;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Prepaid service status updated", status = request.Status });
        }

        [HttpDelete("prepaid/{id}")]
        public async Task<IActionResult> DeletePrepaidService(int id)
        {
            var prepaid = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                    .ThenInclude(sa => sa.Device)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id);

            if (prepaid == null) return NotFound(new { message = "Prepaid service not found" });

            _context.PrepaidLoads.Remove(prepaid);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Prepaid service deleted successfully" });
        }

        // Prepaid Promo Management
        [HttpGet("promos")]
        public async Task<IActionResult> GetAllPromos()
        {
            var promos = await _context.PrepaidPromos
                .Include(p => p.User)
                .Include(p => p.PrepaidLoad)
                .OrderByDescending(p => p.ActivatedAt)
                .Select(p => new
                {
                    p.PrepaidPromoID,
                    p.PrepaidLoadID,
                    p.UserID,
                    Customer = p.User.FirstName + " " + p.User.LastName,
                    Email = p.User.Email,
                    p.PromoTitle,
                    p.TotalDataMB,
                    p.RemainingDataMB,
                    UsedDataMB = p.TotalDataMB - p.RemainingDataMB,
                    p.ValidityDays,
                    p.ActivatedAt,
                    p.ExpiresAt,
                    p.Status
                })
                .ToListAsync();

            return Ok(promos);
        }

        [HttpPut("promos/{id}/status")]
        public async Task<IActionResult> UpdatePromoStatus(int id, [FromBody] UpdatePromoStatusRequest request)
        {
            var promo = await _context.PrepaidPromos.FindAsync(id);
            if (promo == null) return NotFound(new { message = "Promo not found" });

            promo.Status = request.Status;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Promo status updated", status = request.Status });
        }

        [HttpDelete("promos/{id}")]
        public async Task<IActionResult> DeletePromo(int id)
        {
            var promo = await _context.PrepaidPromos.FindAsync(id);
            if (promo == null) return NotFound(new { message = "Promo not found" });

            _context.PrepaidPromos.Remove(promo);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Promo deleted successfully" });
        }

        // Notifications (placeholder)
        [HttpGet("notifications")]
        public async Task<IActionResult> GetNotifications()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (userId == null) return Unauthorized();

            var notifications = await _context.Notifications
                .Where(n => n.UserID == userId)
                .OrderByDescending(n => n.SentAt)
                .ToListAsync();
            return Ok(notifications);
        }

        [HttpPost("notifications")]
        public async Task<IActionResult> CreateNotification([FromBody] CreateNotificationRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (userId == null) return Unauthorized();

            var notification = new Notification
            {
                UserID = userId,
                Message = request.Message,
                Type = request.Type ?? "info",
                Status = "unread",
                SentAt = DateTime.UtcNow
            };

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Notification created", notificationID = notification.NotificationID });
        }

        [HttpPost("notifications/mark-all-read")]
        public async Task<IActionResult> MarkAllNotificationsRead()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (userId == null) return Unauthorized();

            var notifications = await _context.Notifications
                .Where(n => n.UserID == userId && n.Status == "unread")
                .ToListAsync();

            foreach (var notification in notifications)
            {
                notification.Status = "read";
            }

            await _context.SaveChangesAsync();
            return Ok(new { message = "All notifications marked as read" });
        }

        [HttpDelete("notifications/{id}")]
        public async Task<IActionResult> DeleteNotification(int id)
        {
            var notification = await _context.Notifications.FindAsync(id);
            if (notification == null) return NotFound();

            _context.Notifications.Remove(notification);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Notification deleted" });
        }

        // System Settings
        [HttpGet("settings")]
        public async Task<IActionResult> GetSettings()
        {
            var settings = await _context.SystemSettings.FirstOrDefaultAsync();
            if (settings == null)
            {
                settings = new SystemSettings();
                _context.SystemSettings.Add(settings);
                await _context.SaveChangesAsync();
            }
            return Ok(settings);
        }

        [HttpPut("settings")]
        public async Task<IActionResult> UpdateSettings([FromBody] UpdateSystemSettingsRequest request)
        {
            var settings = await _context.SystemSettings.FirstOrDefaultAsync();
            if (settings == null)
            {
                settings = new SystemSettings();
                _context.SystemSettings.Add(settings);
            }

            settings.SiteName = request.SiteName ?? settings.SiteName;
            settings.SiteEmail = request.SiteEmail ?? settings.SiteEmail;
            settings.MaintenanceMode = request.MaintenanceMode ?? settings.MaintenanceMode;
            settings.MaxLoginAttempts = request.MaxLoginAttempts ?? settings.MaxLoginAttempts;
            settings.SessionTimeout = request.SessionTimeout ?? settings.SessionTimeout;
            settings.EnableTwoFactor = request.EnableTwoFactor ?? settings.EnableTwoFactor;
            settings.EnableAuditLogs = request.EnableAuditLogs ?? settings.EnableAuditLogs;
            settings.NotificationEmail = request.NotificationEmail ?? settings.NotificationEmail;
            settings.EmailOnNewTickets = request.EmailOnNewTickets ?? settings.EmailOnNewTickets;
            settings.EmailOnPaymentReceived = request.EmailOnPaymentReceived ?? settings.EmailOnPaymentReceived;
            settings.EmailOnSystemErrors = request.EmailOnSystemErrors ?? settings.EmailOnSystemErrors;
            settings.EmailOnSecurityAlerts = request.EmailOnSecurityAlerts ?? settings.EmailOnSecurityAlerts;
            settings.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Settings updated successfully", settings });
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpGet("superadmin-count")]
        public async Task<IActionResult> GetSuperAdminCount()
        {
            var superAdminRoleId = await _context.Roles
                .Where(r => r.Name == "SuperAdmin")
                .Select(r => r.Id)
                .FirstOrDefaultAsync();

            var count = 0;
            if (!string.IsNullOrEmpty(superAdminRoleId))
            {
                count = await _context.UserRoles
                    .CountAsync(ur => ur.RoleId == superAdminRoleId);
            }

            var canCreate = Math.Max(0, 2 - count);
            return Ok(new { count, canCreate });
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpGet("suspended-users")]
        public async Task<IActionResult> GetSuspendedUsers()
        {
            var suspendedUsers = await _context.LoginAttempts
                .Where(la => la.LockedUntil.HasValue && la.LockedUntil > DateTime.UtcNow)
                .Include(la => la.User)
                .OrderByDescending(la => la.LockedUntil)
                .Select(la => new
                {
                    la.LoginAttemptID,
                    la.UserID,
                    UserName = la.User.FirstName + " " + la.User.LastName,
                    Email = la.User.Email,
                    FailedAttempts = la.FailedAttempts,
                    LockReason = la.LockReason,
                    LockedUntil = la.LockedUntil,
                    RemainingMinutes = (int)Math.Ceiling((la.LockedUntil.Value - DateTime.UtcNow).TotalMinutes)
                })
                .ToListAsync();

            return Ok(suspendedUsers);
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpPost("unlock-user/{userId}")]
        public async Task<IActionResult> UnlockUser(string userId)
        {
            var attempt = await _context.LoginAttempts.FirstOrDefaultAsync(la => la.UserID == userId);
            if (attempt == null)
                return NotFound(new { message = "User not found" });

            attempt.FailedAttempts = 0;
            attempt.LockedUntil = null;
            attempt.LockReason = null;
            await _context.SaveChangesAsync();

            return Ok(new { message = "User unlocked successfully" });
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpPost("create-superadmin")]
        public async Task<IActionResult> CreateSuperAdmin([FromBody] CreateSuperAdminRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.Password))
                return BadRequest(new { message = "Email and password are required" });

            if (request.Password.Length < 6)
                return BadRequest(new { message = "Password must be at least 6 characters" });

            var existingUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
            if (existingUser != null)
                return BadRequest(new { message = "Email already exists" });

            var newUser = new ApplicationUser
            {
                UserName = request.Email,
                Email = request.Email,
                FirstName = request.FirstName ?? string.Empty,
                LastName = request.LastName ?? string.Empty,
                Role = "SuperAdmin",
                EmailConfirmed = true,
                Status = "Active"
            };

            var userManager = HttpContext.RequestServices.GetService(typeof(Microsoft.AspNetCore.Identity.UserManager<ApplicationUser>)) as Microsoft.AspNetCore.Identity.UserManager<ApplicationUser>;
            if (userManager == null) return BadRequest(new { message = "User manager not available" });

            var result = await userManager.CreateAsync(newUser, request.Password);
            if (!result.Succeeded)
                return BadRequest(new { message = string.Join(", ", result.Errors.Select(e => e.Description)) });

            await userManager.AddToRoleAsync(newUser, "SuperAdmin");

            return Ok(new { message = "SuperAdmin created successfully", userId = newUser.Id });
        }
    }

    // Request Models
    public class UpdateCustomerRequest
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
    }

    public class CreateStaffRequest
    {
        public string Email { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string Role { get; set; } = "Staff";
    }

    public class UpdateStaffRequest
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
        public string? Password { get; set; }
    }

    public class UpdatePlanRequest
    {
        public string PlanName { get; set; } = string.Empty;
        public decimal? SpeedMbps { get; set; }
        public decimal? Price { get; set; }
    }

    public class UpdateTicketRequest
    {
        public string Status { get; set; } = string.Empty;
        public string? AssignedStaffID { get; set; }
    }

    public class ReplyTicketRequest
    {
        public string Message { get; set; } = string.Empty;
    }

    public class UpdateSubscriptionRequest
    {
        public string Status { get; set; } = string.Empty;
        public int? PlanID { get; set; }
        public string? EndDate { get; set; }
    }

    public class CreateFAQRequest
    {
        public string Question { get; set; } = string.Empty;
        public string Answer { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public string Status { get; set; } = "Draft";
    }

    public class UpdateFAQRequest
    {
        public string Question { get; set; } = string.Empty;
        public string Answer { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
    }

    public class AdminTopUpRequest
    {
        public decimal Amount { get; set; }
    }

    public class UpdatePrepaidStatusRequest
    {
        public string Status { get; set; } = string.Empty;
    }

    public class UpdatePromoStatusRequest
    {
        public string Status { get; set; } = string.Empty;
    }

    public class CreatePromoOfferRequest
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string Data { get; set; } = string.Empty;
        public string Validity { get; set; } = string.Empty;
        public string? Badge { get; set; }
        public string? Color { get; set; }
    }

    public class CreateActivityLogRequest
    {
        public string Action { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
    }

    public class UpdatePromoOfferRequest
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string Data { get; set; } = string.Empty;
        public string Validity { get; set; } = string.Empty;
        public string? Badge { get; set; }
        public string? Color { get; set; }
        public bool IsActive { get; set; } = true;
    }

    public class UpdateRoleRequest
    {
        public string[]? Permissions { get; set; }
    }

    public class CreateNotificationRequest
    {
        public string Message { get; set; } = string.Empty;
        public string? Type { get; set; } = "info";
    }

    public class UpdateSystemSettingsRequest
    {
        public string? SiteName { get; set; }
        public string? SiteEmail { get; set; }
        public bool? MaintenanceMode { get; set; }
        public int? MaxLoginAttempts { get; set; }
        public int? SessionTimeout { get; set; }
        public bool? EnableTwoFactor { get; set; }
        public bool? EnableAuditLogs { get; set; }
        public string? NotificationEmail { get; set; }
        public bool? EmailOnNewTickets { get; set; }
        public bool? EmailOnPaymentReceived { get; set; }
        public bool? EmailOnSystemErrors { get; set; }
        public bool? EmailOnSecurityAlerts { get; set; }
    }

    public class CreateSuperAdminRequest
    {
        public string Email { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
}
