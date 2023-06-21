using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class Service
{
    public int ServiceId { get; set; }

    public string ServiceName { get; set; } = null!;

    public string? Description { get; set; }

    public decimal Price { get; set; }

    public int? SalonId { get; set; }

    public virtual Salon? Salon { get; set; }

    public virtual ICollection<SalonPhoto> SalonPhotos { get; set; } = new List<SalonPhoto>();

    public virtual ICollection<TimeSlot> TimeSlots { get; set; } = new List<TimeSlot>();
}
