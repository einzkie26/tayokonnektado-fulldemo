using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using System.Text.Json.Serialization;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;
using TayoKonnektado_project.Services;
using TayoKonnektado_project.Services.Security;
using TayoKonnektado_project.Attributes;

namespace TayoKonnektado_project.Controllers
{
    [EnableRateLimiting("auth")]
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly TokenService _tokenService;
        private readonly EmailService _emailService;
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly LoginAttemptService _loginAttemptService;
        private readonly IpDeviceReputationService _ipDeviceReputationService;
        private readonly PasswordBreachService _passwordBreachService;

        public AuthController(
            UserManager<ApplicationUser> userManager,
            TokenService tokenService,
            EmailService emailService,
            ApplicationDbContext context,
            IConfiguration configuration,
            IHttpClientFactory httpClientFactory,
            LoginAttemptService loginAttemptService,
            IpDeviceReputationService ipDeviceReputationService,
            PasswordBreachService passwordBreachService)
        {
            _userManager = userManager;
            _tokenService = tokenService;
            _emailService = emailService;
            _context = context;
            _configuration = configuration;
            _httpClientFactory = httpClientFactory;
            _loginAttemptService = loginAttemptService;
            _ipDeviceReputationService = ipDeviceReputationService;
            _passwordBreachService = passwordBreachService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            try
            {
                var userAgent = Request.Headers["User-Agent"].ToString();
                var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();
                if (_ipDeviceReputationService.IsBlocked(ipAddress, userAgent, out var blockReason))
                    return StatusCode(429, new { message = $"Access blocked: {blockReason}. Please try again later." });

                if (!await VerifyReCaptchaAsync(request.CaptchaToken))
                    return BadRequest(new { message = "Captcha verification failed" });

                if (!request.Email.EndsWith("@gmail.com", StringComparison.OrdinalIgnoreCase))
                    return BadRequest(new { message = "Only Gmail addresses are allowed" });

                if (await _passwordBreachService.IsBreachedAsync(request.Password))
                    return BadRequest(new { message = "Password has been found in a breach. Please choose a different password." });

                var existingUser = await _userManager.FindByEmailAsync(request.Email);
                if (existingUser != null)
                    return BadRequest(new { message = "Email address already registered. Please try another email." });

                var user = new ApplicationUser 
                { 
                    UserName = request.Email, 
                    Email = request.Email,
                    FirstName = request.FirstName,
                    LastName = request.LastName,
                    Birthday = request.Birthday,
                    Address = request.Address,
                    Status = "Pending"
                };
                var result = await _userManager.CreateAsync(user, request.Password);

                if (!result.Succeeded)
                {
                    var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                    return BadRequest(new { message = errors });
                }

                var code = new Random().Next(100000, 999999).ToString();
                _context.VerificationCodes.Add(new VerificationCode
                {
                    Email = request.Email,
                    Code = code,
                    ExpiresAt = DateTime.UtcNow.AddMinutes(10)
                });

                _context.OnboardingStatuses.Add(new OnboardingStatus
                {
                    UserID = user.Id
                });

                await _context.SaveChangesAsync();
                await _emailService.SendVerificationCodeAsync(request.Email, code);

                await LogActivityAsync(user.Id, "Registered account", "Create");

                _ipDeviceReputationService.RegisterSuccess(ipAddress, userAgent);

                return Ok(new { message = "Registration successful. Please check your email for verification code." });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Registration failed: {ex.Message}" });
            }
        }

        [HttpPost("verify-email")]
        public async Task<IActionResult> VerifyEmail([FromBody] VerifyEmailRequest request)
        {
            var verification = await _context.VerificationCodes
                .FirstOrDefaultAsync(v => v.Email == request.Email && v.Code == request.Code && !v.IsUsed && v.ExpiresAt > DateTime.UtcNow);

            if (verification == null)
                return BadRequest(new { message = "Invalid or expired verification code" });

            var user = await _userManager.FindByEmailAsync(request.Email);
            if (user == null)
                return NotFound(new { message = "User not found" });

            user.EmailConfirmed = true;
            user.Status = "Active";
            await _userManager.UpdateAsync(user);

            verification.IsUsed = true;

            var onboarding = await _context.OnboardingStatuses.FirstOrDefaultAsync(o => o.UserID == user.Id);
            if (onboarding != null)
                onboarding.IsEmailVerified = true;

            await _context.SaveChangesAsync();

            return Ok(new { message = "Email verified successfully" });
        }

