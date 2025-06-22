namespace Fluttedex.Backend.Domain.Entities
{
    public class TeamPokemon
    {
        public Guid Id { get; set; }
        public int PokemonId { get; set; }
        public int Position { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public Team Team { get; set; } = null!;
    }
}
