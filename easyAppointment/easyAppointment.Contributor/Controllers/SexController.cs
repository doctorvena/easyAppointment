using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.SearchObjects;
using easyAppointment.Contributor.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Contributor.Controllers
{
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class SexController : BaseController<SexResponse, SexSearchObject>
    {
        public SexController(ILogger<BaseController<SexResponse, SexSearchObject>> _logger, Service<SexResponse, SexSearchObject> _service) : base(_logger, _service)
        {
        }
    }
}
