using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace easyAppointment.Services.Database;
public partial class Reservation
{
    public int ReservationId { get; set; }
    public int? SalonId { get; set; }
    public int? UserCustomerId { get; set; }
    public int? TimeSlotId { get; set; }
    public string? Status { get; set; }
    public DateTime? CancellationDate { get; set; }
    public DateTime? ReservationDate { get; set; }
    public string? ReservationName { get; set; }
    public virtual TimeSlot? TimeSlot { get; set; }
    public int? Rating { get; set; }
    public double? Price { get; set; }
    public bool? IsPaid { get; set; }
    public virtual Salon? Salon { get; set; }
    public virtual User? UserCustomer { get; set; }
}


