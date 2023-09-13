using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class Salon
{
    public int SalonId { get; set; }
    public string SalonName { get; set; } = null!;
    public string? Address { get; set; }
    public int? ReservationPrice { get; set; }
    public int? OwnerUserId { get; set; }
    public int? CityId { get; set; }
    public double? Rating { get; set; }
    public byte[]? Photo { get; set; }
    public virtual City? City { get; set; }
    public virtual User? OwnerUser { get; set; }
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();
    public virtual ICollection<SalonEmployee> SalonEmployees { get; set; } = new List<SalonEmployee>();
    public virtual ICollection<SalonRating> SalonRatings { get; set; } = new List<SalonRating>();
    public virtual ICollection<TimeSlot> TimeSlots { get; set; } = new List<TimeSlot>();
}
