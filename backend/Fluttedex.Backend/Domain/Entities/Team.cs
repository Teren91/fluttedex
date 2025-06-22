namespace Fluttedex.Backend.Domain.Entities
{
    public class Team
    {
        public Guid Id { get; set; }
        public int UserId { get; set; }
        public string TeamName { get; set; } = string.Empty;
        public bool IsFavorite { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public User User { get; set; } = null!;
        public ICollection<TeamPokemon> TeamPokemon { get; set; } = new List<TeamPokemon>();
    }
}