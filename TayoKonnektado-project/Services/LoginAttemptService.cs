using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services
{
    public class LoginAttemptService
    {
        private readonly ApplicationDbContext _context;

        public LoginAttemptService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<(bool isLocked, string? message, int? remainingMinutes)> CheckLoginAttemptAsync(string userId)
        {
            var attempt = await _context.LoginAttempts.FirstOrDefaultAsync(la => la.UserID == userId);
            
            if (attempt == null)
                return (false, null, null);

            if (attempt.LockedUntil.HasValue && attempt.LockedUntil > DateTime.UtcNow)
            {
                var remainingMinutes = (int)Math.Ceiling((attempt.LockedUntil.Value - DateTime.UtcNow).TotalMinutes);
                return (true, $"Account locked. Try again in {remainingMinutes} minutes.", remainingMinutes);
            }

            if (attempt.LockedUntil.HasValue && attempt.LockedUntil <= DateTime.UtcNow)
            {
                attempt.FailedAttempts = 0;
                attempt.LockedUntil = null;
                attempt.LockReason = null;
                await _context.SaveChangesAsync();
            }

            return (false, null, null);
        }

        public async Task RecordFailedAttemptAsync(string userId)
        {
            var attempt = await _context.LoginAttempts.FirstOrDefaultAsync(la => la.UserID == userId);

            if (attempt == null)
            {
                attempt = new LoginAttempt { UserID = userId, FailedAttempts = 1, LastAttemptAt = DateTime.UtcNow };
                _context.LoginAttempts.Add(attempt);
            }
            else
            {
                attempt.FailedAttempts++;
                attempt.LastAttemptAt = DateTime.UtcNow;
            }

            // Apply lockout based on failed attempts
            if (attempt.FailedAttempts == 3)
            {
                attempt.LockedUntil = DateTime.UtcNow.AddMinutes(30);
                attempt.LockReason = "30_mins";
            }
            else if (attempt.FailedAttempts >= 4 && attempt.FailedAttempts <= 7)
            {
                attempt.LockedUntil = DateTime.UtcNow.AddHours(2);
                attempt.LockReason = "2_hours";
            }
            else if (attempt.FailedAttempts >= 8)
            {
                attempt.LockedUntil = DateTime.UtcNow.AddDays(30);
                attempt.LockReason = "30_days";
            }

            await _context.SaveChangesAsync();
        }

        public async Task ResetAttemptsAsync(string userId)
        {
            var attempt = await _context.LoginAttempts.FirstOrDefaultAsync(la => la.UserID == userId);
            if (attempt != null)
            {
                attempt.FailedAttempts = 0;
                attempt.LockedUntil = null;
                attempt.LockReason = null;
                await _context.SaveChangesAsync();
            }
        }

        public async Task<List<LoginAttempt>> GetSuspendedUsersAsync()
        {
            return await _context.LoginAttempts
                .Where(la => la.LockedUntil.HasValue && la.LockedUntil > DateTime.UtcNow)
                .Include(la => la.User)
                .OrderByDescending(la => la.LockedUntil)
                .ToListAsync();
        }
    }
}
