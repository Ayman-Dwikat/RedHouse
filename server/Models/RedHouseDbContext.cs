using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using server.Models;
using System.ComponentModel;
using System.Reflection.Emit;

namespace RedHouse_Server.Models
{
    public class RedHouseDbContext : IdentityDbContext
    {
        public const DateTimeKind DefaultDateTimeKind = DateTimeKind.Utc;
        public RedHouseDbContext(DbContextOptions<RedHouseDbContext> options) : base(options)
        {

        }

        [DbFunction("dbo.CalculateDistance", "")]
        public static double CalculateDistance(
        double lat1, double lon1, double lat2, double lon2)
        {
            throw new NotImplementedException();
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            //         builder.Entity<Contract>()
            // .HasMany(c => c.Customer)
            // .WithMany()
            // .WillCascadeOnDelete(false);
            // builder.Entity<Application>()
            // .HasOne(a => a.User)
            // .WithMany(u => u.Applications)
            // .HasForeignKey(a => a.UserId)
            // .OnDelete(DeleteBehavior.NoAction);

            // builder.Entity<Contract>()
            // .HasOne(a => a.Customer)
            // .WithMany(u => u.Contracts)
            // .HasForeignKey(a => a.CustomerId)
            // .OnDelete(DeleteBehavior.NoAction);

            builder.Entity<Offer>()
    .HasOne(e => e.Customer)
    .WithMany()
    .HasForeignKey(e => e.CustomerId)
    .OnDelete(DeleteBehavior.NoAction); // Change to NoAction




            base.OnModelCreating(builder);
        }



        public DbSet<User> Users { get; set; }
        public DbSet<Property> Properties { get; set; }
        public DbSet<Location> Locations { get; set; }
        public DbSet<Neighborhood> Neighborhoods { get; set; }
        public DbSet<PropertyFile> PropertyFiles { get; set; }
        public DbSet<Application> Applications { get; set; }
        public DbSet<Contract> Contracts { get; set; }
        public DbSet<Milestone> Milestones { get; set; }
        public DbSet<Offer> Offers { get; set; }
        public DbSet<ContractActivity> ContractActivities { get; set; }
        public DbSet<UserHistory> UserHistoryRecords { get; set; }
        public DbSet<SavedProperties> SavedProperties { get; set; }
        public DbSet<Visitors> Visitors { get; set; }
        public DbSet<Booking> Bookings { get; set; }
        public DbSet<BookingDay> BookingDays { get; set; }
        public DbSet<UserIdentity> UserIdentities { get; set; }
        public DbSet<Complaint> Complaints { get; set; }
        public DbSet<IdentityFile> IdentityFiles { get; set; }
    }
}