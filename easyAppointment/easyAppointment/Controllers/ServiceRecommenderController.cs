using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    public class SalonRecommenderController : Controller
    {
        private readonly SalonRecommenderService service;
        public SalonRecommenderController(SalonRecommenderService service)
        {
            this.service = service;
        }

        [HttpGet("{SalonId}")]
        public IActionResult RecommendedProduct(int SalonId)
        {
            try
            {
                return Ok(service.Recommend(SalonId));
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex);
            }
        }
    }
}
