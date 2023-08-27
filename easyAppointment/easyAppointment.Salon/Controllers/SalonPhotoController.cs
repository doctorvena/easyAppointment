using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using easyAppointment.Salon.SearchObjects;
using eeasyAppointment.Salon.Controllers;

namespace easyAppointment.Salon.Controllers
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