using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Security.Claims;
using System.Security.Cryptography;
using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.Services;

namespace easyAppointment.Contributor.Controllers
{
    [ApiController]
    [Route("Login")]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IUserService _userService;

        public LoginController(IConfiguration configuration, IUserService userService)
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
                // Authenticate using the UserService
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
                loginResponse.user.UserRoles = user.UserRoles; // Assuming the service returns the roles
                loginResponse.responseMsg = new HttpResponseMessage()
                {
                    StatusCode = HttpStatusCode.OK
                };

                return Ok(new { loginResponse });
            }
            catch (UserException ex) // Handle specific user-related exceptions
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
