using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    public class ServiceRecommender : Controller
    {
        private readonly ServiceRecommenderService service;
        public ServiceRecommender(ServiceRecommenderService service)
        {
            this.service = service;
        }

        [HttpGet("{ServiceId}")]
        public IActionResult RecommendedProduct(int ServiceId)
        {
            try
            {
                return Ok(service.Recommend(ServiceId));
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex);
            }
        }
    }
}
