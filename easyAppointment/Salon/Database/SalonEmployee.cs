using System;
using System.Collections.Generic;

namespace easyAppointment.Salon.Database;

public partial class SalonEmployee
{
    public int SalonEmployeeId { get; set; }

    public int? SalonId { get; set; }

    public int? EmployeeUserId { get; set; }

    public byte[]? Photo { get; set; }

    public virtual Salon? Salon { get; set; }
}
