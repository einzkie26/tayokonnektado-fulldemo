using System.ComponentModel.DataAnnotations;

namespace TayoKonnektado_project.Models
{
    public class VerificationCode
    {
        [Key]
        public int Id { get; set; }
        public string Email { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public DateTime ExpiresAt { get; set; }
        public bool IsUsed { get; set; } = false;
    }

    public class OnboardingStatus
    {
        [Key]
        public int Id { get; set; }
        public string UserID { get; set; } = string.Empty;
        public bool IsEmailVerified { get; set; } = false;
        public bool HasSelectedServiceType { get; set; } = false;
        public bool HasRegisteredDevice { get; set; } = false;
        public bool HasCompletedTutorial { get; set; } = false;
    }
}
