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

        public TimeSpan? StartTime { get; set; }

        public TimeSpan? EndTime { get; set; }

        public int? BusinessId { get; set; }

        public TimeSpan Duration { get; set; }

    }
}
