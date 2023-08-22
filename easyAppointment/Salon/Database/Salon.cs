using System;
using System.Collections.Generic;

namespace easyAppointment.Salon.Database;
public partial class Salon
{
    public int SalonId { get; set; }

    public string SalonName { get; set; } = null!;

    public string? Address { get; set; }

    public int? OwnerUserId { get; set; }

    public int? CityId { get; set; }

    public byte[]? Photo { get; set; }

    public virtual ICollection<SalonEmployee> SalonEmployees { get; set; } = new List<SalonEmployee>();

    public virtual ICollection<SalonRating> SalonRatings { get; set; } = new List<SalonRating>();

}
