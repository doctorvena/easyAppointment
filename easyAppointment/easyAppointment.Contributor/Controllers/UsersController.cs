
using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.SearchObjects;
using easyAppointment.Contributor.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Contributor.Controllers
{
    [ApiController]
    public class UsersController : BaseCRUDController<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        protected IUserService _service;
        public UsersController(ILogger<BaseController<UserResponse, UserSearchObject>> logger, IUserService service)
            : base(logger, service)
        {
            this._service = service;
        }

        [AllowAnonymous]
        [HttpPost("Register")]
        public UserResponse Register(UserInsertRequest request)
        {
            return _service.Register(request);
        }

        [HttpGet("Role/{roleName}/Unassigned")]
        [Authorize(Roles = "BusinessOwner,Admin,Employee,Customer")]
        public async Task<List<UserResponse>> GetUsersByRoleAndUnassigned(string roleName)
        {
            return await _service.GetUsersByRoleAndUnassigned(roleName);
        }
    }
}