using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.SearchObjects
{
    public class TimeSlotSearchObject : BaseSearchObject
    {
        public int duration {get; set;}

        public int? ServiceId { get; set; }
        public string? Status { get; set; }

        public int? EmployeeId { get; set; }
        public int? BusinessId { get; set; }
    }
}
