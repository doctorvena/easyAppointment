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
    [AllowAnonymous]
    public class ServiceController : BaseCRUDController<ServiceResponse, ServiceSearchObject,ServiceInsertRequest,ServiceUpdateRequest>
    {
        public ServiceController(ILogger<BaseController<ServiceResponse, ServiceSearchObject>> logger, ServiceService _service) : base(logger, _service)
        {

        }
    }
}