using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    public class ServiceRatingController : BaseCRUDController<SalonRatingResponse, SalonRatingSearcchObject, SalonRatingInsertRequest, SalonRatingUpdateRequest>
    {
        public ServiceRatingController(ILogger<BaseController<SalonRatingResponse, SalonRatingSearcchObject>> logger, SalonRatingService _service) : base(logger,_service)
        {
        }
    }
}