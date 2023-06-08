using AutoMapper;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    public class ReviewController : BaseController<ReviewResponse, ReviewSearcchObject>
    {
        public ReviewController(ILogger<BaseController<ReviewResponse, ReviewSearcchObject>> logger, Service<ReviewResponse, ReviewSearcchObject> _service) : base(logger,_service)
        {
        }

       
    }
}