using Fluttedex.Backend.Domain.Entities;

namespace Fluttedex.Backend.Domain.Entities
{
    public interface IUserRepository
    {
        Task<User?> GetByEmailAsync(string email);
        Task AddAsync(User user);
        
    }
}