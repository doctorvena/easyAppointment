using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public partial class TimeslotResponse
    {
        public int TimeSlotId { get; set; }
        public string? Status { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int? ServiceId { get; set; }
        public int? SalonEmployeeId { get; set; }
        public string employeeName { get; set; }
        public DateTime? SlotDate { get; set; }
        public int Duration { get; set; }
        public int? BusinessId { get; set; }
        public SalonEmployeeResponse Employee { get; set; }
    }
}
