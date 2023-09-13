using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class City
{
    public int CityId { get; set; }

    public string CityName { get; set; } = null!;

    public string? Country { get; set; }

    public virtual ICollection<Salon> Salons { get; set; } = new List<Salon>();
}
