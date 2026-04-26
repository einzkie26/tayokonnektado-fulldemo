using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TayoKonnektado_project.Models
{
    public class Device
    {
        [Key]
        public int DeviceID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string? MACAddress { get; set; }
        public string? OPCCodeToken { get; set; }
        public string? DeviceType { get; set; }
        public string? Status { get; set; }
        public DateTime RegisteredAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
        public ICollection<SupportTicket> SupportTickets { get; set; } = new List<SupportTicket>();
        public ICollection<ServiceAccount> ServiceAccounts { get; set; } = new List<ServiceAccount>();
    }

    public class SupportTicket
    {
        [Key]
        public int TicketID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public int? DeviceID { get; set; }
        public string? AssignedStaffID { get; set; }
        public string Subject { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string? Category { get; set; }
        public string? Priority { get; set; }
        public string? AttachmentUrl { get; set; }
        public string? Status { get; set; }
        public bool IsArchived { get; set; } = false;
        public bool IsHiddenByCustomer { get; set; } = false;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
        [ForeignKey("DeviceID")]
        public Device? Device { get; set; }
        public ICollection<TicketReply> Replies { get; set; } = new List<TicketReply>();
    }

    public class TicketReply
    {
        [Key]
        public int ReplyID { get; set; }
        public int TicketID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public bool IsAdminReply { get; set; } = false;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("TicketID")]
        public SupportTicket Ticket { get; set; } = null!;
        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
    }

    public class Notification
    {
        [Key]
        public int NotificationID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public string? Type { get; set; }
        public DateTime SentAt { get; set; } = DateTime.UtcNow;
        public string? Status { get; set; }

        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
    }

    public class ServiceAccount
    {
        [Key]
        public int ServiceAccountID { get; set; }
        public int DeviceID { get; set; }
        public string? ServiceType { get; set; }
        public string? Status { get; set; }
        public DateTime ActivatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("DeviceID")]
        public Device Device { get; set; } = null!;
        public ICollection<Subscription> Subscriptions { get; set; } = new List<Subscription>();
        public ICollection<PrepaidLoad> PrepaidLoads { get; set; } = new List<PrepaidLoad>();
    }

    public class SubscriptionPlan
    {
        [Key]
        public int PlanID { get; set; }
        public string PlanName { get; set; } = string.Empty;
        public decimal? SpeedMbps { get; set; }
        public decimal? Price { get; set; }
        public ICollection<Subscription> Subscriptions { get; set; } = new List<Subscription>();
    }

    public class Subscription
    {
        [Key]
        public int SubscriptionID { get; set; }
        public int ServiceAccountID { get; set; }
        public int PlanID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string? DeviceName { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string? Status { get; set; }

        [ForeignKey("ServiceAccountID")]
        public ServiceAccount ServiceAccount { get; set; } = null!;
        [ForeignKey("PlanID")]
        public SubscriptionPlan Plan { get; set; } = null!;
        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
        public ICollection<Invoice> Invoices { get; set; } = new List<Invoice>();
    }

    public class PrepaidLoad
    {
        [Key]
        public int PrepaidLoadID { get; set; }
        public int ServiceAccountID { get; set; }
        public string? PhoneNumber { get; set; }
        public decimal LoadAmount { get; set; }
        public decimal? RemainingBalance { get; set; }
        public DateTime? LastReloadBalance { get; set; }

        [ForeignKey("ServiceAccountID")]
        public ServiceAccount ServiceAccount { get; set; } = null!;
    }

    public class PrepaidPromo
    {
        [Key]
        public int PrepaidPromoID { get; set; }
        public int PrepaidLoadID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string PromoTitle { get; set; } = string.Empty;
        public decimal TotalDataMB { get; set; }
        public decimal RemainingDataMB { get; set; }
        public int ValidityDays { get; set; }
        public DateTime ActivatedAt { get; set; } = DateTime.UtcNow;
        public DateTime ExpiresAt { get; set; }
        public string Status { get; set; } = "Active"; // Active, Depleted, Expired

        [ForeignKey("PrepaidLoadID")]
        public PrepaidLoad PrepaidLoad { get; set; } = null!;
        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
    }

    public class PromoOffer
    {
        [Key]
        public int PromoOfferID { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string Data { get; set; } = string.Empty;
        public string Validity { get; set; } = string.Empty;
        public string? Badge { get; set; }      
        public string Color { get; set; } = "from-blue-500 to-blue-600";
        public bool IsActive { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }

    public class Invoice
    {
        [Key]
        public int InvoiceID { get; set; }
        public int? SubscriptionID { get; set; }
        public int? PrepaidLoadID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public DateTime? DueDate { get; set; }
        public string? Status { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("SubscriptionID")]
        public Subscription? Subscription { get; set; }
        [ForeignKey("PrepaidLoadID")]
        public PrepaidLoad? PrepaidLoad { get; set; }
        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
        public ICollection<Payment> Payments { get; set; } = new List<Payment>();
    }

    public class Payment
    {
        [Key]
        public int PaymentID { get; set; }
        public int? InvoiceID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public decimal AmountPaid { get; set; }
        public string? PaymentMethod { get; set; }
        public string? ReferenceNum { get; set; }
        public DateTime PaymentDate { get; set; } = DateTime.UtcNow;
        public string? Status { get; set; }
        public bool IsArchived { get; set; } = false;

        [ForeignKey("InvoiceID")]
        public Invoice? Invoice { get; set; }
        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
    }

    public class Addon
    {
        [Key]
        public int AddonID { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public decimal Price { get; set; }
        public string BillingType { get; set; } = string.Empty;
        public string? Icon { get; set; }
        public string? Features { get; set; }
        public ICollection<UserAddon> UserAddons { get; set; } = new List<UserAddon>();
    }

    public class UserAddon
    {
        [Key]
        public int UserAddonID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public int AddonID { get; set; }
        public DateTime ActivatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? NextBillingDate { get; set; }
        public string Status { get; set; } = "Active";

        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
        [ForeignKey("AddonID")]
        public Addon Addon { get; set; } = null!;
    }

    public class ActivityLog
    {
        [Key]
        public int LogID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string Action { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty; // Create, Update, Delete, View
        public string? IPAddress { get; set; }
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;

        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
    }

    public class FAQ
    {
        [Key]
        public int FAQID { get; set; }
        public string Question { get; set; } = string.Empty;
        public string Answer { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public string Status { get; set; } = "Draft"; // Draft, Published
        public int Views { get; set; } = 0;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }
    }

    public class LoginHistory
    {
        [Key]
        public int LoginHistoryID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string Device { get; set; } = string.Empty;
        public string? Location { get; set; }
        public string? IPAddress { get; set; }
        public DateTime LoginTime { get; set; } = DateTime.UtcNow;

        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
    }

    public class NotificationPreference
    {
        [Key]
        public int PreferenceID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string NotificationType { get; set; } = string.Empty;
        public bool EmailEnabled { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }

        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
    }
}
