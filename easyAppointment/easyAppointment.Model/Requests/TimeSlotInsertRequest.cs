using easyAppointment.Model.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class TimeSlotInsertRequest
    {
        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }
    public int? EmployeeId { get; set; }
        public int Duration { get; set; }
        public string? Status { get; set; }

        public int? BusinessId { get; set; }

        public DateTime? SlotDate { get; set; }

    }
}
