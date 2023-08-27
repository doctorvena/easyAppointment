using Azure;
using easyAppointment.Reservation.FeignResponses;
using System.Net.Http.Headers;
using System.Net.Http;

namespace easyAppointment.Reservation.FeignClient
{
    public class UserFeignClient
    {
        private readonly HttpClient _client;
        private readonly IHttpContextAccessor _contextAccessor;
        public UserFeignClient(HttpClient client, IHttpContextAccessor contextAccessor)
        {
            _client = client;
            _client.BaseAddress = new Uri("http://contributor:5000/");
            _contextAccessor = contextAccessor;
        }

        public async Task<UserResponse> GetById(int id)
        {
            SetAuthorizationHeader();
            var response = await _client.GetAsync($"/Users/{id}");
            response.EnsureSuccessStatusCode();

            var user = await response.Content.ReadAsAsync<UserResponse>();
            return user;
        }

        public async Task<List<UserResponse>> GetUsersByRoleAndUnassigned(string roleName)
        {
            SetAuthorizationHeader();
            var response = await _client.GetAsync($"/Users/role/{roleName}/unassigned");
            response.EnsureSuccessStatusCode();

            var users = await response.Content.ReadAsAsync<List<UserResponse>>();
            return users;
        }

        internal async Task<UserResponse> GetUserByUsername(string username)
        {
            SetAuthorizationHeader();
            var response = await _client.GetAsync($"api/users/{username}");
            response.EnsureSuccessStatusCode();

            var user = await response.Content.ReadAsAsync<UserResponse>();
            return user;
        }

        private void SetAuthorizationHeader()
        {
            var token = _contextAccessor.HttpContext.Request.Headers["Authorization"].FirstOrDefault();
            if (!string.IsNullOrWhiteSpace(token))
            {
                _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token.Replace("Bearer ", ""));
            }
        }

    }
}