        [HttpPost("resend-code")]
        public async Task<IActionResult> ResendCode([FromBody] string email)
        {
            var code = new Random().Next(100000, 999999).ToString();
            _context.VerificationCodes.Add(new VerificationCode
            {
                Email = email,
                Code = code,
                ExpiresAt = DateTime.UtcNow.AddMinutes(10)
            });
            await _context.SaveChangesAsync();
            await _emailService.SendVerificationCodeAsync(email, code);

            return Ok(new { message = "Verification code sent" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var userAgent = Request.Headers["User-Agent"].ToString();
            var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();
            if (_ipDeviceReputationService.IsBlocked(ipAddress, userAgent, out var blockReason))
                return StatusCode(429, new { message = $"Access blocked: {blockReason}. Please try again later." });

            if (!await VerifyReCaptchaAsync(request.CaptchaToken))
                return BadRequest(new { message = "Captcha verification failed" });

            var user = await _userManager.FindByEmailAsync(request.Email);
            if (user == null)
            {
                _ipDeviceReputationService.RegisterFailure(ipAddress, userAgent);
                return Unauthorized(new { message = "Invalid credentials" });
            }

            // Check if user is locked due to failed login attempts
            var lockoutCheck = await _loginAttemptService.CheckLoginAttemptAsync(user.Id);
            if (lockoutCheck.isLocked)
                return Unauthorized(new { message = $"Account locked due to too many failed login attempts. Try again in {lockoutCheck.message}" });

            if (!await _userManager.CheckPasswordAsync(user, request.Password))
            {
                // Record failed attempt
                await _loginAttemptService.RecordFailedAttemptAsync(user.Id);
                _ipDeviceReputationService.RegisterFailure(ipAddress, userAgent);
                return Unauthorized(new { message = "Invalid credentials" });
            }

            if (!user.EmailConfirmed)
            {
                // Send new verification code for unverified users trying to login
                var code = new Random().Next(100000, 999999).ToString();
                _context.VerificationCodes.Add(new VerificationCode
                {
                    Email = request.Email,
                    Code = code,
                    ExpiresAt = DateTime.UtcNow.AddMinutes(10)
                });
                await _context.SaveChangesAsync();
                await _emailService.SendVerificationCodeAsync(request.Email, code);
                
                return Ok(new { 
                    requiresEmailVerification = true, 
                    email = request.Email,
                    message = "Please verify your email first. A new verification code has been sent." 
                });
            }

            if (user.Status == "Suspended")
                return Unauthorized(new { message = "Your account has been suspended. Please contact support." });

            var roles = await _userManager.GetRolesAsync(user);
            var role = roles.FirstOrDefault() ?? user.Role;

            if ((role == "Staff" || role == "Admin" || role == "SuperAdmin") && user.Status == "Inactive")
                return Unauthorized(new { message = "Your account is inactive. Please contact administrator." });

            var dbUser = await _context.Users.AsNoTracking().FirstOrDefaultAsync(u => u.Id == user.Id);
            
            if (dbUser?.TwoFactorEnabled == true)
            {
                var code = new Random().Next(100000, 999999).ToString();
                _context.VerificationCodes.Add(new VerificationCode
                {
                    Email = user.Email!,
                    Code = code,
                    ExpiresAt = DateTime.UtcNow.AddMinutes(10)
                });
                await _context.SaveChangesAsync();
                await _emailService.SendEmailAsync(user.Email!, "Login Verification - TayoKonnektado", $"Your login verification code is: {code}");

                return Ok(new { requiresTwoFactor = true, email = user.Email, message = "Verification code sent to your email" });
            }

            var device = GetDeviceFromUserAgent(userAgent);
            var location = "Philippines";

            _context.LoginHistory.Add(new LoginHistory
            {
                UserID = user.Id,
                Device = device,
                Location = location,
                IPAddress = ipAddress,
                LoginTime = DateTime.UtcNow
            });
            await _context.SaveChangesAsync();

            var isNewDevice = !await _context.LoginHistory
                .AnyAsync(lh => lh.UserID == user.Id && lh.Device == device && lh.LoginTime < DateTime.UtcNow.AddMinutes(-5));
            
            if (isNewDevice)
            {
                var loginPref = await _context.NotificationPreferences
                    .FirstOrDefaultAsync(np => np.UserID == user.Id && np.NotificationType == "login-new");
                if (loginPref?.EmailEnabled != false)
                {
                    await _emailService.SendEmailAsync(
                        user.Email!,
                        "New Device Login - TayoKonnektado",
                        $"Hello {user.FirstName},<br><br>A new login was detected on your account:<br><br><strong>Device:</strong> {device}<br><strong>Location:</strong> {location}<br><strong>Time:</strong> {DateTime.UtcNow:yyyy-MM-dd HH:mm:ss} UTC<br><br>If this wasn't you, please secure your account immediately."
                    );
                }
            }

            // Reset login attempts on successful login
            await _loginAttemptService.ResetAttemptsAsync(user.Id);
            _ipDeviceReputationService.RegisterSuccess(ipAddress, userAgent);

            var token = await _tokenService.GenerateTokenAsync(user.Email!, user.Id, role);

            var settings = await _context.SystemSettings.FirstOrDefaultAsync();
            var sessionTimeoutMinutes = settings?.SessionTimeout ?? 30;

            await LogActivityAsync(user.Id, "Logged in", "Login");

            return Ok(new AuthResponse
            {
                Token = token,
                Email = user.Email!,
                Role = role,
                Expiration = DateTime.UtcNow.AddMinutes(sessionTimeoutMinutes)
            });
        }

        private async Task<bool> VerifyReCaptchaAsync(string? captchaToken)
        {
            if (string.IsNullOrWhiteSpace(captchaToken))
                return false;

            var secretKey = _configuration["ReCaptcha:SecretKey"];
            var verifyUrl = _configuration["ReCaptcha:VerifyUrl"] ?? "https://www.google.com/recaptcha/api/siteverify";

            if (string.IsNullOrWhiteSpace(secretKey))
                return false;

            var httpClient = _httpClientFactory.CreateClient();
            var content = new FormUrlEncodedContent(new Dictionary<string, string>
            {
                ["secret"] = secretKey,
                ["response"] = captchaToken,
                ["remoteip"] = HttpContext.Connection.RemoteIpAddress?.ToString() ?? string.Empty
            });

            var response = await httpClient.PostAsync(verifyUrl, content);
            if (!response.IsSuccessStatusCode)
                return false;

            var responseJson = await response.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<ReCaptchaVerificationResponse>(responseJson, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            return result?.Success == true;
        }

        private sealed class ReCaptchaVerificationResponse
        {
            public bool Success { get; set; }

            [JsonPropertyName("error-codes")]
            public string[]? ErrorCodes { get; set; }
        }

        [HttpPost("verify-2fa-login")]
        public async Task<IActionResult> Verify2FALogin([FromBody] Verify2FALoginRequest request)
        {
            var userAgent = Request.Headers["User-Agent"].ToString();
            var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();
            if (_ipDeviceReputationService.IsBlocked(ipAddress, userAgent, out var blockReason))
                return StatusCode(429, new { message = $"Access blocked: {blockReason}. Please try again later." });

            var user = await _userManager.FindByEmailAsync(request.Email);
            if (user == null) return Unauthorized(new { message = "User not found" });

            var verification = await _context.VerificationCodes
                .FirstOrDefaultAsync(v => v.Email == request.Email && v.Code == request.Code && !v.IsUsed && v.ExpiresAt > DateTime.UtcNow);
            if (verification == null) return BadRequest(new { message = "Invalid or expired verification code" });

            verification.IsUsed = true;
            
            var device = GetDeviceFromUserAgent(userAgent);
            var location = "Philippines";

            _context.LoginHistory.Add(new LoginHistory
            {
                UserID = user.Id,
                Device = device,
                Location = location,
                IPAddress = ipAddress,
                LoginTime = DateTime.UtcNow
            });
            await _context.SaveChangesAsync();

            // Reset login attempts on successful 2FA verification
            await _loginAttemptService.ResetAttemptsAsync(user.Id);
            _ipDeviceReputationService.RegisterSuccess(ipAddress, userAgent);

            var roles = await _userManager.GetRolesAsync(user);
            var role = roles.FirstOrDefault() ?? user.Role;
            var token = await _tokenService.GenerateTokenAsync(user.Email!, user.Id, role);

            var settings = await _context.SystemSettings.FirstOrDefaultAsync();
            var sessionTimeoutMinutes = settings?.SessionTimeout ?? 30;

            await LogActivityAsync(user.Id, "Completed two-factor login", "Login");

            return Ok(new AuthResponse
            {
                Token = token,
                Email = user.Email!,
                Role = role,
                Expiration = DateTime.UtcNow.AddMinutes(sessionTimeoutMinutes)
            });
        }

        private string GetDeviceFromUserAgent(string userAgent)
        {
            if (string.IsNullOrEmpty(userAgent))
                return "Unknown Device";

            var rules = new (string[] MustContain, string Result)[]
            {
                (new[] { "Chrome", "Windows" }, "Chrome on Windows"),
                (new[] { "Chrome", "Mac" }, "Chrome on Mac"),
                (new[] { "Chrome", "Android" }, "Chrome on Android"),
                (new[] { "Safari", "iPhone" }, "Safari on iPhone"),
                (new[] { "Safari", "iPad" }, "Safari on iPad"),
                (new[] { "Firefox" }, "Firefox Browser"),
                (new[] { "Edge" }, "Microsoft Edge")
            };

            foreach (var rule in rules)
            {
                if (rule.MustContain.All(token => userAgent.Contains(token, StringComparison.OrdinalIgnoreCase)))
                    return rule.Result;
            }

            return "Unknown Device";
        }

        [HttpPost("google-login")]
        public async Task<IActionResult> GoogleLogin([FromBody] GoogleLoginRequest request)
        {
            var user = await _userManager.FindByEmailAsync(request.Email);
            
            if (user == null)
            {
                user = new ApplicationUser
                {
                    UserName = request.Email,
                    Email = request.Email,
                    FirstName = request.FirstName,
                    LastName = request.LastName,
                    EmailConfirmed = true,
                    Status = "Active"
                };
                
                var result = await _userManager.CreateAsync(user);
                if (!result.Succeeded)
                    return BadRequest(result.Errors);

                _context.OnboardingStatuses.Add(new OnboardingStatus
                {
                    UserID = user.Id,
                    IsEmailVerified = true
                });
                await _context.SaveChangesAsync();
            }

            // Reset login attempts on successful Google login
            await _loginAttemptService.ResetAttemptsAsync(user.Id);

            var roles = await _userManager.GetRolesAsync(user);
            var role = roles.FirstOrDefault() ?? user.Role;

            var token = await _tokenService.GenerateTokenAsync(user.Email!, user.Id, role);

            var settings = await _context.SystemSettings.FirstOrDefaultAsync();
            var sessionTimeoutMinutes = settings?.SessionTimeout ?? 30;

            await LogActivityAsync(user.Id, "Logged in with Google", "Login");

            return Ok(new AuthResponse
            {
                Token = token,
                Email = user.Email!,
                Role = role,
                Expiration = DateTime.UtcNow.AddMinutes(sessionTimeoutMinutes)
            });
        }

        private async Task LogActivityAsync(string userId, string action, string type)
        {
            if (string.IsNullOrWhiteSpace(userId) || string.IsNullOrWhiteSpace(action))
                return;

            try
            {
                _context.ActivityLogs.Add(new ActivityLog
                {
                    UserID = userId,
                    Action = action,
                    Type = string.IsNullOrWhiteSpace(type) ? "Update" : type,
                    IPAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                    Timestamp = DateTime.UtcNow
                });

                await _context.SaveChangesAsync();
            }
            catch
            {
                // Avoid blocking auth flows when activity logging fails.
            }
        }

        [Authorize]
        [RequireEmailVerification]
        [HttpPost("select-service-type")]
        public async Task<IActionResult> SelectServiceType([FromBody] SelectServiceTypeRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var activeSubCount = await _context.Subscriptions
                .CountAsync(s => s.UserID == userId && s.Status == "Active");
            var activePrepCount = await _context.Devices
                .Where(d => d.UserID == userId)
                .SelectMany(d => d.ServiceAccounts)
                .Where(sa => sa.Status == "Active" && sa.ServiceType == "Prepaid")
                .CountAsync();
            
            if (activeSubCount + activePrepCount >= 5)
                return BadRequest(new { message = "You have reached the maximum limit of 5 active services." });
            
            var onboarding = await _context.OnboardingStatuses.FirstOrDefaultAsync(o => o.UserID == userId);

            if (onboarding == null)
                return NotFound(new { message = "Onboarding status not found" });

            onboarding.HasSelectedServiceType = true;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Service type selected successfully" });
        }

        [Authorize]
        [RequireEmailVerification]
        [HttpGet("onboarding-status")]
        public async Task<IActionResult> GetOnboardingStatus()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            
            var hasActiveSubscription = await _context.Subscriptions
                .AnyAsync(s => s.UserID == userId && s.Status == "Active");
            
            var hasActivePrepaid = await _context.Devices
                .Where(d => d.UserID == userId)
                .SelectMany(d => d.ServiceAccounts)
                .Where(sa => sa.Status == "Active")
                .SelectMany(sa => sa.PrepaidLoads)
                .AnyAsync();

            var hasActivePlan = hasActiveSubscription || hasActivePrepaid;

            var onboarding = await _context.OnboardingStatuses.FirstOrDefaultAsync(o => o.UserID == userId);

            if (onboarding == null)
            {
                return Ok(new
                {
                    hasSelectedServiceType = false,
                    hasRegisteredDevice = false,
                    hasCompletedTutorial = false,
                    hasActivePlan
                });
            }

            return Ok(new
            {
                hasSelectedServiceType = onboarding.HasSelectedServiceType,
                hasRegisteredDevice = onboarding.HasRegisteredDevice,
                hasCompletedTutorial = onboarding.HasCompletedTutorial,
                hasActivePlan
            });
        }

        [Authorize]
        [RequireEmailVerification]
        [HttpPost("register-device")]
        public async Task<IActionResult> RegisterDevice([FromBody] RegisterDeviceRequest request)
        {
            try
            {
                var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
                
                var activeSubscriptionCount = await _context.Subscriptions
                    .CountAsync(s => s.UserID == userId && s.Status == "Active");
                var activePrepaidCount = await _context.Devices
                    .Where(d => d.UserID == userId)
                    .SelectMany(d => d.ServiceAccounts)
                    .Where(sa => sa.Status == "Active" && sa.ServiceType == "Prepaid")
                    .CountAsync();
                var totalActiveServices = activeSubscriptionCount + activePrepaidCount;
                
                if (totalActiveServices >= 5)
                    return BadRequest(new { message = "You have reached the maximum limit of 5 active services." });
                
                var serviceType = request.ServiceType ?? "Subscription";
                
                if (serviceType == "Prepaid" && string.IsNullOrWhiteSpace(request.PhoneNumber))
                {
                    return BadRequest(new { message = "Phone number is required for Prepaid WiFi service" });
                }
                var macAddress = request.MacAddress;
                if (serviceType == "Prepaid" && string.IsNullOrWhiteSpace(macAddress))
                {
                    macAddress = $"PP:{DateTime.UtcNow:HHmmss}:{new Random().Next(0x00, 0xFF):X2}:{new Random().Next(0x00, 0xFF):X2}:{new Random().Next(0x00, 0xFF):X2}:{new Random().Next(0x00, 0xFF):X2}";
                }

                var device = new Device
                {
                    UserID = userId!,
                    MACAddress = macAddress,
                    Status = "Active",
                    DeviceType = "WiFi"
                };
                _context.Devices.Add(device);
                await _context.SaveChangesAsync();

                var serviceAccount = new ServiceAccount
                {
                    DeviceID = device.DeviceID,
                    ServiceType = serviceType,
                    Status = "Active"
                };
                _context.ServiceAccounts.Add(serviceAccount);
                await _context.SaveChangesAsync();

                if (serviceType == "Prepaid")
                {
                    var prepaidLoad = new PrepaidLoad
                    {
                        ServiceAccountID = serviceAccount.ServiceAccountID,
                        PhoneNumber = request.PhoneNumber,
                        LoadAmount = 0,
                        RemainingBalance = 0
                    };
                    _context.PrepaidLoads.Add(prepaidLoad);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    int planId;
                    if (request.PlanID.HasValue)
                    {
                        planId = request.PlanID.Value;
                    }
                    else
                    {
                        var macSuffix = request.MacAddress.Replace(":", "").ToUpper().Substring(request.MacAddress.Replace(":", "").Length - 2);
                        int speedMbps = macSuffix switch
                        {
                            "FA" => 50,
                            "EA" => 100,
                            "GA" => 200,
                            "HA" => 500,
                            _ => 0
                        };

                        if (speedMbps == 0)
                            return BadRequest(new { message = "Invalid MAC ID. Must end with FA (50Mbps), EA (100Mbps), GA (200Mbps), or HA (500Mbps)" });

                        var plan = await _context.SubscriptionPlans
                            .AsNoTracking()
                            .Where(p => p.SpeedMbps == speedMbps)
                            .Select(p => new { p.PlanID })
                            .FirstOrDefaultAsync();
                        if (plan == null)
                            return BadRequest(new { message = $"Plan not found. Please contact administrator to set up subscription plans." });
                        planId = plan.PlanID;
                    }

                    var subscription = new Subscription
                    {
                        ServiceAccountID = serviceAccount.ServiceAccountID,
                        PlanID = planId,
                        UserID = userId!,
                        StartDate = DateTime.UtcNow,
                        Status = "Active"
                    };
                    _context.Subscriptions.Add(subscription);
                }

                var onboarding = await _context.OnboardingStatuses.FirstOrDefaultAsync(o => o.UserID == userId);
                if (onboarding != null)
                    onboarding.HasRegisteredDevice = true;

                await _context.SaveChangesAsync();

                return Ok(new { message = "Device registered successfully", deviceId = device.DeviceID, serviceType });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Failed to register device: {ex.Message}" });
            }
        }

        [Authorize]
        [RequireEmailVerification]
        [HttpPost("complete-tutorial")]
        public async Task<IActionResult> CompleteTutorial()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var activeSubCount = await _context.Subscriptions
                .CountAsync(s => s.UserID == userId && s.Status == "Active");
            var activePrepCount = await _context.Devices
                .Where(d => d.UserID == userId)
                .SelectMany(d => d.ServiceAccounts)
                .Where(sa => sa.Status == "Active" && sa.ServiceType == "Prepaid")
                .CountAsync();
            
            if (activeSubCount + activePrepCount >= 5)
                return BadRequest(new { message = "You have reached the maximum limit of 5 active services." });
            
            var onboarding = await _context.OnboardingStatuses.FirstOrDefaultAsync(o => o.UserID == userId);
            if (onboarding == null)
                return NotFound(new { message = "Onboarding status not found" });

            onboarding.HasCompletedTutorial = true;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Tutorial completed successfully" });
        }

        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword([FromBody] VerifyEmailRequest request)
        {
            var user = await _userManager.FindByEmailAsync(request.Email);
            if (user == null)
                return Ok(new { message = "If the email exists, a reset code has been sent" });

            var code = new Random().Next(100000, 999999).ToString();
            _context.VerificationCodes.Add(new VerificationCode
            {
                Email = request.Email,
                Code = code,
                ExpiresAt = DateTime.UtcNow.AddMinutes(10)
            });
            await _context.SaveChangesAsync();
            await _emailService.SendVerificationCodeAsync(request.Email, code);

            return Ok(new { message = "Reset code sent to your email" });
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest request)
        {
            var userAgent = Request.Headers["User-Agent"].ToString();
            var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();
            if (_ipDeviceReputationService.IsBlocked(ipAddress, userAgent, out var blockReason))
                return StatusCode(429, new { message = $"Access blocked: {blockReason}. Please try again later." });

            var verification = await _context.VerificationCodes
                .FirstOrDefaultAsync(v => v.Email == request.Email && v.Code == request.Code && !v.IsUsed && v.ExpiresAt > DateTime.UtcNow);

            if (verification == null)
            {
                _ipDeviceReputationService.RegisterFailure(ipAddress, userAgent);
                return BadRequest(new { message = "Invalid or expired reset code" });
            }

            var user = await _userManager.FindByEmailAsync(request.Email);
            if (user == null)
            {
                _ipDeviceReputationService.RegisterFailure(ipAddress, userAgent);
                return NotFound(new { message = "User not found" });
            }

            if (await _passwordBreachService.IsBreachedAsync(request.NewPassword))
                return BadRequest(new { message = "New password has been found in a breach. Please choose a different password." });

            var token = await _userManager.GeneratePasswordResetTokenAsync(user);
            var result = await _userManager.ResetPasswordAsync(user, token, request.NewPassword);

            if (!result.Succeeded)
            {
                _ipDeviceReputationService.RegisterFailure(ipAddress, userAgent);
                return BadRequest(new { message = string.Join(", ", result.Errors.Select(e => e.Description)) });
            }

            verification.IsUsed = true;
            await _context.SaveChangesAsync();

            _ipDeviceReputationService.RegisterSuccess(ipAddress, userAgent);

            return Ok(new { message = "Password reset successfully" });
        }
    }

    public class RegisterDeviceRequest
    {
        public string? MacAddress { get; set; }
        public string ServiceType { get; set; } = string.Empty;
        public int? PlanID { get; set; }
        public string? PhoneNumber { get; set; }
    }

    public class Verify2FALoginRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
    }
}
