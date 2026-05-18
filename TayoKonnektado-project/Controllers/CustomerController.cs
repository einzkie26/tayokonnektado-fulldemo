using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;
using TayoKonnektado_project.Services;
using TayoKonnektado_project.Attributes;
using System.Text.Json;

namespace TayoKonnektado_project.Controllers
{
    [Authorize]
    [RequireEmailVerification]
    [ApiController]
    [Route("api/[controller]")]
    public class CustomerController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly PayMongoService _payMongoService;
        private readonly EmailService _emailService;
        private readonly IConfiguration _configuration;
        private readonly IHttpClientFactory _httpClientFactory;

        public CustomerController(ApplicationDbContext context, UserManager<ApplicationUser> userManager, PayMongoService payMongoService, EmailService emailService, IConfiguration configuration, IHttpClientFactory httpClientFactory)
        {
            _context = context;
            _userManager = userManager;
            _payMongoService = payMongoService;
            _emailService = emailService;
            _configuration = configuration;
            _httpClientFactory = httpClientFactory;
        }

        [HttpGet("profile")]
        public async Task<IActionResult> GetProfile()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound();

            return Ok(new { 
                id = user.Id,
                firstName = user.FirstName, 
                lastName = user.LastName, 
                email = user.Email, 
                birthday = user.Birthday,
                address = user.Address,
                profilePictureUrl = user.ProfilePictureUrl,
                status = user.Status, 
                role = user.Role,
                createdAt = user.CreatedAt
            });
        }

        [HttpPut("profile")]
        public async Task<IActionResult> UpdateProfile([FromBody] UpdateProfileRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound();

            user.FirstName = request.FirstName;
            user.LastName = request.LastName;
            if (!string.IsNullOrEmpty(request.Birthday))
                user.Birthday = DateTime.Parse(request.Birthday);
            if (!string.IsNullOrEmpty(request.Address))
                user.Address = request.Address;
                
            await _userManager.UpdateAsync(user);

            return Ok(new { message = "Profile updated successfully" });
        }

        [HttpPut("profile-photo")]
        public async Task<IActionResult> UpdateProfilePhoto([FromBody] UpdateProfilePhotoRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound();

            user.ProfilePictureUrl = request.PhotoUrl;
            await _userManager.UpdateAsync(user);

            return Ok(new { message = "Profile photo updated successfully", profilePictureUrl = user.ProfilePictureUrl });
        }

        [HttpGet("devices")]
        public async Task<IActionResult> GetDevices()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var devices = await _context.Devices.Where(d => d.UserID == userId).ToListAsync();
            return Ok(devices);
        }

        [HttpGet("tickets")]
        public async Task<IActionResult> GetTickets()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var tickets = await _context.SupportTickets
                .Include(t => t.Replies)
                    .ThenInclude(r => r.User)
                .Where(t => t.UserID == userId && !t.IsHiddenByCustomer)
                .Select(t => new
                {
                    t.TicketID,
                    t.Subject,
                    t.Description,
                    t.Category,
                    t.Priority,
                    t.Status,
                    t.AttachmentUrl,
                    t.CreatedAt,
                    UpdatedAt = t.Replies.Any() ? t.Replies.Max(r => r.CreatedAt) : t.CreatedAt,
                    Replies = t.Replies.OrderBy(r => r.CreatedAt).Select(r => new
                    {
                        r.ReplyID,
                        r.Message,
                        r.IsAdminReply,
                        r.CreatedAt,
                        UserName = r.User.FirstName + " " + r.User.LastName
                    }).ToList()
                })
                .OrderByDescending(t => t.UpdatedAt)
                .ToListAsync();
            return Ok(tickets);
        }

        [HttpPost("upload-image")]
        [RequestSizeLimit(10 * 1024 * 1024)]
        public async Task<IActionResult> UploadImage(IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest(new { message = "No file provided." });

            var allowed = new[] { "image/jpeg", "image/png", "image/gif", "image/webp" };
            if (!allowed.Contains(file.ContentType.ToLower()))
                return BadRequest(new { message = "Only JPEG, PNG, GIF, and WebP images are allowed." });

            if (file.Length > 5 * 1024 * 1024)
                return BadRequest(new { message = "Image must be under 5 MB." });

            var apiKey = _configuration["ImgBB:ApiKey"];
            if (string.IsNullOrEmpty(apiKey))
                return StatusCode(500, new { message = "Image upload service not configured." });

            using var ms = new MemoryStream();
            await file.CopyToAsync(ms);
            var base64 = Convert.ToBase64String(ms.ToArray());

            using var form = new MultipartFormDataContent();
            form.Add(new StringContent(base64), "image");

            var client = _httpClientFactory.CreateClient();
            var response = await client.PostAsync($"https://api.imgbb.com/1/upload?key={apiKey}", form);

            if (!response.IsSuccessStatusCode)
                return StatusCode(502, new { message = "Image upload to ImgBB failed." });

            var json = await response.Content.ReadAsStringAsync();
            using var doc = JsonDocument.Parse(json);
            var url = doc.RootElement.GetProperty("data").GetProperty("url").GetString();

            return Ok(new { url });
        }

        [HttpPost("tickets")]
        public async Task<IActionResult> CreateTicket([FromBody] CreateTicketRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound();

            var ticket = new SupportTicket
            {
                UserID = userId!,
                Subject = request.Subject,
                Description = request.Description,
                Category = request.Category,
                Priority = request.Priority,
                AttachmentUrl = request.AttachmentUrl,
                Status = "Open"
            };
            _context.SupportTickets.Add(ticket);
            await _context.SaveChangesAsync();

            var ticketPref = await _context.NotificationPreferences
                .FirstOrDefaultAsync(np => np.UserID == userId && np.NotificationType == "ticket-created");
            if (ticketPref?.EmailEnabled != false)
            {
                await _emailService.SendEmailAsync(
                    user.Email!,
                    "Support Ticket Created - TayoKonnektado",
                    $"Hello {user.FirstName},<br><br>Your support ticket <strong>#{ticket.TicketID}</strong> has been created successfully.<br><br><strong>Subject:</strong> {request.Subject}<br><strong>Category:</strong> {request.Category}<br><strong>Priority:</strong> {request.Priority}<br><br>Our team will review your request and respond shortly. You can track the status in your dashboard.<br><br>Thank you for contacting TayoKonnektado!"
                );
            }

            await _emailService.SendEmailAsync(
                "admin@tayokonnektado.com",
                $"New Support Ticket #{ticket.TicketID} - {request.Priority} Priority",
                $"A new support ticket has been created:<br><br><strong>Ticket ID:</strong> #{ticket.TicketID}<br><strong>Customer:</strong> {user.FirstName} {user.LastName} ({user.Email})<br><strong>Subject:</strong> {request.Subject}<br><strong>Category:</strong> {request.Category}<br><strong>Priority:</strong> {request.Priority}<br><strong>Description:</strong> {request.Description}<br><br>Please review and assign to staff."
            );

            var notification = new Notification
            {
                UserID = userId!,
                Message = $"Your support ticket #{ticket.TicketID} has been created. We'll respond shortly.",
                Type = "Ticket",
                Status = "Unread"
            };
            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Ticket created successfully", ticketId = ticket.TicketID });
        }

        [HttpDelete("tickets/{id}")]
        public async Task<IActionResult> DeleteTicket(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var ticket = await _context.SupportTickets.FirstOrDefaultAsync(t => t.TicketID == id && t.UserID == userId);
            if (ticket == null) return NotFound(new { message = "Ticket not found" });
            if (ticket.Status != "Closed") return BadRequest(new { message = "Only closed tickets can be deleted" });

            ticket.IsHiddenByCustomer = true;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Ticket removed successfully" });
        }

        [HttpPost("tickets/{id}/reply")]
        public async Task<IActionResult> ReplyToTicket(int id, [FromBody] CustomerReplyRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound();

            var ticket = await _context.SupportTickets
                .Include(t => t.Replies)
                .FirstOrDefaultAsync(t => t.TicketID == id && t.UserID == userId);
            if (ticket == null) return NotFound(new { message = "Ticket not found" });
            if (ticket.Status == "Closed") return BadRequest(new { message = "Cannot reply to a closed ticket" });

            var reply = new TicketReply
            {
                TicketID = id,
                UserID = userId!,
                Message = request.Message,
                IsAdminReply = false
            };
            _context.TicketReplies.Add(reply);

            if (ticket.Status == "Resolved") ticket.Status = "Pending";

            await _context.SaveChangesAsync();

            return Ok(new
            {
                replyID = reply.ReplyID,
                message = reply.Message,
                isAdminReply = reply.IsAdminReply,
                createdAt = reply.CreatedAt,
                userName = user.FirstName + " " + user.LastName
            });
        }

        [AllowAnonymous]
        [HttpGet("faqs")]
        public async Task<IActionResult> GetFAQs()
        {
            var faqs = await _context.FAQs
                .Where(f => f.Status == "Published")
                .OrderBy(f => f.Category)
                .ThenByDescending(f => f.CreatedAt)
                .Select(f => new { f.FAQID, f.Question, f.Answer, f.Category })
                .ToListAsync();
            return Ok(faqs);
        }

        [HttpGet("subscriptions")]
        public async Task<IActionResult> GetSubscriptions()
        {
            try
            {
                var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
                
                //Get plan subscriptions
                var subscriptions = await _context.Subscriptions
                    .Include(s => s.Plan)
                    .Include(s => s.ServiceAccount)
                        .ThenInclude(sa => sa.Device)
                    .Where(s => s.UserID == userId)
                    .Select(s => new
                    {
                        s.SubscriptionID,
                        s.PlanID,
                        s.UserID,
                        DeviceName = s.DeviceName ?? "",
                        s.StartDate,
                        s.EndDate,
                        s.Status,
                        Plan = new
                        {
                            s.Plan.PlanID,
                            s.Plan.PlanName,
                            s.Plan.SpeedMbps
                        },
                        MACAddress = s.ServiceAccount.Device.MACAddress ?? "",
                        ServiceType = "Subscription"
                    })
                    .ToListAsync();
                
                //Get prepaid services
                var prepaidServices = await _context.PrepaidLoads
                    .Where(p => p.ServiceAccount.Device.UserID == userId)
                    .Select(p => new
                    {
                        SubscriptionID = p.PrepaidLoadID,
                        PlanID = (int?)null,
                        UserID = userId,
                        DeviceName = "Prepaid WiFi",
                        StartDate = p.ServiceAccount.ActivatedAt,
                        EndDate = (DateTime?)null,
                        Status = p.ServiceAccount.Status,
                        Plan = (object?)null,
                        MACAddress = p.ServiceAccount.Device.MACAddress ?? "",
                        ServiceType = "Prepaid",
                        PhoneNumber = p.PhoneNumber,
                        RemainingBalance = p.RemainingBalance
                    })
                    .ToListAsync();
                
                var allServices = subscriptions.Cast<object>().Concat(prepaidServices.Cast<object>()).ToList();
                return Ok(allServices);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Failed to fetch subscriptions: {ex.Message}" });
            }
        }

        [HttpDelete("prepaid/{id}")]
        public async Task<IActionResult> DeletePrepaidService(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var prepaid = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                    .ThenInclude(sa => sa.Device)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id && p.ServiceAccount.Device.UserID == userId);
            
            if (prepaid == null) return NotFound(new { message = "Prepaid service not found" });
            
            _context.PrepaidLoads.Remove(prepaid);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Prepaid service deleted successfully" });
        }

        [HttpGet("prepaid/{id}/balance")]
        public async Task<IActionResult> GetPrepaidBalance(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var prepaid = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                    .ThenInclude(sa => sa.Device)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id && p.ServiceAccount.Device.UserID == userId);
            
            if (prepaid == null) return NotFound(new { message = "Prepaid service not found" });
            
            return Ok(new
            {
                prepaidLoadID = prepaid.PrepaidLoadID,
                phoneNumber = prepaid.PhoneNumber,
                loadAmount = prepaid.LoadAmount,
                remainingBalance = prepaid.RemainingBalance ?? 0,
                lastReload = prepaid.LastReloadBalance
            });
        }

        [HttpPost("prepaid/{id}/buy-promo")]
        public async Task<IActionResult> BuyPromo(int id, [FromBody] BuyPromoRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var prepaid = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                    .ThenInclude(sa => sa.Device)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id && p.ServiceAccount.Device.UserID == userId);
            
            if (prepaid == null) return NotFound(new { message = "Prepaid service not found" });
            if (request.Amount <= 0) return BadRequest(new { message = "Invalid amount" });
            if ((prepaid.RemainingBalance ?? 0) < request.Amount) return BadRequest(new { message = "Insufficient balance" });

            prepaid.RemainingBalance -= request.Amount;

            decimal totalDataMB = 0;
            if (!string.IsNullOrEmpty(request.PromoData))
            {
                if (request.PromoData.ToLower().Contains("unlimited"))
                    totalDataMB = 999999;
                else
                {
                    var numStr = new string(request.PromoData.Where(c => char.IsDigit(c) || c == '.').ToArray());
                    if (decimal.TryParse(numStr, out var gb))
                        totalDataMB = gb * 1024; // Convert GB to MB
                }
            }

            int validityDays = 30;
            if (!string.IsNullOrEmpty(request.PromoValidity))
            {
                var dayStr = new string(request.PromoValidity.Where(char.IsDigit).ToArray());
                if (int.TryParse(dayStr, out var days)) validityDays = days;
            }

            var promo = new PrepaidPromo
            {
                PrepaidLoadID = prepaid.PrepaidLoadID,
                UserID = userId!,
                PromoTitle = request.PromoTitle ?? "Unknown Promo",
                TotalDataMB = totalDataMB,
                RemainingDataMB = totalDataMB,
                ValidityDays = validityDays,
                ActivatedAt = DateTime.UtcNow,
                ExpiresAt = DateTime.UtcNow.AddDays(validityDays),
                Status = "Active"
            };
            _context.PrepaidPromos.Add(promo);

            var invoice = new Invoice
            {
                PrepaidLoadID = prepaid.PrepaidLoadID,
                UserID = userId!,
                Amount = request.Amount,
                DueDate = DateTime.UtcNow,
                Status = "Paid",
                CreatedAt = DateTime.UtcNow
            };
            _context.Invoices.Add(invoice);
            await _context.SaveChangesAsync();

            var payment = new Payment
            {
                UserID = userId!,
                InvoiceID = invoice.InvoiceID,
                AmountPaid = request.Amount,
                PaymentMethod = "Prepaid Balance",
                PaymentDate = DateTime.UtcNow,
                ReferenceNum = $"PROMO-{request.PromoTitle?.Replace(" ", "-").ToUpper() ?? "UNKNOWN"}-{DateTime.UtcNow:yyyyMMddHHmmss}",
                Status = "Completed"
            };
            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            return Ok(new { 
                message = "Promo purchased successfully", 
                remainingBalance = prepaid.RemainingBalance,
                paymentId = payment.PaymentID,
                promoId = promo.PrepaidPromoID,
                promoTitle = request.PromoTitle,
                promoData = request.PromoData,
                promoValidity = request.PromoValidity,
                totalDataMB,
                remainingDataMB = totalDataMB
            });
        }

        [HttpGet("prepaid/{id}/active-promos")]
        public async Task<IActionResult> GetActivePromos(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var prepaid = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                    .ThenInclude(sa => sa.Device)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id && p.ServiceAccount.Device.UserID == userId);
            
            if (prepaid == null) return NotFound(new { message = "Prepaid service not found" });

            var expiredPromos = await _context.PrepaidPromos
                .Where(p => p.PrepaidLoadID == id && p.UserID == userId && p.Status == "Active" && p.ExpiresAt <= DateTime.UtcNow)
                .ToListAsync();
            foreach (var ep in expiredPromos) ep.Status = "Expired";
            if (expiredPromos.Any()) await _context.SaveChangesAsync();

            var promos = await _context.PrepaidPromos
                .Where(p => p.PrepaidLoadID == id && p.UserID == userId && p.Status == "Active")
                .OrderByDescending(p => p.ActivatedAt)
                .Select(p => new {
                    p.PrepaidPromoID,
                    p.PromoTitle,
                    p.TotalDataMB,
                    p.RemainingDataMB,
                    p.ValidityDays,
                    p.ActivatedAt,
                    p.ExpiresAt,
                    p.Status
                })
                .ToListAsync();

            return Ok(promos);
        }

        [HttpPost("prepaid/{id}/topup-gcash")]
        public async Task<IActionResult> TopUpPrepaidGCash(int id, [FromBody] TopUpRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var prepaid = await _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                    .ThenInclude(sa => sa.Device)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id && p.ServiceAccount.Device.UserID == userId);
            
            if (prepaid == null) return NotFound(new { message = "Prepaid service not found" });
            if (request.Amount <= 0) return BadRequest(new { message = "Invalid amount" });
            if (request.Amount < 10) return BadRequest(new { message = "Minimum top-up amount is ₱10" });

            try
            {
                var invoice = new Invoice
                {
                    PrepaidLoadID = id,
                    UserID = userId!,
                    Amount = request.Amount,
                    DueDate = DateTime.UtcNow.AddMonths(1),
                    Status = "Pending"
                };
                _context.Invoices.Add(invoice);
                await _context.SaveChangesAsync();

                var (sourceId, checkoutUrl) = await _payMongoService.CreateSourceForPrepaidTopUp(request.Amount, id, $"Prepaid Top-up #{invoice.InvoiceID}");

                if (string.IsNullOrEmpty(checkoutUrl))
                {
                    return BadRequest(new { message = "Failed to generate checkout URL" });
                }

                var payment = new Payment
                {
                    UserID = userId!,
                    InvoiceID = invoice.InvoiceID,
                    AmountPaid = request.Amount,
                    PaymentMethod = "GCash",
                    PaymentDate = DateTime.UtcNow,
                    ReferenceNum = sourceId,
                    Status = "Pending"
                };
                _context.Payments.Add(payment);
                await _context.SaveChangesAsync();

                return Ok(new { checkoutUrl = checkoutUrl, paymentId = payment.PaymentID });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"TopUpPrepaidGCash error: {ex.Message}");
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("prepaid/{id}/topup-complete")]
        public async Task<IActionResult> CompletePrepaidTopUp(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var prepaid = await GetPrepaidLoadAsync(id, userId);
            if (prepaid == null)
                return NotFound(new { message = "Prepaid service not found" });

            var pendingPayment = await GetLatestPendingPaymentAsync(id, userId);
            if (pendingPayment == null)
                return await BuildNoPendingTopupResponseAsync(id, userId, prepaid);

            return await HandlePendingTopupAsync(pendingPayment, prepaid);
        }

        private Task<PrepaidLoad?> GetPrepaidLoadAsync(int id, string? userId)
        {
            return _context.PrepaidLoads
                .Include(p => p.ServiceAccount)
                    .ThenInclude(sa => sa.Device)
                .FirstOrDefaultAsync(p => p.PrepaidLoadID == id && p.ServiceAccount.Device.UserID == userId);
        }

        private Task<Payment?> GetLatestPendingPaymentAsync(int id, string? userId)
        {
            return _context.Payments
                .Include(p => p.Invoice)
                .Where(p => p.UserID == userId && p.Status == "Pending" && p.Invoice != null && p.Invoice.PrepaidLoadID == id)
                .OrderByDescending(p => p.PaymentDate)
                .FirstOrDefaultAsync();
        }

        private async Task<IActionResult> BuildNoPendingTopupResponseAsync(int id, string? userId, PrepaidLoad prepaid)
        {
            var alreadyCompleted = await _context.Payments
                .Include(p => p.Invoice)
                .Where(p => p.UserID == userId && p.Status == "Completed" && p.Invoice != null && p.Invoice.PrepaidLoadID == id)
                .OrderByDescending(p => p.PaymentDate)
                .FirstOrDefaultAsync();

            if (alreadyCompleted != null)
            {
                return Ok(new
                {
                    status = "Completed",
                    message = "Top-up already applied.",
                    amountAdded = alreadyCompleted.AmountPaid,
                    loadAmount = prepaid.LoadAmount,
                    remainingBalance = prepaid.RemainingBalance,
                    lastReload = prepaid.LastReloadBalance
                });
            }

            return Ok(new { status = "Pending", message = "No pending top-up payment found" });
        }

        private async Task<IActionResult> HandlePendingTopupAsync(Payment pendingPayment, PrepaidLoad prepaid)
        {
            try
            {
                var sourceStatus = await _payMongoService.GetSourceStatus(pendingPayment.ReferenceNum!);
                Console.WriteLine($"Prepaid topup source status for {pendingPayment.ReferenceNum}: {sourceStatus}");

                if (sourceStatus == "chargeable" || sourceStatus == "paid")
                    return await CompleteTopupAsync(pendingPayment, prepaid);

                if (sourceStatus == "cancelled" || sourceStatus == "expired")
                    return await FailTopupAsync(pendingPayment);

                return Ok(new { status = "Pending", message = "Payment is still processing. Please wait a moment." });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error checking prepaid topup source status: {ex.Message}");
                return Ok(new { status = "Pending", message = "Could not verify payment status. Please try again." });
            }
        }

        private async Task<IActionResult> CompleteTopupAsync(Payment pendingPayment, PrepaidLoad prepaid)
        {
            pendingPayment.Status = "Completed";
            pendingPayment.PaymentDate = DateTime.UtcNow;

            if (pendingPayment.Invoice != null)
                pendingPayment.Invoice.Status = "Paid";

            var amountAdded = pendingPayment.AmountPaid;
            prepaid.LoadAmount += amountAdded;
            prepaid.RemainingBalance = (prepaid.RemainingBalance ?? 0) + amountAdded;
            prepaid.LastReloadBalance = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return Ok(new
            {
                status = "Completed",
                message = "Top-up completed successfully!",
                amountAdded,
                loadAmount = prepaid.LoadAmount,
                remainingBalance = prepaid.RemainingBalance,
                lastReload = prepaid.LastReloadBalance
            });
        }

        private async Task<IActionResult> FailTopupAsync(Payment pendingPayment)
        {
            pendingPayment.Status = "Failed";
            if (pendingPayment.Invoice != null)
                pendingPayment.Invoice.Status = "Failed";

            await _context.SaveChangesAsync();
            return Ok(new { status = "Failed", message = "Payment was cancelled or expired." });
        }



        [HttpGet("invoices")]
        public async Task<IActionResult> GetInvoices()
        {
            try
            {
                var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
                var invoices = await _context.Invoices
                    .Include(i => i.Payments)
                    .Where(i => i.UserID == userId)
                    .OrderByDescending(i => i.CreatedAt)
                    .Select(i => new
                    {
                        i.InvoiceID,
                        i.SubscriptionID,
                        i.UserID,
                        i.Amount,
                        i.DueDate,
                        i.Status,
                        i.CreatedAt,
                        Payments = i.Payments.Select(p => new { p.PaymentID, p.Status, p.ReferenceNum }).ToList()
                    })
                    .ToListAsync();
                return Ok(invoices);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch invoices: {ex.Message}" });
            }
        }

        [HttpGet("payments")]
        public async Task<IActionResult> GetPayments()
        {
            try
            {
                var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
                var payments = await _context.Payments
                    .Where(p => p.UserID == userId)
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
                        p.Status
                    })
                    .ToListAsync();
                return Ok(payments);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch payments: {ex.Message}" });
            }
        }

        [HttpPut("subscriptions/{id}/name")]
        public async Task<IActionResult> UpdateSubscriptionName(int id, [FromBody] UpdateNameRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var subscription = await _context.Subscriptions.FirstOrDefaultAsync(s => s.SubscriptionID == id && s.UserID == userId);
            if (subscription == null) return NotFound();

            subscription.DeviceName = request.DeviceName;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Device name updated" });
        }

        [HttpPost("upgrade-plan")]
        public async Task<IActionResult> UpgradePlan([FromBody] UpgradePlanRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            var subscription = await _context.Subscriptions
                .Include(s => s.Plan)
                .FirstOrDefaultAsync(s => s.SubscriptionID == request.SubscriptionId && s.UserID == userId);
            if (subscription == null) return NotFound(new { message = $"Subscription #{request.SubscriptionId} not found for this account" });

            var oldPlan = subscription.Plan;
            var newPlan = await _context.SubscriptionPlans.FindAsync(request.NewPlanId);
            if (newPlan == null) return NotFound(new { message = "Plan not found" });

            var planChange = (oldPlan.SpeedMbps ?? 0) < (newPlan.SpeedMbps ?? 0) ? "upgraded" : "downgraded";
            subscription.PlanID = request.NewPlanId;
            await _context.SaveChangesAsync();

            var planPref = await _context.NotificationPreferences
                .FirstOrDefaultAsync(np => np.UserID == userId && np.NotificationType == "plan-change");
            if (planPref?.EmailEnabled != false)
            {
                try
                {
                    Console.WriteLine($"Sending email to {user!.Email} for plan {planChange}");
                    await _emailService.SendEmailAsync(
                        user!.Email!,
                        $"Plan {planChange.ToUpper()} - TayoKonnektado",
                        $"Hello {user.FirstName},<br><br>Your plan has been {planChange} from <strong>{oldPlan.PlanName}</strong> to <strong>{newPlan.PlanName}</strong>.<br><br>Thank you for choosing TayoKonnektado!"
                    );
                    Console.WriteLine("Email sent successfully!");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Failed to send plan change email: {ex.Message}");
                }
            }

            return Ok(new { message = $"Plan {planChange} successfully" });
        }

        [HttpPost("create-payment-intent")]
        public async Task<IActionResult> CreatePaymentIntent([FromBody] CreatePaymentIntentRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var invoice = await _context.Invoices.FirstOrDefaultAsync(i => i.InvoiceID == request.InvoiceId && i.UserID == userId);
            if (invoice == null) return NotFound(new { message = "Invoice not found" });

            var paymentIntentId = await _payMongoService.CreatePaymentIntent(invoice.Amount, $"Invoice #{invoice.InvoiceID}");
            return Ok(new { paymentIntentId, amount = invoice.Amount });
        }

        [HttpPost("save-payment-method")]
        public async Task<IActionResult> SavePaymentMethod([FromBody] SavePaymentMethodRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var details = new PaymentDetails
            {
                CardNumber = request.CardNumber,
                ExpMonth = request.ExpMonth,
                ExpYear = request.ExpYear,
                Cvc = request.Cvc
            };
            var paymentMethodId = await _payMongoService.CreatePaymentMethod("card", details);

            if (request.IsDefault)
            {
                var existingMethods = await _context.SavedPaymentMethods.Where(pm => pm.UserID == userId).ToListAsync();
                foreach (var method in existingMethods) method.IsDefault = false;
            }

            var savedMethod = new SavedPaymentMethod
            {
                UserID = userId!,
                PayMongoPaymentMethodId = paymentMethodId,
                Type = "card",
                Last4 = request.CardNumber.Substring(request.CardNumber.Length - 4),
                Brand = "Card",
                ExpMonth = request.ExpMonth,
                ExpYear = request.ExpYear,
                IsDefault = request.IsDefault
            };
            _context.SavedPaymentMethods.Add(savedMethod);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Payment method saved successfully", paymentMethodId = savedMethod.PaymentMethodID });
        }

        [HttpPost("save-gcash-method")]
        public async Task<IActionResult> SaveGCashMethod([FromBody] SaveGCashMethodRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

            //In test mode
            if (request.IsDefault)
            {
                var existingMethods = await _context.SavedPaymentMethods.Where(pm => pm.UserID == userId).ToListAsync();
                foreach (var method in existingMethods) method.IsDefault = false;
            }

            var savedMethod = new SavedPaymentMethod
            {
                UserID = userId!,
                PayMongoPaymentMethodId = "gcash_" + Guid.NewGuid().ToString(),
                Type = "gcash",
                Last4 = request.PhoneNumber,
                IsDefault = request.IsDefault
            };
            _context.SavedPaymentMethods.Add(savedMethod);
            await _context.SaveChangesAsync();

            return Ok(new { message = "GCash method saved successfully", paymentMethodId = savedMethod.PaymentMethodID });
        }

        [HttpGet("payment-methods")]
        public async Task<IActionResult> GetPaymentMethods()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var methods = await _context.SavedPaymentMethods.Where(pm => pm.UserID == userId).ToListAsync();
            return Ok(methods);
        }

        [HttpDelete("payment-methods/{id}")]
        public async Task<IActionResult> DeletePaymentMethod(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var method = await _context.SavedPaymentMethods.FirstOrDefaultAsync(pm => pm.PaymentMethodID == id && pm.UserID == userId);
            if (method == null) return NotFound();

            _context.SavedPaymentMethods.Remove(method);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Payment method deleted" });
        }

        [HttpPut("payment-methods/{id}/default")]
        public async Task<IActionResult> SetDefaultPaymentMethod(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var methods = await _context.SavedPaymentMethods.Where(pm => pm.UserID == userId).ToListAsync();
            foreach (var method in methods) method.IsDefault = method.PaymentMethodID == id;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Default payment method updated" });
        }

        [HttpPost("process-payment")]
        public async Task<IActionResult> ProcessPayment([FromBody] ProcessPaymentRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var invoice = await _context.Invoices.FirstOrDefaultAsync(i => i.InvoiceID == request.InvoiceId && i.UserID == userId);
            if (invoice == null) return NotFound(new { message = "Invoice not found" });
            if (invoice.Status != "Pending") return BadRequest(new { message = "Invoice is not pending" });

            // Block if already completed
            var completedPayment = await _context.Payments.FirstOrDefaultAsync(p => p.InvoiceID == request.InvoiceId && p.Status == "Completed");
            if (completedPayment != null) return BadRequest(new { message = "This invoice has already been paid" });

            // Remove any stale pending payment so user can retry
            var stalePending = await _context.Payments.FirstOrDefaultAsync(p => p.InvoiceID == request.InvoiceId && p.Status == "Pending");
            if (stalePending != null) _context.Payments.Remove(stalePending);

            //Create PayMongo Source
            var (sourceId, checkoutUrl) = await _payMongoService.CreateSource(invoice.Amount, $"Invoice #{invoice.InvoiceID}");

            //Create payment record as Pending
            var payment = new Payment
            {
                UserID = userId!,
                InvoiceID = request.InvoiceId,
                AmountPaid = invoice.Amount,
                PaymentMethod = "GCash",
                PaymentDate = DateTime.UtcNow,
                ReferenceNum = sourceId,
                Status = "Pending"
            };
            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Complete payment on GCash", paymentId = payment.PaymentID, checkoutUrl });
        }

        [HttpPost("cancel-payment/{invoiceId}")]
        public async Task<IActionResult> CancelPendingPayment(int invoiceId)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var payment = await _context.Payments.FirstOrDefaultAsync(p => p.InvoiceID == invoiceId && p.UserID == userId && p.Status == "Pending");
            if (payment == null) return NotFound(new { message = "No pending payment found" });

            _context.Payments.Remove(payment);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Payment cancelled" });
        }

        [AllowAnonymous]
        [HttpPost("paymongo-webhook")]
        public async Task<IActionResult> PayMongoWebhook([FromBody] JsonElement webhookData)
        {
            try
            {
                var eventType = webhookData.GetProperty("data").GetProperty("attributes").GetProperty("type").GetString();
                
                if (eventType == "payment.paid")
                {
                    var paymentIntentId = webhookData.GetProperty("data").GetProperty("attributes").GetProperty("data").GetProperty("attributes").GetProperty("payment_intent_id").GetString();
                    var payment = await _context.Payments.Include(p => p.Invoice).FirstOrDefaultAsync(p => p.ReferenceNum == paymentIntentId);
                    if (payment != null)
                    {
                        Console.WriteLine($"Payment {payment.PaymentID} completed on PayMongo. Waiting for admin confirmation.");
                    }
                }
                
                return Ok();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Webhook error: {ex.Message}");
                return Ok(); // Always return 200 to PayMongo
            }
        }

        [HttpPost("sync-payment-status/{invoiceId}")]
        public async Task<IActionResult> SyncPaymentStatus(int invoiceId)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var payment = await _context.Payments.Include(p => p.Invoice)
                .FirstOrDefaultAsync(p => p.InvoiceID == invoiceId && p.UserID == userId);

            if (payment == null) return NotFound(new { message = "Payment not found" });

            // Already confirmed by admin
            if (payment.Status == "Completed")
                return Ok(new { message = "Payment confirmed by admin!", status = "Completed" });

            // Just report current status — only admin can move this to Completed
            return Ok(new { message = "Payment submitted. Awaiting admin confirmation.", status = payment.Status });
        }

        [HttpGet("addons")]
        public async Task<IActionResult> GetAddons()
        {
            var addons = await _context.Addons.ToListAsync();
            return Ok(addons);
        }

        [HttpGet("user-addons")]
        public async Task<IActionResult> GetUserAddons()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var userAddons = await _context.UserAddons
                .Where(ua => ua.UserID == userId)
                .Select(ua => new
                {
                    ua.UserAddonID,
                    ua.AddonID,
                    ua.ActivatedAt,
                    ua.NextBillingDate,
                    ua.Status,
                    Addon = new
                    {
                        ua.Addon.AddonID,
                        ua.Addon.Name,
                        ua.Addon.Description,
                        ua.Addon.Price,
                        ua.Addon.BillingType,
                        ua.Addon.Icon,
                        ua.Addon.Features
                    }
                })
                .ToListAsync();
            return Ok(userAddons);
        }

        [HttpPost("add-addon")]
        public async Task<IActionResult> AddAddon([FromBody] AddAddonRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var addon = await _context.Addons.FindAsync(request.AddonId);
            if (addon == null) return NotFound(new { message = "Addon not found" });

            var existing = await _context.UserAddons.FirstOrDefaultAsync(ua => ua.UserID == userId && ua.AddonID == request.AddonId && ua.Status == "Active");
            if (existing != null) return BadRequest(new { message = "Addon already active" });

            var userAddon = new UserAddon
            {
                UserID = userId!,
                AddonID = request.AddonId,
                NextBillingDate = addon.BillingType == "monthly" ? DateTime.UtcNow.AddMonths(1) : null
            };
            _context.UserAddons.Add(userAddon);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Addon added successfully", userAddonId = userAddon.UserAddonID });
        }

        [HttpDelete("user-addons/{id}")]
        public async Task<IActionResult> RemoveAddon(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var userAddon = await _context.UserAddons.FirstOrDefaultAsync(ua => ua.UserAddonID == id && ua.UserID == userId);
            if (userAddon == null) return NotFound();

            userAddon.Status = "Cancelled";
            await _context.SaveChangesAsync();
            return Ok(new { message = "Addon removed successfully" });
        }

        [HttpPost("generate-invoice")]
        public async Task<IActionResult> GenerateInvoice()
        {
            try
            {
                var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
                var subscriptions = await _context.Subscriptions
                    .Where(s => s.UserID == userId && s.Status == "Active")
                    .Select(s => new { s.SubscriptionID, s.PlanID })
                    .ToListAsync();
                if (subscriptions.Count == 0) return NotFound(new { message = "No active subscription" });

                var generatedInvoices = new List<object>();
                foreach (var subscription in subscriptions)
                {
                    var existingInvoice = await _context.Invoices
                        .FirstOrDefaultAsync(i => i.SubscriptionID == subscription.SubscriptionID && i.Status == "Pending");
                    if (existingInvoice != null)
                    {
                        generatedInvoices.Add(new { invoice = existingInvoice, message = "Invoice already exists" });
                        continue;
                    }

                    var plan = await _context.SubscriptionPlans
                        .Where(p => p.PlanID == subscription.PlanID)
                        .Select(p => new { p.Price })
                        .FirstOrDefaultAsync();
                    var invoice = new Invoice
                    {
                        SubscriptionID = subscription.SubscriptionID,
                        UserID = userId!,
                        Amount = plan?.Price ?? 1299.00m,
                        DueDate = DateTime.UtcNow.AddMonths(1),
                        Status = "Pending"
                    };
                    _context.Invoices.Add(invoice);
                    generatedInvoices.Add(new { invoice, message = "Invoice generated" });
                }
                await _context.SaveChangesAsync();

                return Ok(new { message = "Invoices generated", invoices = generatedInvoices });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to generate invoice: {ex.Message}" });
            }
        }

        [HttpGet("notifications")]
        public async Task<IActionResult> GetNotifications()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var notifications = await _context.Notifications
                .Where(n => n.UserID == userId)
                .OrderByDescending(n => n.SentAt)
                .Take(10)
                .ToListAsync();
            return Ok(notifications);
        }

        [HttpPut("notifications/{id}/read")]
        public async Task<IActionResult> MarkNotificationAsRead(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var notification = await _context.Notifications.FirstOrDefaultAsync(n => n.NotificationID == id && n.UserID == userId);
            if (notification == null) return NotFound();
            notification.Status = "Read";
            await _context.SaveChangesAsync();
            return Ok(new { message = "Notification marked as read" });
        }

        [HttpDelete("notifications/{id}")]
        public async Task<IActionResult> DeleteNotification(int id)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var notification = await _context.Notifications.FirstOrDefaultAsync(n => n.NotificationID == id && n.UserID == userId);
            if (notification == null) return NotFound();
            _context.Notifications.Remove(notification);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Notification deleted" });
        }

        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            var isCurrentPasswordValid = await _userManager.CheckPasswordAsync(user, request.CurrentPassword);
            if (!isCurrentPasswordValid) return BadRequest(new { message = "Current password is incorrect" });

            var result = await _userManager.ChangePasswordAsync(user, request.CurrentPassword, request.NewPassword);
            if (!result.Succeeded)
            {
                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                return BadRequest(new { message = errors });
            }

            // Check notification preference before sending email
            var passwordPref = await _context.NotificationPreferences
                .FirstOrDefaultAsync(np => np.UserID == userId && np.NotificationType == "password-change");
            if (passwordPref?.EmailEnabled != false)
            {
                await _emailService.SendEmailAsync(
                    user.Email!,
                    "Password Changed - TayoKonnektado",
                    $"Hello {user.FirstName},<br><br>Your password has been successfully changed.<br><br>If you did not make this change, please contact support immediately."
                );
            }

            return Ok(new { message = "Password changed successfully" });
        }

        [HttpGet("login-history")]
        public async Task<IActionResult> GetLoginHistory()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var loginHistory = await _context.LoginHistory
                .Where(lh => lh.UserID == userId)
                .OrderByDescending(lh => lh.LoginTime)
                .Take(10)
                .Select(lh => new
                {
                    lh.LoginHistoryID,
                    lh.Device,
                    lh.Location,
                    lh.LoginTime,
                    lh.IPAddress,
                    Current = lh.LoginTime > DateTime.UtcNow.AddHours(-1)
                })
                .ToListAsync();
            return Ok(loginHistory);
        }

        [HttpPost("enable-2fa")]
        public async Task<IActionResult> Enable2FA()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            var code = new Random().Next(100000, 999999).ToString();
            _context.VerificationCodes.Add(new VerificationCode
            {
                Email = user.Email!,
                Code = code,
                ExpiresAt = DateTime.UtcNow.AddMinutes(10)
            });
            await _context.SaveChangesAsync();
            await _emailService.SendEmailAsync(user.Email!, "Enable 2FA - TayoKonnektado", $"Your verification code is: {code}");

            return Ok(new { message = "Verification code sent to your email" });
        }

        [HttpPost("verify-2fa-setup")]
        public async Task<IActionResult> Verify2FASetup([FromBody] VerifyCodeRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            var verification = await _context.VerificationCodes
                .FirstOrDefaultAsync(v => v.Email == user.Email && v.Code == request.Code && !v.IsUsed && v.ExpiresAt > DateTime.UtcNow);
            if (verification == null) return BadRequest(new { message = "Invalid or expired code" });

            await _context.Users.Where(u => u.Id == userId).ExecuteUpdateAsync(u => u.SetProperty(p => p.TwoFactorEnabled, true));
            
            verification.IsUsed = true;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Two-factor authentication enabled successfully" });
        }

        [HttpPost("disable-2fa")]
        public async Task<IActionResult> Disable2FA()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            var code = new Random().Next(100000, 999999).ToString();
            _context.VerificationCodes.Add(new VerificationCode
            {
                Email = user.Email!,
                Code = code,
                ExpiresAt = DateTime.UtcNow.AddMinutes(10)
            });
            await _context.SaveChangesAsync();
            await _emailService.SendEmailAsync(user.Email!, "Disable 2FA - TayoKonnektado", $"Your verification code to disable 2FA is: {code}");

            return Ok(new { message = "Verification code sent to your email" });
        }

        [HttpPost("verify-disable-2fa")]
        public async Task<IActionResult> VerifyDisable2FA([FromBody] VerifyCodeRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            var verification = await _context.VerificationCodes
                .FirstOrDefaultAsync(v => v.Email == user.Email && v.Code == request.Code && !v.IsUsed && v.ExpiresAt > DateTime.UtcNow);
            if (verification == null) return BadRequest(new { message = "Invalid or expired code" });

            // Update directly in database
            await _context.Users.Where(u => u.Id == userId).ExecuteUpdateAsync(u => u.SetProperty(p => p.TwoFactorEnabled, false));
            
            verification.IsUsed = true;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Two-factor authentication disabled successfully" });
        }

        [HttpGet("2fa-status")]
        public async Task<IActionResult> Get2FAStatus()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            return Ok(new { twoFactorEnabled = user.TwoFactorEnabled });
        }

        [HttpPost("set-security-pin")]
        public async Task<IActionResult> SetSecurityPin([FromBody] SetPinRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            user.SecurityPin = request.Pin;
            user.PinProtectionEnabled = true;
            await _userManager.UpdateAsync(user);
            return Ok(new { message = "Security PIN set successfully" });
        }

        [HttpPost("verify-security-pin")]
        public async Task<IActionResult> VerifySecurityPin([FromBody] VerifyPinRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            if (user.SecurityPin != request.Pin)
                return BadRequest(new { message = "Invalid PIN" });

            return Ok(new { message = "PIN verified successfully" });
        }

        [HttpPost("toggle-pin-protection")]
        public async Task<IActionResult> TogglePinProtection()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            // If currently enabled, require verification to disable
            if (user.PinProtectionEnabled)
            {
                var code = new Random().Next(100000, 999999).ToString();
                _context.VerificationCodes.Add(new VerificationCode
                {
                    Email = user.Email!,
                    Code = code,
                    ExpiresAt = DateTime.UtcNow.AddMinutes(10)
                });
                await _context.SaveChangesAsync();
                await _emailService.SendEmailAsync(user.Email!, "Disable PIN Protection - TayoKonnektado", $"Your verification code to disable PIN protection is: {code}");

                return Ok(new { requiresVerification = true, message = "Verification code sent to your email" });
            }
            else
            {
                // Enable without verification
                user.PinProtectionEnabled = true;
                await _userManager.UpdateAsync(user);
                return Ok(new { pinProtectionEnabled = true });
            }
        }

        [HttpPost("verify-disable-pin")]
        public async Task<IActionResult> VerifyDisablePin([FromBody] VerifyCodeRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            var verification = await _context.VerificationCodes
                .FirstOrDefaultAsync(v => v.Email == user.Email && v.Code == request.Code && !v.IsUsed && v.ExpiresAt > DateTime.UtcNow);
            if (verification == null) return BadRequest(new { message = "Invalid or expired code" });

            user.PinProtectionEnabled = false;
            await _userManager.UpdateAsync(user);
            verification.IsUsed = true;
            await _context.SaveChangesAsync();

            return Ok(new { pinProtectionEnabled = false, message = "PIN protection disabled successfully" });
        }

        [HttpGet("pin-status")]
        public async Task<IActionResult> GetPinStatus()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var user = await _userManager.FindByIdAsync(userId!);
            if (user == null) return NotFound(new { message = "User not found" });

            return Ok(new { 
                pinProtectionEnabled = user.PinProtectionEnabled,
                hasPinSet = !string.IsNullOrEmpty(user.SecurityPin)
            });
        }

        [HttpGet("notification-preferences")]
        public async Task<IActionResult> GetNotificationPreferences()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var preferences = await _context.NotificationPreferences
                .Where(np => np.UserID == userId)
                .ToDictionaryAsync(np => np.NotificationType, np => np.EmailEnabled);
            return Ok(preferences);
        }

        [HttpPost("notification-preferences")]
        public async Task<IActionResult> UpdateNotificationPreferences([FromBody] Dictionary<string, bool> preferences)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            
            foreach (var pref in preferences)
            {
                var existing = await _context.NotificationPreferences
                    .FirstOrDefaultAsync(np => np.UserID == userId && np.NotificationType == pref.Key);
                
                if (existing != null)
                {
                    existing.EmailEnabled = pref.Value;
                    existing.UpdatedAt = DateTime.UtcNow;
                }
                else
                {
                    _context.NotificationPreferences.Add(new NotificationPreference
                    {
                        UserID = userId!,
                        NotificationType = pref.Key,
                        EmailEnabled = pref.Value
                    });
                }
            }
            
            await _context.SaveChangesAsync();
            return Ok(new { message = "Notification preferences updated successfully" });
        }
    }

    public class UpdateProfileRequest
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string? Birthday { get; set; }
        public string? Address { get; set; }
    }

    public class UpdateProfilePhotoRequest
    {
        public string? PhotoUrl { get; set; }
    }

    public class CreateTicketRequest
    {
        public string Subject { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public string Priority { get; set; } = string.Empty;
        public string? AttachmentUrl { get; set; }
    }

    public class CustomerReplyRequest
    {
        public string Message { get; set; } = string.Empty;
    }

    public class UpgradePlanRequest
    {
        public int SubscriptionId { get; set; }
        public int NewPlanId { get; set; }
    }

    public class CreatePaymentIntentRequest
    {
        public int InvoiceId { get; set; }
    }

    public class ProcessPaymentRequest
    {
        public int InvoiceId { get; set; }
        public string PaymentMethod { get; set; } = string.Empty;
        public string? PaymentIntentId { get; set; }
        public string? CardNumber { get; set; }
        public int ExpMonth { get; set; }
        public int ExpYear { get; set; }
        public string? Cvc { get; set; }
    }

    public class SavePaymentMethodRequest
    {
        public string CardNumber { get; set; } = string.Empty;
        public int ExpMonth { get; set; }
        public int ExpYear { get; set; }
        public string Cvc { get; set; } = string.Empty;
        public bool IsDefault { get; set; }
    }

    public class SaveGCashMethodRequest
    {
        public string PhoneNumber { get; set; } = string.Empty;
        public bool IsDefault { get; set; }
    }

    public class ConfirmGCashMethodRequest
    {
        public string PhoneNumber { get; set; } = string.Empty;
        public bool IsDefault { get; set; }
    }

    public class AddAddonRequest
    {
        public int AddonId { get; set; }
    }

    public class UpdateNameRequest
    {
        public string DeviceName { get; set; } = string.Empty;
    }

    public class ChangePasswordRequest
    {
        public string CurrentPassword { get; set; } = string.Empty;
        public string NewPassword { get; set; } = string.Empty;
    }

    public class VerifyCodeRequest
    {
        public string Code { get; set; } = string.Empty;
    }

    public class SetPinRequest
    {
        public string Pin { get; set; } = string.Empty;
    }

    public class VerifyPinRequest
    {
        public string Pin { get; set; } = string.Empty;
    }

    public class TopUpRequest
    {
        public decimal Amount { get; set; }
    }

    public class BuyPromoRequest
    {
        public decimal Amount { get; set; }
        public string? PromoTitle { get; set; }
        public string? PromoData { get; set; }
        public string? PromoValidity { get; set; }
    }
}
