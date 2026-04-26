using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Attributes
{
    public class RequireEmailVerificationAttribute : Attribute, IAsyncAuthorizationFilter
    {
        public async Task OnAuthorizationAsync(AuthorizationFilterContext context)
        {
            // Skip if endpoint has AllowAnonymous
            if (context.ActionDescriptor.EndpointMetadata.Any(em => em.GetType() == typeof(AllowAnonymousAttribute)))
                return;

            var userManager = context.HttpContext.RequestServices.GetRequiredService<UserManager<ApplicationUser>>();
            
            if (context.HttpContext.User.Identity?.IsAuthenticated == true)
            {
                var userId = context.HttpContext.User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
                if (!string.IsNullOrEmpty(userId))
                {
                    var user = await userManager.FindByIdAsync(userId);
                    if (user != null && !user.EmailConfirmed)
                    {
                        context.Result = new JsonResult(new { message = "Email verification required", requiresEmailVerification = true })
                        {
                            StatusCode = 403
                        };
                        return;
                    }
                }
            }
        }
    }
}