using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    [Authorize(Roles = "BusinessOwner,Admin,Employee,Customer")]
    public class SexController : BaseController<SexResponse, SexSearchObject>
    {
        public SexController(ILogger<BaseController<SexResponse, SexSearchObject>> _logger, Service<SexResponse, SexSearchObject> _service) : base(_logger, _service)
        {
        }
    }
}
