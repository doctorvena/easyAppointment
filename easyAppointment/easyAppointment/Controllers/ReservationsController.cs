using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace easyAppointment.Controllers
{
    [ApiController]
    [Authorize(Roles = "BusinessOwner,Admin,Employee,Customer")]
    public class ReservationsController : BaseCRUDController<ReservationsResponse, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>
    {
        private readonly ReservationsService _reservationService;

        public ReservationsController(ILogger<BaseController<ReservationsResponse, ReservationSearchObjecs>> _logger, ReservationsService _service)
            : base(_logger, _service)
        {
            _reservationService = _service;
        }

        [HttpGet("ByEmployee/{employeeUserId}")]
        public async Task<IActionResult> GetReservationsForEmployeeUserId(int employeeUserId)
        {
            try
            {
                var reservations = await _reservationService.GetReservationsForEmployeeUserId(employeeUserId);
                return Ok(reservations);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
