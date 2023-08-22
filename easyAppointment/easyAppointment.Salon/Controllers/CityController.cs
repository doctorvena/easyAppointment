using easyAppointment.Salon.Controllers;
using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using Microsoft.AspNetCore.Authorization;

namespace easyAppointment.Slon.Controllers
{
    [Authorize]
    public class CityController : BaseController<CityResponse, BaseSearchObject>
    {
        public CityController(ILogger<BaseController<CityResponse, BaseSearchObject>> _logger, CityService _service) : base(_logger, _service)
        {
        }
    }
}
