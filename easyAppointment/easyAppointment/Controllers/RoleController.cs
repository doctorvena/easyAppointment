using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;

namespace easyAppointment.Controllers
{
    [Authorize(Roles = "Admin")]
    public class RoleController : BaseController<RoleResponse, RoleSearchObject>
    {
        public RoleController(ILogger<BaseController<RoleResponse, RoleSearchObject>> _logger, Service<RoleResponse, RoleSearchObject> _service) : base(_logger, _service)
        {
        }
    }
}
