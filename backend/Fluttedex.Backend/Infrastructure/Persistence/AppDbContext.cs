using Fluttedex.Backend.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Fluttedex.Backend.Infrastructure.Persistence
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Team> Teams { get; set; }
        public DbSet<TeamPokemon> TeamPokemons { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<TeamPokemon>()
                .HasKey(tp => new { tp.TeamId, tp.PokemonId });

            modelBuilder.Entity<User>()
                .HasMany(u => u.Teams)
                .WithOne(t => t.User)
                .HasForeignKey(u => u.UserId);

            modelBuilder.Entity<Team>()
                .HasMany(e => e.TeamPokemons)
                .WithOne(t => t.Team)
                .HasForeignKey(t => t.TeamId);
        }
    }
}
