using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class Sex
{
    public int SexId { get; set; }

    public string SexName { get; set; } = null!;

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
