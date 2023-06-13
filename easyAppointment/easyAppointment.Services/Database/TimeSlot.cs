using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class TimeSlot
{
    public int TimeSlotId { get; set; }

    public DateTime? StartTime { get; set; }

    public DateTime? EndTime { get; set; }

    public int? ServiceId { get; set; }

    public int? EmployeeId { get; set; }

    public DateTime? SlotDate { get; set; }

    public int Duration { get; set; }

    public virtual SalonEmployee? Employee { get; set; }

    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    public virtual Service? Service { get; set; }
}
