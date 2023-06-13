using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Services.ServiceImpl;

namespace easyAppointment.Controllers
{
    public class CityController : BaseController<CityResponse, BaseSearchObject>
    {
        public CityController(ILogger<BaseController<CityResponse, BaseSearchObject>> _logger, Service<CityResponse, BaseSearchObject> _service) : base(_logger, _service)
        {
        }
    }
}
