using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.SearchObjects;

namespace easyAppointment.Contributor.Services
{
    public interface IUserService : ICRUDService<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        Task<(UserResponse, string)> Login(string username, string password);
        UserResponse Register(UserInsertRequest request);
        Task<List<UserResponse>> GetUsersByRoleAndUnassigned(string roleName);

    }
}
