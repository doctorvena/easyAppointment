using easyAppointment.Salon.Requests;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;

namespace easyAppointment.Salon.InterfaceServices
{
    public interface SalonRatingService : ICRUDService<SalonRatingResponse, SalonRatingSearcchObject,SalonRatingInsertRequest,SalonRatingUpdateRequest>
    {
    }
}
