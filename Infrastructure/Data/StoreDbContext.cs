using BusinessLogic.Entities;
using DataAccess.Entities.Configurations;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Internal;
using System.Xml.Linq;

namespace DataAccess.Data
{
    internal class StoreDbContext : DbContext
    {
        public StoreDbContext() { }
        public StoreDbContext(DbContextOptions options) : base(options) { }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            string dbHost = Environment.GetEnvironmentVariable("DB_HOST");
            string dbPass = Environment.GetEnvironmentVariable("DB_PASS");
            string dbUser = Environment.GetEnvironmentVariable("DB_USER");
            base.OnConfiguring(optionsBuilder);
            optionsBuilder.UseSqlServer($"Data Source={dbHost};Initial Catalog=app;Persist Security Info=True;User ID={dbUser};Password={dbPass}");
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.ApplyConfiguration(new PhoneConfiguration());

            modelBuilder.SeedColors();
            modelBuilder.SeedPhones();
        }

        public virtual DbSet<Phone> Phones { get; set; }
        public virtual DbSet<Color> Colors { get; set; }
    }
}
