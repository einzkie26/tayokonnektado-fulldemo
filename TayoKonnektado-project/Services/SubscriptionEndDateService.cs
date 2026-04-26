using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;

namespace TayoKonnektado_project.Services
{
    public class SubscriptionEndDateService : BackgroundService
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly ILogger<SubscriptionEndDateService> _logger;

        public SubscriptionEndDateService(IServiceProvider serviceProvider, ILogger<SubscriptionEndDateService> logger)
        {
            _serviceProvider = serviceProvider;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using (var scope = _serviceProvider.CreateScope())
                    {
                        var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
                        
                        var today = DateTime.UtcNow.Date;
                        var subscriptionsToDeactivate = await context.Subscriptions
                            .Where(s => s.Status == "Active" && s.EndDate.HasValue && s.EndDate.Value.Date <= today)
                            .ToListAsync(stoppingToken);

                        if (subscriptionsToDeactivate.Any())
                        {
                            foreach (var sub in subscriptionsToDeactivate)
                            {
                                sub.Status = "Inactive";
                            }
                            await context.SaveChangesAsync(stoppingToken);
                            _logger.LogInformation($"Deactivated {subscriptionsToDeactivate.Count} subscriptions with expired end dates.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Error in SubscriptionEndDateService: {ex.Message}");
                }

                await Task.Delay(TimeSpan.FromHours(1), stoppingToken);
            }
        }
    }
}
