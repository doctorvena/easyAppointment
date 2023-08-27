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
    public class ReservationsController : BaseCRUDController<ReservationsResponse,ReservationSearchObjecs,ReservationInsertRequest,ReservationUpdateRequest>
    {
        public ReservationsController(ILogger<BaseController<ReservationsResponse, ReservationSearchObjecs>> _logger, ReservationsService _service) 
            : base(_logger, _service)
        {

        }
    }
}