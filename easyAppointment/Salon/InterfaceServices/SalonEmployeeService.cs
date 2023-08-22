using easyAppointment.Salon.Requests;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;

namespace easyAppointment.Salon.InterfaceServices
{
    public interface SalonEmployeeService : ICRUDService<SalonEmployeeResponse, SalonEmployeeSearchObject, SalonEmployeeInsertRequest, SalonEmployeeUpdateRequest>
    {
        Task<SalonEmployeeResponse> AddSalonEmployee(string username, int salonId);
    }
}
