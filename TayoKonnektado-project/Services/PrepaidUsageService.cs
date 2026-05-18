using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services
{
    /// <summary>
    /// Background service that simulates prepaid WiFi data usage by periodically
    /// deducting MB from active promos. Does NOT touch prepaid balance.
    /// Rate: 10 MB per minute (configurable). Runs every 60 seconds.
    /// When a promo's data runs out it's marked "Depleted".
    /// When ALL promos are gone the service account is set to "Inactive".
    /// </summary>
    public class PrepaidUsageService : BackgroundService
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly ILogger<PrepaidUsageService> _logger;
        private readonly Random _random = new();

        // How often the cycle runs
        private static readonly TimeSpan Interval = TimeSpan.FromMinutes(1);

        // Deduction range per cycle in MB (random decimal each cycle)
        private const double MinMBPerCycle = 5.0;
        private const double MaxMBPerCycle = 15.0;

        public PrepaidUsageService(IServiceProvider serviceProvider, ILogger<PrepaidUsageService> logger)
        {
            _serviceProvider = serviceProvider;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            // Small initial delay to let the app fully start
            await Task.Delay(TimeSpan.FromSeconds(10), stoppingToken);

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using var scope = _serviceProvider.CreateScope();
                    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

                    await ExpirePromosAsync(context, stoppingToken);
                    await ApplyUsageAsync(context, stoppingToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Error in PrepaidUsageService: {ex.Message}");
                }

                await Task.Delay(Interval, stoppingToken);
            }
        }

        private async Task ExpirePromosAsync(ApplicationDbContext context, CancellationToken stoppingToken)
        {
            var expiredPromos = await context.PrepaidPromos
                .Where(p => p.Status == "Active" && p.ExpiresAt <= DateTime.UtcNow)
                .ToListAsync(stoppingToken);

            foreach (var ep in expiredPromos)
            {
                ep.Status = "Expired";
                _logger.LogInformation($"Promo '{ep.PromoTitle}' (#{ep.PrepaidPromoID}) expired.");
            }

            if (expiredPromos.Count > 0)
                await context.SaveChangesAsync(stoppingToken);
        }

        private async Task ApplyUsageAsync(ApplicationDbContext context, CancellationToken stoppingToken)
        {
            var activePromos = await context.PrepaidPromos
                .Include(p => p.PrepaidLoad)
                    .ThenInclude(pl => pl.ServiceAccount)
                .Where(p => p.Status == "Active"
                         && p.RemainingDataMB > 0
                         && p.PrepaidLoad.ServiceAccount.Status == "Active"
                         && p.PrepaidLoad.ServiceAccount.ServiceType == "Prepaid")
                .ToListAsync(stoppingToken);

            if (activePromos.Count == 0)
                return;

            foreach (var group in activePromos.GroupBy(p => p.PrepaidLoadID))
            {
                DeductFromGroup(group);
            }

            await context.SaveChangesAsync(stoppingToken);
            _logger.LogInformation($"Deducted random MB from {activePromos.Count} active promo(s).");
        }

        private void DeductFromGroup(IEnumerable<PrepaidPromo> group)
        {
            var deductionMB = (decimal)(MinMBPerCycle + (_random.NextDouble() * (MaxMBPerCycle - MinMBPerCycle)));
            var remaining = deductionMB;

            foreach (var promo in group.OrderBy(p => p.ActivatedAt))
            {
                if (remaining <= 0) break;

                var deduction = Math.Min(remaining, promo.RemainingDataMB);
                promo.RemainingDataMB -= deduction;
                remaining -= deduction;

                if (promo.RemainingDataMB <= 0)
                {
                    promo.RemainingDataMB = 0;
                    promo.Status = "Depleted";
                    _logger.LogInformation($"Promo '{promo.PromoTitle}' (#{promo.PrepaidPromoID}) data depleted.");
                }
            }
        }
    }
}
