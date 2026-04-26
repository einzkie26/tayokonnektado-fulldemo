using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services.Admin
{
    public class TicketManagementService
    {
        private readonly ApplicationDbContext _context;
        private readonly EmailService _emailService;

        public TicketManagementService(ApplicationDbContext context, EmailService emailService)
        {
            _context = context;
            _emailService = emailService;
        }

        public async Task<object> GetAllTicketsAsync()
        {
            return await _context.SupportTickets
                .Include(t => t.User)
                .Select(t => new
                {
                    t.TicketID,
                    t.UserID,
                    t.Subject,
                    t.Description,
                    t.Category,
                    t.Priority,
                    t.AttachmentUrl,
                    t.Status,
                    t.AssignedStaffID,
                    t.CreatedAt,
                    t.IsArchived,
                    User = new
                    {
                        t.User.Email,
                        t.User.FirstName,
                        t.User.LastName
                    }
                })
                .ToListAsync();
        }

        public async Task<bool> UpdateTicketAsync(int id, string status, string? assignedStaffID)
        {
            var ticket = await _context.SupportTickets.FindAsync(id);
            if (ticket == null) return false;

            ticket.Status = status;
            ticket.AssignedStaffID = assignedStaffID;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ReplyToTicketAsync(int id, string userId, string message)
        {
            var ticket = await _context.SupportTickets
                .Include(t => t.User)
                .FirstOrDefaultAsync(t => t.TicketID == id);
            if (ticket == null) return false;

            var reply = new TicketReply
            {
                TicketID = id,
                UserID = userId,
                Message = message,
                IsAdminReply = true
            };
            _context.TicketReplies.Add(reply);

            ticket.Status = "In Progress";

            var notification = new Notification
            {
                UserID = ticket.UserID,
                Message = $"Admin replied to your ticket: {ticket.Subject}",
                Type = "Ticket Reply",
                Status = "Unread"
            };
            _context.Notifications.Add(notification);

            await _context.SaveChangesAsync();
            await SendTicketReplyEmailAsync(ticket, message);
            return true;
        }

        public async Task<bool> ArchiveTicketAsync(int id)
        {
            var ticket = await _context.SupportTickets.FindAsync(id);
            if (ticket == null || ticket.Status != "Closed") return false;

            ticket.IsArchived = true;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UnarchiveTicketAsync(int id)
        {
            var ticket = await _context.SupportTickets.FindAsync(id);
            if (ticket == null) return false;

            ticket.IsArchived = false;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteTicketAsync(int id)
        {
            var ticket = await _context.SupportTickets.Include(t => t.Replies).FirstOrDefaultAsync(t => t.TicketID == id);
            if (ticket == null) return false;
            if (ticket.Status != "Closed") return false;

            if (ticket.Replies != null && ticket.Replies.Any())
                _context.TicketReplies.RemoveRange(ticket.Replies);

            _context.SupportTickets.Remove(ticket);
            await _context.SaveChangesAsync();
            return true;
        }

        private async Task SendTicketReplyEmailAsync(SupportTicket ticket, string replyMessage)
        {
            try
            {
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
        .ticket-box {{ background-color: #E6F0FF; border-left: 4px solid #003366; padding: 20px; margin: 20px 0; border-radius: 4px; }}
        .reply-box {{ background-color: #f8f9fa; border-left: 4px solid #FDB913; padding: 15px; margin: 20px 0; border-radius: 4px; }}
        .label {{ color: #666; font-size: 12px; text-transform: uppercase; margin-bottom: 5px; }}
        .value {{ color: #003366; font-weight: 600; margin-bottom: 15px; }}
        .footer {{ background-color: #f8f9fa; padding: 20px; text-align: center; color: #666; font-size: 12px; }}
        .button {{ background-color: #FDB913; color: #003366; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; margin: 20px 0; font-weight: bold; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>Support Ticket Update</h1>
            <p style='margin: 10px 0 0 0; opacity: 0.9;'>TayoKonnektado Support</p>
        </div>
        <div class='content'>
            <p>Dear {ticket.User.FirstName} {ticket.User.LastName},</p>
            <p>Our support team has replied to your ticket.</p>
            
            <div class='ticket-box'>
                <div class='label'>Ticket ID</div>
                <div class='value'>#{ticket.TicketID}</div>
                <div class='label'>Subject</div>
                <div class='value'>{ticket.Subject}</div>
                <div class='label'>Status</div>
                <div class='value'>{ticket.Status}</div>
            </div>

            <div class='reply-box'>
                <div class='label'>Admin Response</div>
                <p style='margin: 10px 0 0 0; color: #333; line-height: 1.6;'>{replyMessage}</p>
            </div>

            <p style='color: #666; font-size: 14px; margin-top: 30px;'>
                You can view the full conversation and reply to this ticket by logging into your account.
            </p>

            <div style='text-align: center;'>
                <a href='#' class='button'>View Ticket</a>
            </div>
        </div>
        <div class='footer'>
            <p><strong>TayoKonnektado</strong></p>
            <p>Connecting Communities, Empowering Lives</p>
            <p style='margin-top: 15px;'>This is an automated message. Please do not reply to this email.</p>
        </div>
    </div>
</body>
</html>";

                await _emailService.SendEmailAsync(
                    ticket.User.Email!,
                    $"Support Ticket #{ticket.TicketID} - New Reply",
                    emailBody
                );
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to send ticket reply email: {ex.Message}");
            }
        }
    }
}
