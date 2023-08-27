using easyAppointment.Salon.Controllers;
using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Slon.Controllers
{
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class CityController : BaseController<CityResponse, BaseSearchObject>
    {
        public CityController(ILogger<BaseController<CityResponse, BaseSearchObject>> _logger, CityService _service) : base(_logger, _service)
        {
        }
    }
}
