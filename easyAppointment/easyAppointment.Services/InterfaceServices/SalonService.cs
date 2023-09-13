using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.InterfaceServices
{
    public interface SalonService : ICRUDService<SalonResponse, SalonSearchObject, SalonInsertRequest, SalonUpdateRequest>
    {
        Task<SalonResponse> GetSalonByEmployeeId(int employeeId);
        Task<int?> GetLastRatedSalonByUserId(int userId);
    }
}
