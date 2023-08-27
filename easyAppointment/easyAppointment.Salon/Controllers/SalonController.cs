using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using easyAppointment.Salon.SearchObjects;
using eeasyAppointment.Salon.Controllers;
using easyAppointment.Salon.Controllers;

namespace easyAppointment.Salon.Salon
{
    [ApiController]
    [Authorize(Roles = "BusinessOwner,Admin,Employee,Customer")]
    public class SalonController : BaseCRUDController<SalonResponse, SalonSearchObject,SalonInsertRequest,SalonUpdateRequest>
    {
        private readonly SalonService _salonService;
        public SalonController(ILogger<BaseController<SalonResponse,SalonSearchObject>> logger, SalonService _service) : base(logger, _service)
        {
            _salonService = _service;
        }

        [HttpGet("employee/{employeeId}/salon")]
        public async Task<ActionResult<SalonResponse>> GetSalonByEmployeeId(int employeeId)
        {
            var salonResponse = await _salonService.GetSalonByEmployeeId(employeeId);

            if (salonResponse == null)
            {
                return NotFound();
            }

            return salonResponse;
        }

    }
}