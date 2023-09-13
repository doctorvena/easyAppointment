using Azure.Core;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
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

        [HttpGet("LastRatedSalonByUser/{userId}")]
        public async Task<IActionResult> GetLastRatedSalonByUserId(int userId)
        {
            try
            {
                int? salonId = await _salonService.GetLastRatedSalonByUserId(userId);

                if (!salonId.HasValue)
                {
                    return Ok(new { salonId = 0 }); 
                }
                return Ok(new { salonId = salonId.Value });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }


    }
}