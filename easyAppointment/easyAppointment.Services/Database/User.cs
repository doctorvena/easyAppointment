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

    public string? Status { get; set; }

    public int? SexId { get; set; }

    public string Username { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string PasswordSalt { get; set; } = null!;

    public byte[]? Photo { get; set; }

    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    public virtual ICollection<SalonEmployee> SalonEmployees { get; set; } = new List<SalonEmployee>();

    public virtual ICollection<SalonRating> SalonRatings { get; set; } = new List<SalonRating>();

    public virtual ICollection<Salon> Salons { get; set; } = new List<Salon>();

    public virtual Sex? Sex { get; set; }

    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
}
