using Fluttedex.Backend.Domain.Entities;

namespace Fluttedex.Backend.Domain.Interfaces
{
    public interface ITeamRepository
    {
        Task<Team?> GetByIdAsync(Guid id);
        Task<IEnumerable<Team>> GetAllAsync();
        Task AddAsync(Team team);
        Task UpdateAsync(Team team);
        Task DeleteAsync(Guid id);
    }
}