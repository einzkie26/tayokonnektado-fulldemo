using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Data
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        public DbSet<Device> Devices { get; set; }
        public DbSet<SupportTicket> SupportTickets { get; set; }
        public DbSet<TicketReply> TicketReplies { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<ServiceAccount> ServiceAccounts { get; set; }
        public DbSet<SubscriptionPlan> SubscriptionPlans { get; set; }
        public DbSet<Subscription> Subscriptions { get; set; }
        public DbSet<PrepaidLoad> PrepaidLoads { get; set; }
        public DbSet<PrepaidPromo> PrepaidPromos { get; set; }
        public DbSet<Invoice> Invoices { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<VerificationCode> VerificationCodes { get; set; }
        public DbSet<OnboardingStatus> OnboardingStatuses { get; set; }
        public DbSet<SavedPaymentMethod> SavedPaymentMethods { get; set; }
        public DbSet<Addon> Addons { get; set; }
        public DbSet<UserAddon> UserAddons { get; set; }
        public DbSet<ActivityLog> ActivityLogs { get; set; }
        public DbSet<FAQ> FAQs { get; set; }
        public DbSet<LoginHistory> LoginHistory { get; set; }
        public DbSet<NotificationPreference> NotificationPreferences { get; set; }
        public DbSet<PromoOffer> PromoOffers { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Device>()
                .Property(d => d.UserID)
                .HasColumnName("UserID");

            modelBuilder.Entity<Subscription>()
                .Property(s => s.UserID)
                .HasColumnName("UserID");

            modelBuilder.Entity<Subscription>()
                .HasOne(s => s.ServiceAccount)
                .WithMany(sa => sa.Subscriptions)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Subscription>()
                .HasOne(s => s.Plan)
                .WithMany(p => p.Subscriptions)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Invoice>()
                .HasOne(i => i.Subscription)
                .WithMany(s => s.Invoices)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Invoice>()
                .HasOne(i => i.PrepaidLoad)
                .WithMany()
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Payment>()
                .HasOne(p => p.Invoice)
                .WithMany(i => i.Payments)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<TicketReply>()
                .HasOne(r => r.Ticket)
                .WithMany(t => t.Replies)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<PrepaidPromo>()
                .HasOne(pp => pp.PrepaidLoad)
                .WithMany()
                .HasForeignKey(pp => pp.PrepaidLoadID)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<PrepaidPromo>()
                .HasOne(pp => pp.User)
                .WithMany()
                .HasForeignKey(pp => pp.UserID)
                .OnDelete(DeleteBehavior.NoAction);
        }
    }
}
