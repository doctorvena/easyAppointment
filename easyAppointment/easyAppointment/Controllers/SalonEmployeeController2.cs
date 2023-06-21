using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    public class SalonEmployeeController : BaseCRUDController<SalonEmployeeResponse, SalonEmployeeSearchObject, SalonEmployeeInsertRequest,SalonEmployeeUpdateRequest>
    {
        public SalonEmployeeController(ILogger<BaseController<SalonEmployeeResponse, SalonEmployeeSearchObject>> logger, SalonEmployeeService _service) : base(logger,_service)
        {
        }

       
    }
}