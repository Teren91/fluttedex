namespace Fluttedex.Backend.Application.Dtos
{
    public class TeamDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public bool IsFavorite { get; set; }
        public List<int> PokemonIds { get; set; } = new();
    }
}
