using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [ApiController]
    [Authorize(Roles = "BusinessOwner,Admin,Employee,Customer")]
    public class SalonEmployeeController : BaseCRUDController<SalonEmployeeResponse, SalonEmployeeSearchObject, SalonEmployeeInsertRequest, SalonEmployeeUpdateRequest>
    {
        private readonly SalonEmployeeService _salonEmployeeService;

        public SalonEmployeeController(ILogger<BaseController<SalonEmployeeResponse, SalonEmployeeSearchObject>> logger, SalonEmployeeService salonEmployeeService) : base(logger, salonEmployeeService)
        {
            _salonEmployeeService = salonEmployeeService;
        }

        [HttpPost("AddSalonEmployee")]
        public async Task<ActionResult<SalonEmployeeResponse>> AddSalonEmployee(string username, int salonId)
        {
            return await _salonEmployeeService.AddSalonEmployee(username, salonId);
            
        }
    }

}