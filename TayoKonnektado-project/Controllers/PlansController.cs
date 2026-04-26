using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;

namespace TayoKonnektado_project.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PlansController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public PlansController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet("check")]
        public async Task<IActionResult> CheckPlans()
        {
            var hasPlans = await _context.SubscriptionPlans.AnyAsync();
            return Ok(new { hasPlans });
        }

        [HttpGet]
        public async Task<IActionResult> GetPlans()
        {
            var plans = await _context.SubscriptionPlans.ToListAsync();
            return Ok(plans);
        }

        [HttpGet("promo-offers")]
        public async Task<IActionResult> GetPromoOffers()
        {
            var offers = await _context.PromoOffers
                .Where(o => o.IsActive)
                .OrderByDescending(o => o.CreatedAt)
                .Select(o => new
                {
                    o.PromoOfferID,
                    o.Title,
                    o.Description,
                    o.Price,
                    o.Data,
                    o.Validity,
                    o.Badge,
                    o.Color
                })
                .ToListAsync();
            return Ok(offers);
        }
    }
}
