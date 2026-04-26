using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;

namespace TayoKonnektado_project.Services.Admin
{
    public class PlanManagementService
    {
        private readonly ApplicationDbContext _context;

        public PlanManagementService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<object> GetAllPlansAsync()
        {
            return await _context.SubscriptionPlans
                .Select(p => new
                {
                    p.PlanID,
                    p.PlanName,
                    p.SpeedMbps,
                    Price = p.Price,
                    Subscribers = _context.Subscriptions.Count(s => s.PlanID == p.PlanID && s.Status == "Active")
                })
                .ToListAsync();
        }

        public async Task<bool> UpdatePlanAsync(int id, string planName, decimal speedMbps, decimal price)
        {
            var plan = await _context.SubscriptionPlans.FindAsync(id);
            if (plan == null) return false;

            plan.PlanName = planName;
            plan.SpeedMbps = speedMbps;
            plan.Price = price;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeletePlanAsync(int id)
        {
            var plan = await _context.SubscriptionPlans.FindAsync(id);
            if (plan == null) return false;

            _context.SubscriptionPlans.Remove(plan);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
