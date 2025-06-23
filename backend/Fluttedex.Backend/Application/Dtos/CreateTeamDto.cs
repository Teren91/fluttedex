using System.ComponentModel.DataAnnotations;

namespace Fluttedex.Backend.Application.Dtos
{
    public class CreateTeamDto
    {
        [Required]
        [StringLength(100, ErrorMessage = "Team name cannot exceed 100 characters.")]
        public string Name { get; set; } = string.Empty;

        [Required]
        [MinLength(1, ErrorMessage = "At least one Pokémon ID is required.")]
        [MaxLength(6, ErrorMessage = "A maximum of 6 Pokémon IDs can be provided.")]
        public List<int> PokemonIds { get; set; } = new();
    }
}