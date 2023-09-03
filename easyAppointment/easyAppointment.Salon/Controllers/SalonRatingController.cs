using easyAppointment.Salon.Controllers;
using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Requests;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using eeasyAppointment.Salon.Controllers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.SalonRating.SalonRating
{
    [ApiController]
    [Authorize(Roles = "BusinessOwner,Admin,Employee,Customer")]
    public class SalonRatingController : BaseCRUDController<SalonRatingResponse, SalonRatingSearchObject, SalonRatingInsertRequest,SalonRatingUpdateRequest>
    {
        private readonly SalonRatingService _SalonRatingService;
        public SalonRatingController(ILogger<BaseController<SalonRatingResponse,SalonRatingSearchObject>> logger, SalonRatingService _service) : base(logger, _service)
        {
            _SalonRatingService = _service;
        }

    }
}