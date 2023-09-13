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
    public class TimeSlotsController : BaseCRUDController<TimeslotResponse, TimeSlotSearchObject,TimeSlotInsertRequest,TimeSlotUpdateRequest>
    {
        public TimeSlotsController(ILogger<BaseController<TimeslotResponse,TimeSlotSearchObject>> logger, TimeSlotsService _service) : base(logger, _service)
        {

        }
    }
}