using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;

namespace easyAppointment.Salon.InterfaceServices
{
    public interface SalonPhotoService : ICRUDService<SalonPhotoResponse, SalonPhotoSearchObject, SalonPhotoInsertRequest, SalonPhotoUpdateRequest>
    {
    }
}
