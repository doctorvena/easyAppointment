using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class SalonEmployee
{
    public int SalonEmployeeId { get; set; }

    public int? SalonId { get; set; }

    public int? EmployeeUserId { get; set; }

    public byte[]? Photo { get; set; }

    public virtual User? EmployeeUser { get; set; }

    public virtual Salon? Salon { get; set; }

    public virtual ICollection<TimeSlot> TimeSlots { get; set; } = new List<TimeSlot>();
}
