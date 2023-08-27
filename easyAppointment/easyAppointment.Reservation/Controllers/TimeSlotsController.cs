using easyAppointment.Reservation.Controllers;
using easyAppointment.Reservation.InterfaceServices;
using easyAppointment.Reservation.Requests;
using easyAppointment.Reservation.Responses;
using easyAppointment.Reservation.SearchObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    [Authorize(Roles = "BusinessOwner,Admin,Employee,Customer")]
    public class TimeSlotsController : BaseCRUDController<TimeslotResponse, TimeSlotSearchObject, TimeSlotInsertRequest, TimeSlotUpdateRequest>
    {
        TimeSlotsService _timeSlotsService;
        public TimeSlotsController(ILogger<BaseController<TimeslotResponse, TimeSlotSearchObject>> logger, TimeSlotsService _service) : base(logger, _service)
        {
            _timeSlotsService = _service;
        }
        [HttpPost("generate-timeslots")]
        public async Task<List<TimeslotResponse>> GenerateTimeSlotsForEmployee(TimeSlotGenerationRequest request)
        {
            return await _timeSlotsService.GenerateTimeSlotsForEmployee(request);
        }
    }
}