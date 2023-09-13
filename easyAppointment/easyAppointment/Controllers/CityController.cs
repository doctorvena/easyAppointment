using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Services.ServiceImpl;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
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
