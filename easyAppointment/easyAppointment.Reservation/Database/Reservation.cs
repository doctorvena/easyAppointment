using System;
using System.Collections.Generic;

namespace easyAppointment.Reservation.Database;

public partial class Reservation
{
    public int ReservationId { get; set; }

    public int? SalonId { get; set; }

    public int? UserCustomerId { get; set; }

    public int? TimeSlotId { get; set; }

    public string? Status { get; set; }
    public DateTime? CancellationDate { get; set; }

    public DateTime? ReservationDate { get; set; }

    public string? ReservationName { get; set; }

    public virtual TimeSlot? TimeSlot { get; set; }

}
