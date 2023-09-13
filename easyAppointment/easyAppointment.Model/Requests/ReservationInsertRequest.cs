using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class ReservationInsertRequest
    {
        public int? SalonId { get; set; }
        public int? UserCustomerId { get; set; }
        public string? Status { get; set; }
        public int? TimeSlotId { get; set; }
        public bool IsPaid { get; set; }
        public DateTime? ReservationDate { get; set; }
        public string? ReservationName { get; set; }
    }
}
