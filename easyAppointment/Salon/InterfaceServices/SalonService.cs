using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;

namespace easyAppointment.Salon.InterfaceServices
{
    public interface SalonService : ICRUDService<SalonResponse, SalonSearchObject, SalonInsertRequest, SalonUpdateRequest>
    {
        Task<SalonResponse> GetSalonByEmployeeId(int employeeId);
    }
}
