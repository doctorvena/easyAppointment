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
    public class ServiceRatingController : BaseCRUDController<ServiceRatingResponse, ServiceRatingSearcchObject,ServiceRatingInsertRequest,ServiceRatingUpdateRequest>
    {
        public ServiceRatingController(ILogger<BaseController<ServiceRatingResponse, ServiceRatingSearcchObject>> logger, ServiceRatingService _service) : base(logger,_service)
        {
        }
    }
}