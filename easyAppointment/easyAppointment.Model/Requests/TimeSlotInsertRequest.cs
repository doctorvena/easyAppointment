using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class TimeSlotInsertRequest
    {

        public TimeSpan? StartTime { get; set; }

        public TimeSpan? EndTime { get; set; }

        public int? BusinessId { get; set; }

        public TimeSpan Duration { get; set; }

    }
}
