using Microsoft.AspNetCore.Identity;

namespace TayoKonnektado_project.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public DateTime? Birthday { get; set; }
        public string? Address { get; set; }
        public string? ProfilePictureUrl { get; set; }
        public string? Role { get; set; }
        public string? Status { get; set; }
        public bool TwoFactorEnabled { get; set; } = false;
        public string? SecurityPin { get; set; }
        public bool PinProtectionEnabled { get; set; } = false;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public ICollection<Device> Devices { get; set; } = new List<Device>();
        public ICollection<SupportTicket> SupportTickets { get; set; } = new List<SupportTicket>();
        public ICollection<Notification> Notifications { get; set; } = new List<Notification>();
        public ICollection<Subscription> Subscriptions { get; set; } = new List<Subscription>();
        public ICollection<Invoice> Invoices { get; set; } = new List<Invoice>();
        public ICollection<Payment> Payments { get; set; } = new List<Payment>();
    }
}
