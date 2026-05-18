using Microsoft.AspNetCore.Identity;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services
{
    public static class AdminSeeder
    {
        private const string RoleSuperAdmin = "SuperAdmin";
        private const string RoleAdmin = "Admin";
        private const string RoleStaff = "Staff";
        private const string RoleUser = "User";

        public static async Task SeedAdminAsync(UserManager<ApplicationUser> userManager, RoleManager<IdentityRole> roleManager)
        {
            if (!await roleManager.RoleExistsAsync(RoleSuperAdmin))
            {
                await roleManager.CreateAsync(new IdentityRole(RoleSuperAdmin));
            }
            if (!await roleManager.RoleExistsAsync(RoleAdmin))
            {
                await roleManager.CreateAsync(new IdentityRole(RoleAdmin));
            }
            if (!await roleManager.RoleExistsAsync(RoleStaff))
            {
                await roleManager.CreateAsync(new IdentityRole(RoleStaff));
            }
            if (!await roleManager.RoleExistsAsync(RoleUser))
            {
                await roleManager.CreateAsync(new IdentityRole(RoleUser));
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
                    Role = RoleSuperAdmin
                };

                var result = await userManager.CreateAsync(superAdminUser, superAdminPassword);
                if (result.Succeeded)
                    await userManager.AddToRoleAsync(superAdminUser, RoleSuperAdmin);
            }
            else
            {
                var token = await userManager.GeneratePasswordResetTokenAsync(superAdminUser);
                await userManager.ResetPasswordAsync(superAdminUser, token, superAdminPassword);
                superAdminUser.Role = RoleSuperAdmin;
                await userManager.UpdateAsync(superAdminUser);
                
                if (!await userManager.IsInRoleAsync(superAdminUser, RoleSuperAdmin))
                {
                    await userManager.AddToRoleAsync(superAdminUser, RoleSuperAdmin);
                }
            }
        }
    }
}
