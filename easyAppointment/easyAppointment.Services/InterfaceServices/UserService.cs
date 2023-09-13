using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
//using easyAppointment.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.InterfaceServices
{
    public interface UserService : ICRUDService<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        Task<(UserResponse, string)> Login(string username, string password);
        UserResponse Register(UserInsertRequest request);
        Task<List<UserResponse>> GetUsersByRoleAndUnassigned(string roleName);

    }
}