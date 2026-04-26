using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services.Admin
{
    public class StaffManagementService
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public StaffManagementService(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        public async Task<object> GetAllStaffAsync()
        {
            return await _userManager.Users
                .Where(u => u.Role == "Admin" || u.Role == "Staff")
                .Select(u => new
                {
                    u.Id,
                    Name = u.FirstName + " " + u.LastName,
                    u.Email,
                    u.Role,
                    u.Status,
                    u.CreatedAt
                })
                .ToListAsync();
        }

        public async Task<(bool success, string message)> CreateStaffAsync(string email, string firstName, string lastName, string password, string role)
        {
            var user = new ApplicationUser
            {
                UserName = email,
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                EmailConfirmed = true,
                Status = "Active",
                Role = role
            };
            var result = await _userManager.CreateAsync(user, password);
            if (!result.Succeeded) return (false, string.Join(", ", result.Errors.Select(e => e.Description)));
            
            var roleResult = await _userManager.AddToRoleAsync(user, role);
            if (!roleResult.Succeeded)
            {
                await _userManager.DeleteAsync(user);
                return (false, $"Role '{role}' does not exist");
            }
            
            return (true, "Staff created successfully");
        }

        public async Task<bool> UpdateStaffAsync(string id, string firstName, string lastName, string status, string role, string? password = null)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null) return false;

            user.FirstName = firstName;
            user.LastName = lastName;
            user.Status = status;
            
            // Update password if provided
            if (!string.IsNullOrWhiteSpace(password))
            {
                var token = await _userManager.GeneratePasswordResetTokenAsync(user);
                await _userManager.ResetPasswordAsync(user, token, password);
            }
            
            // Update role if changed
            if (user.Role != role)
            {
                var currentRoles = await _userManager.GetRolesAsync(user);
                if (currentRoles.Any())
                {
                    await _userManager.RemoveFromRolesAsync(user, currentRoles);
                }
                user.Role = role;
                await _userManager.AddToRoleAsync(user, role);
            }
            
            await _userManager.UpdateAsync(user);
            return true;
        }

        public async Task<bool> DeleteStaffAsync(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null) return false;

            await _userManager.DeleteAsync(user);
            return true;
        }
    }
}
