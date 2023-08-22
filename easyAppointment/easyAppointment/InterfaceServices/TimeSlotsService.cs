using easyAppointment.Reservation.Requests;
using easyAppointment.Reservation.Responses;
using easyAppointment.Reservation.SearchObjects;

namespace easyAppointment.Reservation.InterfaceServices
{
    public interface TimeSlotsService : ICRUDService<TimeslotResponse, TimeSlotSearchObject, TimeSlotInsertRequest, TimeSlotUpdateRequest>
    {
        Task<List<TimeslotResponse>> GenerateTimeSlotsForEmployee(TimeSlotGenerationRequest request);

    }
}
