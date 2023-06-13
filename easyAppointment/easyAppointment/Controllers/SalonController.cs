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
    public class SalonController : BaseCRUDController<SalonResponse, SalonSearchObject,SalonInsertRequest,SalonUpdateRequest>
    {
        public SalonController(ILogger<BaseController<SalonResponse,SalonSearchObject>> logger, SalonService _service) : base(logger, _service)
        {

        }
    }
}