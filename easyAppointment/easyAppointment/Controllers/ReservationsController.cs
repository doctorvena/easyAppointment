using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ReservationsController : BaseCRUDController<ReservationsResponse,ReservationSearchObjecs,ReservationInsertRequest,ReservationUpdateRequest>
    {
        public ReservationsController(ILogger<BaseController<ReservationsResponse, ReservationSearchObjecs>> _logger, ReservationsService _service) 
            : base(_logger, _service)
        {

        }
    }
}