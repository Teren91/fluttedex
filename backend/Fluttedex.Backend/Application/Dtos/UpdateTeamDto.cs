using System.ComponentModel.DataAnnotations;

namespace Fluttedex.Backend.Application.Dtos
{
    public class UpdateTeamDto
    {
        [Required]
        [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
        public string Name { get; set; } = string.Empty;

        public bool IsFavorite { get; set; }

        [Required]
        [MinLength(1, ErrorMessage = "At least one Pokémon is required.")]
        [MaxLength(6, ErrorMessage = "A maximum of 6 Pokémon can be specified.")]
        public List<int> PokemonIds { get; set; } = new List<int>();
    }
}
