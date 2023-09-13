using easyAppointment.Controllers;
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
    public class SalonRatingController : BaseCRUDController<SalonRatingResponse, SalonRatingSearcchObject, SalonRatingInsertRequest,SalonRatingUpdateRequest>
    {
        private readonly SalonRatingService _SalonRatingService;
        public SalonRatingController(ILogger<BaseController<SalonRatingResponse, SalonRatingSearcchObject>> logger, SalonRatingService _service) : base(logger, _service)
        {
            _SalonRatingService = _service;
        }

    }
}