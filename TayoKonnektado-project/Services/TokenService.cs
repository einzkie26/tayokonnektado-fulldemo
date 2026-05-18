using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using TayoKonnektado_project.Data;
using Microsoft.EntityFrameworkCore;

namespace TayoKonnektado_project.Services
{
    public class TokenService
    {
        private readonly IConfiguration _configuration;
        private readonly ApplicationDbContext _context;

        public TokenService(IConfiguration configuration, ApplicationDbContext context)
        {
            _configuration = configuration;
            _context = context;
        }

        public async Task<string> GenerateTokenAsync(string email, string userId, string? role = null)
        {
            var jwtKey = Environment.GetEnvironmentVariable("JWT_KEY");
            if (string.IsNullOrWhiteSpace(jwtKey))
                throw new InvalidOperationException("JWT secret key is not configured. Set JWT_KEY environment variable.");

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claimsList = new List<Claim>
            {
                new Claim(ClaimTypes.Email, email),
                new Claim(ClaimTypes.NameIdentifier, userId),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            if (!string.IsNullOrEmpty(role))
            {
                claimsList.Add(new Claim(ClaimTypes.Role, role));
            }

            var claims = claimsList.ToArray();

            var settings = await _context.SystemSettings.FirstOrDefaultAsync();
            var sessionTimeoutMinutes = settings?.SessionTimeout ?? 30;

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(sessionTimeoutMinutes),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public string GenerateToken(string email, string userId, string? role = null)
        {
            return GenerateTokenAsync(email, userId, role).Result;
        }
    }
}
