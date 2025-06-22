using Fluttedex.Backend.Application.Dtos;
using Fluttedex.Backend.Domain.Entities;
using Fluttedex.Backend.Domain.Interfaces;
using Flutteedex.Backend.Application.Dtos;
using Microsoft.AspNetCore.Mvc;

namespace Fluttedex.Backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TeamsController : ControllerBase
    {
        private readonly ITeamRepository _teamRepository;


        [HttpPost]
        public async Task<IActionResult> CreateTeam([FromBody] CreateTeamDto createTeamDto, CancellationToken cancellationToken)
        {
            if (createTeamDto == null)
            {
                return BadRequest("Team data is required.");
            }

            Guid currentUserId = Guid.Parse("e13c11ee-497a-4c22-b38d-0e8fb942aa47"); // Replace with actual user ID retrieval logic

            var team = new Team
            {
                Id = currentUserId,
                TeamName = createTeamDto.Name,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                TeamPokemons = createTeamDto.PokemonIds.Select((id, index) => new TeamPokemon
                {
                    PokemonId = id,
                    Position = index + 1, // Assuming position starts from 1
                }).ToList(),
            };
            await _teamRepository.AddAsync(team, cancellationToken);

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
        public async Task<ActionResult<TeamDto>> GetTeamById(Guid id, CancellationToken cancellationToken)
        {
            var team = await _teamRepository.GetByIdAsync(id, cancellationToken);
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
        public async Task<ActionResult<TeamDto>> GetAllTeams(CancellationToken cancellationToken)
        {
            var teams = await _teamRepository.GetAllAsync(cancellationToken);
            var teamDtos = teams.Select(t => new TeamDto
            {
                Id = t.Id,
                Name = t.TeamName,
                IsFavorite = t.IsFavorite,
                PokemonIds = t.TeamPokemons.Select(tp => tp.PokemonId).ToList()
            }).ToList();
            return Ok(teamDtos);
        }
    }
}