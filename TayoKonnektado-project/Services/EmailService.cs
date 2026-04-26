using System.Net;
using System.Net.Mail;

namespace TayoKonnektado_project.Services
{
    public class EmailService
    {
        private readonly IConfiguration _configuration;

        public EmailService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task SendVerificationCodeAsync(string email, string code)
        {
            try
            {
                var smtpClient = new SmtpClient("smtp.gmail.com")
                {
                    Port = 587,
                    Credentials = new NetworkCredential(
                        _configuration["Email:Username"],
                        _configuration["Email:Password"]
                    ),
                    EnableSsl = true
                };

                var mailMessage = new MailMessage
                {
                    From = new MailAddress(_configuration["Email:Username"]!),
                    Subject = "TayoKonnektado - Email Verification Code",
                    Body = $@"
                        <h2>Welcome to TayoKonnektado!</h2>
                        <p>Your verification code is: <strong>{code}</strong></p>
                        <p>This code will expire in 10 minutes.</p>
                    ",
                    IsBodyHtml = true
                };
                mailMessage.To.Add(email);

                await smtpClient.SendMailAsync(mailMessage);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Email send failed: {ex.Message}");
                throw;
            }
        }

        public async Task SendEmailAsync(string email, string subject, string body)
        {
            try
            {
                Console.WriteLine($"Connecting to SMTP server for {email}...");
                var smtpClient = new SmtpClient("smtp.gmail.com")
                {
                    Port = 587,
                    Credentials = new NetworkCredential(
                        _configuration["Email:Username"],
                        _configuration["Email:Password"]
                    ),
                    EnableSsl = true
                };

                var mailMessage = new MailMessage
                {
                    From = new MailAddress(_configuration["Email:Username"]!),
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = true
                };
                mailMessage.To.Add(email);

                Console.WriteLine($"Sending email to {email}...");
                await smtpClient.SendMailAsync(mailMessage);
                Console.WriteLine($"Email sent successfully to {email}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Email send failed: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                throw;
            }
        }
    }
}
