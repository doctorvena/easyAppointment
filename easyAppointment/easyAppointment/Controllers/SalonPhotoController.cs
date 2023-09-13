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
    public class SalonPhotoController : BaseCRUDController<SalonPhotoResponse, SalonPhotoSearchObject,SalonPhotoInsertRequest,SalonPhotoUpdateRequest>
    {
        public SalonPhotoController(ILogger<BaseController<SalonPhotoResponse, SalonPhotoSearchObject>> logger, SalonPhotoService _SalonPhoto) : base(logger, _SalonPhoto)
        {

        }
    }
}