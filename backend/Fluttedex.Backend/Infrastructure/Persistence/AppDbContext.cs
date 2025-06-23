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



            // --- Relación User <-> Team ---
            // Un equipo (Team) tiene un (HasOne) usuario (User).
            // Un usuario (User) tiene muchos (WithMany) equipos (Teams).
            // La clave foránea (ForeignKey) que los une es 'UserId' en la tabla de equipos.
            modelBuilder.Entity<Team>()
                .HasOne(t => t.User)
                .WithMany(u => u.Teams)
                .HasForeignKey(t => t.UserId);

            // --- Relación Team <-> TeamPokemon ---
            // Un TeamPokemon tiene un (HasOne) equipo (Team).
            // Un equipo (Team) tiene muchos (WithMany) TeamPokemons.
            // La clave foránea (ForeignKey) es 'TeamId' en la tabla TeamPokemons.
            modelBuilder.Entity<Team>()
                .HasMany(t => t.TeamPokemons)
                .WithOne(tp => tp.Team)
                .HasForeignKey(tp => tp.Id);

            // --- Clave Primaria Compuesta para TeamPokemon ---
            // La tabla TeamPokemons tiene una clave primaria formada por dos columnas.
            modelBuilder.Entity<TeamPokemon>()
                .HasKey(tp => new { tp.Id, tp.PokemonId });
        }
    }
}
