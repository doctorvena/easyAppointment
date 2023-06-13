using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;

namespace easyAppointment.Controllers
{
    public class SexController : BaseController<SexResponse, SexSearchObject>
    {
        public SexController(ILogger<BaseController<SexResponse, SexSearchObject>> _logger, Service<SexResponse, SexSearchObject> _service) : base(_logger, _service)
        {
        }
    }
}
