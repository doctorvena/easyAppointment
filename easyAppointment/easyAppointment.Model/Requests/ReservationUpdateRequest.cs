using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class ReservationUpdateRequest
    {

        public int? TimeSlotId { get; set; }
        public string? Status { get; set; }
        public DateTime? ReservationDate { get; set; }
        public string? ReservationName { get; set; }

        //public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

        //public virtual TimeSlot? TimeSlot { get; set; }

        //public virtual User? UserBusiness { get; set; }

        //public virtual User? UserCustomer { get; set; }
    }
}
