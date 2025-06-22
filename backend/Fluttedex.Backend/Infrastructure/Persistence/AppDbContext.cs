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
        public DbSet<TeamPokemon> TeamPokemon { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configurar la clave primaria compuesta para TeamPokemon
            modelBuilder.Entity<TeamPokemon>()
                .HasKey(tp => new { tp.Id, tp.PokemonId });

            // Configurar la relación uno a muchos entre User y Team
            modelBuilder.Entity<User>()
                .HasMany(u => u.Teams)
                .WithOne(t => t.User)
                .HasForeignKey(t => t.UserId);

            // Configurar la relación uno a muchos entre Team y TeamPokemon
            modelBuilder.Entity<Team>()
                .HasOne(t => t.User) // Un equipo tiene un usuario
                .WithMany(u => u.Teams) // Un usuario tiene muchos equipos
                .HasForeignKey(t => t.UserId); // La clave foránea es UserId
        }
    }
}
