using Fluttedex.Backend.Domain.Entities;
using Fluttedex.Backend.Domain.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Fluttedex.Backend.Infrastructure.Persistence.Repositories
{
    public class TeamRepository : ITeamRepository
    {
        private readonly AppDbContext _context;
        public TeamRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Team?> GetByIdAsync(Guid id)
        {
            return await _context.Teams
                .Include(t => t.TeamPokemon) // Assuming Team has a Members collection
                .FirstOrDefaultAsync(t => t.Id == id);
        }
        public async Task<IEnumerable<Team>> GetAllAsync()
        {
            return await _context.Teams.ToListAsync();
        }
        public async Task AddAsync(Team team )
        {
            await _context.Teams.AddAsync(team);
            await _context.SaveChangesAsync();
        }
        public async Task UpdateAsync(Team team )
        {
            _context.Teams.Update(team);
            await _context.SaveChangesAsync();
        }
        public async Task DeleteAsync(Guid id )
        {
            var team = await GetByIdAsync(id);
            if (team != null)
            {
                _context.Teams.Remove(team);
                await _context.SaveChangesAsync();
            }
        }
        
    }
}