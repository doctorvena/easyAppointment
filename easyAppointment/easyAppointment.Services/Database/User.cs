using System;
using System.Collections.Generic;

namespace easyAppointment.Services.Database;

public partial class User
{
    public int UserId { get; set; }

    public string FirstName { get; set; } = null!;

    public string? LastName { get; set; }

    public string? Email { get; set; }

    public string? Phone { get; set; }

    public string Username { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string PasswordSalt { get; set; } = null!;

    public bool? Status { get; set; }

    public virtual ICollection<Reservation> ReservationUserBusinesses { get; set; } = new List<Reservation>();

    public virtual ICollection<Reservation> ReservationUserCustomers { get; set; } = new List<Reservation>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual ICollection<TimeSlot> TimeSlots { get; set; } = new List<TimeSlot>();

    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
}
