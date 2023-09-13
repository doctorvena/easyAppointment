using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;

namespace easyAppointment.Services.InterfaceServices
{
    public interface ReservationsService : ICRUDService<ReservationsResponse, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>
    {
        Task<List<ReservationsResponse>> GetReservationsForEmployeeUserId(int employeeUserId);
    }
}
