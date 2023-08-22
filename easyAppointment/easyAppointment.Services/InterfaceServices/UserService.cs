using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;

namespace easyAppointment.Services.InterfaceServices
{
    public interface UserService : ICRUDService<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        public Task<UserResponse> Login(string username, string password);
        UserResponse Register(UserInsertRequest request);
        Task<List<UserResponse>> GetUsersByRoleAndUnassigned(string roleName);
    }
}
