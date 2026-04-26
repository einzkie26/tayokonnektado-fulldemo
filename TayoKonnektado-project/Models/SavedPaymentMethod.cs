using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TayoKonnektado_project.Models
{
    public class SavedPaymentMethod
    {
        [Key]
        public int PaymentMethodID { get; set; }
        public string UserID { get; set; } = string.Empty;
        public string PayMongoPaymentMethodId { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public string? Last4 { get; set; }
        public string? Brand { get; set; }
        public int? ExpMonth { get; set; }
        public int? ExpYear { get; set; }
        public bool IsDefault { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("UserID")]
        public ApplicationUser User { get; set; } = null!;
    }
}
