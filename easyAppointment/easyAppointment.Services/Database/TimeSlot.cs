using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class TimeSlot
{
    public int TimeSlotId { get; set; }

    public DateTime? StartTime { get; set; }

    public DateTime? EndTime { get; set; }

    public int? SalonId { get; set; }

    public int? SalonEmployeeId { get; set; }

    public DateTime? SlotDate { get; set; }

    public int Duration { get; set; }

    public int? OwnerUserId { get; set; }

    public string? Status { get; set; }

    public virtual SalonEmployee? SalonEmployee { get; set; }

    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    public virtual Salon? Salon { get; set; }
}

