using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class SalonPhoto
{
    public int PhotoId { get; set; }

    public byte[]? Photo { get; set; }

    public int? SalonId { get; set; }

    public int? ServiceId { get; set; }

    public virtual Salon? Salon { get; set; }

    public virtual Service? Service { get; set; }
}
