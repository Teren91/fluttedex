using Fluttedex.Backend.Domain.Entities;

namespace Fluttedex.Backend.Domain.Interfaces
{
    public interface ITeamRepository
    {
        Task<Team?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
        Task<IEnumerable<Team>> GetAllAsync(CancellationToken cancellationToken = default);
        Task AddAsync(Team team, CancellationToken cancellationToken = default);
        Task UpdateAsync(Team team, CancellationToken cancellationToken = default);
        Task DeleteAsync(Guid id, CancellationToken cancellationToken = default);
    }
}