using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using Microsoft.AspNetCore.Mvc;
using easyAppointment.Salon.SearchObjects;
using easyAppointment.Salon.Requests;
using eeasyAppointment.Salon.Controllers;
using Microsoft.AspNetCore.Authorization;

namespace easyAppointment.Salon.Controllers
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