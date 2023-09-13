using Microsoft.AspNetCore.Mvc;
using System.Net;
using Microsoft.AspNetCore.Authorization;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Model.Responses;
using easyAppointment.Model;

namespace easyAppointment.Controllers
{
    [ApiController]
    [Route("Login")]
    [AllowAnonymous]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly UserService _userService;

        public LoginController(IConfiguration configuration, UserService userService)
        {
            _configuration = configuration;
            _userService = userService;
        }

        [HttpPost]
        public async Task<ActionResult<object>> Authenticate(string username, string password)
        {
            var loginResponse = new LoginResponse { };

            try
            {
                var (user, token) = await _userService.Login(username, password);

                if (user == null)
                {
                    return BadRequest("Username or Password Invalid!");
                }

                loginResponse.Token = token;
                loginResponse.user = new UserResponse ();
                loginResponse.user.UserId = user.UserId;
                loginResponse.user.FirstName = user.FirstName;
                loginResponse.user.LastName = user.LastName;
                loginResponse.user.Email = user.Email;
                loginResponse.user.Photo = user.Photo;
                loginResponse.user.Phone = user.Phone;
                loginResponse.user.Username = user.Username;
                loginResponse.user.Status = user.Status;
                loginResponse.user.UserRoles = user.UserRoles; 
                loginResponse.responseMsg = new HttpResponseMessage()
                {
                    StatusCode = HttpStatusCode.OK
                };

                return Ok(new { loginResponse });
            }
            catch (UserException ex) 
            {
                return BadRequest(ex.Message);
            }
            catch
            {
                return StatusCode(500, "An unexpected error occurred");
            }
        }


  
    }
}
