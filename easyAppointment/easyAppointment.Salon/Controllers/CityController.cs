using easyAppointment.Salon.Controllers;
using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Slon.Controllers
{
    [ApiController]
    [Authorize]
    public class CityController : BaseController<CityResponse, BaseSearchObject>
    {
        public CityController(ILogger<BaseController<CityResponse, BaseSearchObject>> _logger, CityService _service) : base(_logger, _service)
        {
        }
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
}
