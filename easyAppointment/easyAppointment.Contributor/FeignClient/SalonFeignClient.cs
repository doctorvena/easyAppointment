using easyAppointment.Contributor.FeignResponses;
using easyAppointment.Contributor.Models ;
using System.Net.Http.Headers;

namespace easyAppointment.Contributor.FeignClient
{
    public class SalonFeignClient
    {
        private readonly HttpClient _httpClient;
        private readonly IHttpContextAccessor _contextAccessor;
        public SalonFeignClient(HttpClient client, IHttpContextAccessor contextAccessor)
        {
            _httpClient = client;
            _httpClient.BaseAddress = new Uri("http://salon:6000/");
            _contextAccessor = contextAccessor;
        }

        public async Task<SalonEmployeeResponse> GetById(int? id)
        {
            SetAuthorizationHeader();
            var response = await _httpClient.GetAsync($"/SalonEmployee/{id}");
            response.EnsureSuccessStatusCode();

            var user = await response.Content.ReadAsAsync<SalonEmployeeResponse>();
            return user;
        }

        public async Task<bool> DeleteByOwnerId(int ownerId)
        {
            SetAuthorizationHeader();
            var response = await _httpClient.DeleteAsync($"/Salon/{ownerId}");

            // Check if the response status code indicates success (e.g., 204 No Content)
            if (response.StatusCode == System.Net.HttpStatusCode.NoContent)
                return true;

            // Optional: Check for a NotFound status and handle as needed
            if (response.StatusCode == System.Net.HttpStatusCode.NotFound)
                return false;

            // Handle other statuses or throw an exception for unexpected statuses
            response.EnsureSuccessStatusCode();

            return false; // Default case: Assume deletion was not successful if no known status code was returned
        }

        public async Task<List<SalonEmployeeResponse>> GetAllSalonEmployees()
        {
            SetAuthorizationHeader();
            var response = await _httpClient.GetAsync("/SalonEmployee");
            response.EnsureSuccessStatusCode();

            var employees = await response.Content.ReadAsAsync<List<SalonEmployeeResponse>>();
            return employees;
        }
        private void SetAuthorizationHeader()
        {
            var token = _contextAccessor.HttpContext.Request.Headers["Authorization"].FirstOrDefault();
            if (!string.IsNullOrWhiteSpace(token))
            {
                _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token.Replace("Bearer ", ""));
            }
        }
    }
}
