
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    [Authorize(Roles = "BusinessOwner,Admin,Employee,Customer")]
    public class SalonRecommenderController : Controller
    {
        private readonly SalonRecommenderService service;
        public SalonRecommenderController(SalonRecommenderService service)
        {
            this.service = service;
        }

        [HttpGet("RecomendedSalon/{SalonId}")]
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
