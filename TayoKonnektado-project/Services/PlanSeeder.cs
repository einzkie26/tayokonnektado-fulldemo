using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services
{
    public class PlanSeeder
    {
        public static async Task SeedPlansAsync(ApplicationDbContext context)
        {
            if (!context.SubscriptionPlans.Any())
            {
                context.SubscriptionPlans.AddRange(
                    new SubscriptionPlan { PlanName = "Basic 50Mbps", SpeedMbps = 50.00m, Price = 999.00m },
                    new SubscriptionPlan { PlanName = "Standard 100Mbps", SpeedMbps = 100.00m, Price = 1499.00m },
                    new SubscriptionPlan { PlanName = "Premium 200Mbps", SpeedMbps = 200.00m, Price = 1999.00m },
                    new SubscriptionPlan { PlanName = "Ultra 500Mbps", SpeedMbps = 500.00m, Price = 2999.00m }
                );
                await context.SaveChangesAsync();
            }
        }
    }
}
