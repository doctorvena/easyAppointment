using System;
using System.Collections.Generic;

namespace easyAppointment.Database;

public partial class Photo
{
    public int PhotoId { get; set; }

    public byte[]? Photo1 { get; set; }

    public int? SalonId { get; set; }

    public int? ServiceId { get; set; }

}
