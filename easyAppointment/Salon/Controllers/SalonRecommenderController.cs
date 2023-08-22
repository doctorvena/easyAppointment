using easyAppointment.Salon.InterfaceServices;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Salon.Controllers
{
    public class SalonRecommenderController : Controller
    {
        private readonly SalonRecommenderService service;
        public SalonRecommenderController(SalonRecommenderService service)
        {
            this.service = service;
        }

        [HttpGet("{SalonId}")]
        public IActionResult RecommendedSalon(int SalonId)
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
