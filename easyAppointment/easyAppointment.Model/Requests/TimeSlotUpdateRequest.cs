using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class TimeSlotUpdateRequest
    {

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public DateTime? SlotDate { get; set; }

    }
}
