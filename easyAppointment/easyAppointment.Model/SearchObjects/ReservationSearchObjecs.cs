using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.SearchObjects
{
    public class ReservationSearchObjecs : BaseSearchObject
    {
        public int? SalonId { get; set; }
        public int? UserCustomerId { get; set; }
        public bool? IsActive { get; set; }
        public int? TimeSlotId { get; set; }
        public int? EmployeeUserId { get; set; }
        public DateTime? ReservationDate { get; set; }
        public string? ReservationName { get; set; }
    }
}
