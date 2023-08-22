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
    public interface TimeSlotsService : ICRUDService<TimeslotResponse, TimeSlotSearchObject, TimeSlotInsertRequest, TimeSlotUpdateRequest>
    {
        Task<List<TimeslotResponse>> GenerateTimeSlotsForEmployee(TimeSlotGenerationRequest request);

    }
}
