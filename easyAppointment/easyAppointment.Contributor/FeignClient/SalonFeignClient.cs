using easyAppointment.Contributor.FeignResponses;
using easyAppointment.Contributor.Models ;

namespace easyAppointment.Contributor.FeignClient
{
    public class SalonFeignClient
    {
        private readonly HttpClient _httpClient;

        public SalonFeignClient(HttpClient client)
        {
            _httpClient = client;
            _httpClient.BaseAddress = new Uri("http://localhost:6000/");
        }

        public async Task<SalonEmployeeResponse> GetById(int? id)
        {
            var response = await _httpClient.GetAsync($"/SalonEmployee/{id}");
            response.EnsureSuccessStatusCode();

            var user = await response.Content.ReadAsAsync<SalonEmployeeResponse>();
            return user;
        }

        public async Task<bool> DeleteByOwnerId(int ownerId)
        {
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
            var response = await _httpClient.GetAsync("/SalonEmployee");
            response.EnsureSuccessStatusCode();

            var employees = await response.Content.ReadAsAsync<List<SalonEmployeeResponse>>();
            return employees;
        }

    }
}
