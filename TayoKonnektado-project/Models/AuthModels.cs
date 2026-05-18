using System.ComponentModel.DataAnnotations;

namespace TayoKonnektado_project.Models
{
    public class RegisterRequest
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;
        [Required]
        [MinLength(12)]
        public string Password { get; set; } = string.Empty;
        [Required]
        public string FirstName { get; set; } = string.Empty;
        [Required]
        public string LastName { get; set; } = string.Empty;
        public DateTime? Birthday { get; set; }
        public string? Address { get; set; }
        [Required]
        public string CaptchaToken { get; set; } = string.Empty;
    }

    public class VerifyEmailRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
    }

    public class SelectServiceTypeRequest
    {
        public string ServiceType { get; set; } = string.Empty;
    }

    public class RegisterDeviceRequest
    {
        public string MACAddress { get; set; } = string.Empty;
        public int? PlanID { get; set; }
        public string? ServiceType { get; set; }
        public string? PhoneNumber { get; set; }
    }

    public class LoginRequest
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;
        [Required]
        public string Password { get; set; } = string.Empty;
        [Required]
        public string CaptchaToken { get; set; } = string.Empty;
    }

    public class GoogleLoginRequest
    {
        public string Email { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string GoogleToken { get; set; } = string.Empty;
    }

    public class ResetPasswordRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public string NewPassword { get; set; } = string.Empty;
    }

    public class AuthResponse
    {
        public string Token { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? Role { get; set; }
        public DateTime Expiration { get; set; }
    }
}
