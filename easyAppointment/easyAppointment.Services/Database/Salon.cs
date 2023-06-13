using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class Salon
{
    public int SalonId { get; set; }

    public string SalonName { get; set; } = null!;

    public string? Address { get; set; }

    public int? OwnerUserId { get; set; }

    public int? CityId { get; set; }

    public byte[]? Photo { get; set; }

    public virtual City? City { get; set; }

    public virtual User? OwnerUser { get; set; }

    public virtual ICollection<SalonEmployee> SalonEmployees { get; set; } = new List<SalonEmployee>();

    public virtual ICollection<SalonPhoto> SalonPhotos { get; set; } = new List<SalonPhoto>();

    public virtual ICollection<Service> Services { get; set; } = new List<Service>();
}
