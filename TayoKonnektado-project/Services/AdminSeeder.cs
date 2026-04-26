using Microsoft.AspNetCore.Identity;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services
{
    public class AdminSeeder
    {
        public static async Task SeedAdminAsync(UserManager<ApplicationUser> userManager, RoleManager<IdentityRole> roleManager)
        {
            if (!await roleManager.RoleExistsAsync("SuperAdmin"))
            {
                await roleManager.CreateAsync(new IdentityRole("SuperAdmin"));
            }
            if (!await roleManager.RoleExistsAsync("Admin"))
            {
                await roleManager.CreateAsync(new IdentityRole("Admin"));
            }
            if (!await roleManager.RoleExistsAsync("Staff"))
            {
                await roleManager.CreateAsync(new IdentityRole("Staff"));
            }
            if (!await roleManager.RoleExistsAsync("User"))
            {
                await roleManager.CreateAsync(new IdentityRole("User"));
            }

            var superAdminEmail = "admin@tayokonnektado.com";
            var superAdminPassword = "Admin@123";
            var superAdminUser = await userManager.FindByEmailAsync(superAdminEmail);

            if (superAdminUser == null)
            {
                superAdminUser = new ApplicationUser
                {
                    UserName = superAdminEmail,
                    Email = superAdminEmail,
                    FirstName = "Super",
                    LastName = "Admin",
                    EmailConfirmed = true,
                    Status = "Active",
                    Role = "SuperAdmin"
                };

                var result = await userManager.CreateAsync(superAdminUser, superAdminPassword);
                if (result.Succeeded)
                {
                    await userManager.AddToRoleAsync(superAdminUser, "SuperAdmin");
                }
            }
            else
            {
                var token = await userManager.GeneratePasswordResetTokenAsync(superAdminUser);
                await userManager.ResetPasswordAsync(superAdminUser, token, superAdminPassword);
                superAdminUser.Role = "SuperAdmin";
                await userManager.UpdateAsync(superAdminUser);
                
                if (!await userManager.IsInRoleAsync(superAdminUser, "SuperAdmin"))
                {
                    await userManager.AddToRoleAsync(superAdminUser, "SuperAdmin");
                }
            }
        }
    }
}
