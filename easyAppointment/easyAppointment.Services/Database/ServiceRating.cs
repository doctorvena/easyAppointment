using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class ServiceRating
{
    public int ServiceRatingId { get; set; }

    public double Rating { get; set; }

    public DateTime RatingDate { get; set; }

    public int? UserId { get; set; }

    public int? ServiceId { get; set; }

    public virtual Service? Service { get; set; }

    public virtual User? User { get; set; }
}
