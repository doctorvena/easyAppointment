using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class TimeSlot
{
    public int TimeSlotId { get; set; }

    public TimeSpan? StartTime { get; set; }

    public TimeSpan? EndTime { get; set; }

    public int? BusinessId { get; set; }

    public TimeSpan Duration { get; set; }

    public virtual User? Business { get; set; }

    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();
}
