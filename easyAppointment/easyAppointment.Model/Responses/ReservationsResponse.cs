using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public partial class ReservationsResponse
    {
        public int ReservationId { get; set; }
        public int? SalonId { get; set; }
        public int? UserCustomerId { get; set; }
        public string? Status { get; set; }
        public int? TimeSlotId { get; set; }
        public DateTime? ReservationDate { get; set; }
        public string? ReservationName { get; set; }
        public virtual ICollection<TimeslotResponse> TimeSlots { get; set; } = new List<TimeslotResponse>();
        public int? Rating { get; set; }
        public double? Price { get; set; }
        public bool? IsPaid { get; set; }
    }
}
