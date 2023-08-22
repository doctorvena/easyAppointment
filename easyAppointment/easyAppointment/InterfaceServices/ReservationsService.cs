using easyAppointment.Reservation.SearchObjects;
using easyAppointment.Reservation.Requests;
using easyAppointment.Reservation.Responses;

namespace easyAppointment.Reservation.InterfaceServices
{
    public interface ReservationsService : ICRUDService<ReservationsResponse, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>
    {
    }
}
