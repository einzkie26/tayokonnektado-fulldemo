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
        public async Task<IActionResult> GetActivityLogs() => Ok(await _dashboardService.GetActivityLogsAsync());

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
            var success = await _staffService.DeleteStaffAsync(id);
            return success ? Ok(new { message = "Staff deleted successfully" }) : NotFound();
        }

        [Authorize(Roles = "SuperAdmin")]
        [HttpGet("roles")]
        public IActionResult GetRoles() => Ok(new List<object>());

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
        public IActionResult GetNotifications() => Ok(new List<object>());

        [HttpPost("notifications/mark-all-read")]
        public IActionResult MarkAllNotificationsRead() => Ok(new { message = "All notifications marked as read" });

        [HttpDelete("notifications/{id}")]
        public IActionResult DeleteNotification(int id) => Ok(new { message = "Notification deleted" });
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
}
