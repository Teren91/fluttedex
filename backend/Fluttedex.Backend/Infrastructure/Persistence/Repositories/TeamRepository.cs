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

        public async Task<Team?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
        {
            return await _context.Teams
                .Include(t => t.TeamPokemons) // Assuming Team has a Members collection
                .FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
        }
        public async Task<IEnumerable<Team>> GetAllAsync(CancellationToken cancellationToken = default)
        {
            return await _context.Teams.ToListAsync(cancellationToken);
        }
        public async Task AddAsync(Team team, CancellationToken cancellationToken = default)
        {
            await _context.Teams.AddAsync(team, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);
        }
        public async Task UpdateAsync(Team team, CancellationToken cancellationToken = default)
        {
            _context.Teams.Update(team);
            await _context.SaveChangesAsync(cancellationToken);
        }
        public async Task DeleteAsync(Guid id, CancellationToken cancellationToken = default)
        {
            var team = await GetByIdAsync(id, cancellationToken);
            if (team != null)
            {
                _context.Teams.Remove(team);
                await _context.SaveChangesAsync(cancellationToken);
            }
        }
        
    }
}