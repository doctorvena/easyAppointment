using easyAppointment.Reservation.FeignResponses;
using easyAppointment.Reservation.Responses;
using System.Net.Http.Headers;

namespace easyAppointment.Reservation.FeignClient
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
