using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [AllowAnonymous]
    public class UsersController : BaseCRUDController<UserResponse,UserSearchObject,UserInsertRequest,UserUpdateRequest>
    {
        protected UserService _service;
        public UsersController(ILogger<BaseController<UserResponse,UserSearchObject>> logger, UserService service)
            : base(logger,service)
        {
            this._service = service;
        }

        [AllowAnonymous]
        [HttpPost("register")]
        public UserResponse Register(UserInsertRequest request)
        {
            return _service.Register(request);
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<UserResponse> Login(string username, string password)
        {
            return await _service.Login(username, password);
        }

    }
}