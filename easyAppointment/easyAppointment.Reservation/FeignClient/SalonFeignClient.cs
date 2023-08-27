using easyAppointment.Reservation.FeignResponses;
using easyAppointment.Reservation.Responses;

namespace easyAppointment.Reservation.FeignClient
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
    }

}
