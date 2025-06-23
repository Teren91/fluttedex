using Fluttedex.Backend.Application.Dtos;
using Fluttedex.Backend.Domain.Entities;
using Fluttedex.Backend.Domain.Interfaces;
using Fluttedex.Backend.Infrastructure.Persistence;
using Microsoft.AspNetCore.Mvc;

using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore; // Added for Include/FirstOrDefaultAsync

namespace Fluttedex.Backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TeamsController : ControllerBase
    {
        private readonly ITeamRepository _teamRepository;
        private readonly AppDbContext _context; // Added AppDbContext

        // Updated constructor to inject AppDbContext
        public TeamsController(ITeamRepository teamRepository, AppDbContext context)
        {
            _teamRepository = teamRepository;
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> CreateTeam(
            [FromBody] CreateTeamDto createTeamDto)
        {
            if (createTeamDto == null)
            {
                return BadRequest("Team data is required.");
            }

            const int currentUserId = 1; // Replace with actual user ID retrieval logic

            

            var team = new Team
            {
                UserId = currentUserId,
                TeamName = createTeamDto.Name,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                TeamPokemons = createTeamDto.PokemonIds.Select((id, index) => new TeamPokemon
                {
                    PokemonId = id,
                    Position = index + 1, // Assuming position starts from 1
                }).ToList(),
                
            };
         //  team.User = await _context.Users.FindAsync(currentUserId);
            await _teamRepository.AddAsync(team);

            var teamDto = new TeamDto
            {
                Id = team.Id,
                Name = team.TeamName,
                IsFavorite = team.IsFavorite,
                PokemonIds = team.TeamPokemons.Select(tp => tp.PokemonId).ToList()
            };


            return CreatedAtAction(nameof(GetTeamById), new { id = team.Id }, team);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<TeamDto>> GetTeamById(Guid id)
        {
            var team = await _teamRepository.GetByIdAsync(id);
            if (team == null)
            {
                return NotFound();
            }

            var teamDto = new TeamDto
            {
                Id = team.Id,
                Name = team.TeamName,
                IsFavorite = team.IsFavorite,
                PokemonIds = team.TeamPokemons.Select(tp => tp.PokemonId).ToList()
            };
            return Ok(teamDto);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<TeamDto>>> GetUserTeams (int userId)
        {
            //Por el momento usamos un userId fijo, en un futuro se debe obtener del contexto de autenticación
            const int currentUserId = 1; // Replace with actual user ID retrieval logic
            var teams = await _teamRepository.GetByUserIdAsync(currentUserId);
            
            if (teams == null)
            {
                return NotFound();
            }

            var teamDtos = new TeamDto
            {
                Id = teams.Id,
                Name = teams.TeamName,
                IsFavorite = teams.IsFavorite,
                PokemonIds = teams.TeamPokemons.Select(t => t.PokemonId).ToList()
            };

            return Ok(teamDtos);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateTeam(Guid id, [FromBody] UpdateTeamDto updateTeamDto)
        {
            var team = await _teamRepository.GetByIdAsync(id);

            if (team == null)
            {
                return NotFound();
            }

            team.TeamName = updateTeamDto.Name;
            team.IsFavorite = updateTeamDto.IsFavorite;

            team.TeamPokemons.Clear();
            foreach(var (pokemonId, index) in updateTeamDto.PokemonIds.Select((value, i) => (value, i)))
            {
                team.TeamPokemons.Add(new TeamPokemon { PokemonId = pokemonId, Position = index + 1 });
            }

            await _teamRepository.UpdateAsync(team);

            return NoContent();
        }

        [HttpDelete("id")]
        public async Task<IActionResult> DeleteTeam(Guid id)
        {
            var team = await _teamRepository.GetByIdAsync(id);
            if (team == null)
            {
                return NotFound();
            }
            await _teamRepository.DeleteAsync(id);
            return NoContent();
        }
    }
}