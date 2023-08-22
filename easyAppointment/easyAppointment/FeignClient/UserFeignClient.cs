using Azure;
using easyAppointment.Reservation.FeignResponses;

namespace easyAppointment.Reservation.FeignClient
{
    public class UserFeignClient
    {
        private readonly HttpClient _client;

        public UserFeignClient(HttpClient client)
        {
            _client = client;
            _client.BaseAddress = new Uri("https://localhost:7126/");
        }

        public async Task<UserResponse> GetById(int id)
        {
            var response = await _client.GetAsync($"/Users/{id}");
            response.EnsureSuccessStatusCode();

            var user = await response.Content.ReadAsAsync<UserResponse>();
            return user;
        }

        public async Task<List<UserResponse>> GetUsersByRoleAndUnassigned(string roleName)
        {
            var response = await _client.GetAsync($"/Users/role/{roleName}/unassigned");
            response.EnsureSuccessStatusCode();

            var users = await response.Content.ReadAsAsync<List<UserResponse>>();
            return users;
        }

        internal async Task<UserResponse> GetUserByUsername(string username)
        {

            var response = await _client.GetAsync($"api/users/{username}");
            response.EnsureSuccessStatusCode();

            var user = await response.Content.ReadAsAsync<UserResponse>();
            return user;
        }
    }
}
