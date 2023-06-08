using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class Reservation
{
    public int ReservationId { get; set; }

    public int? UserBusinessId { get; set; }

    public int? UserCustomerId { get; set; }

    public int? TimeSlotId { get; set; }

    public DateTime? ReservationDate { get; set; }

    public string? ReservationName { get; set; }

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual TimeSlot? TimeSlot { get; set; }

    public virtual User? UserBusiness { get; set; }

    public virtual User? UserCustomer { get; set; }
}
