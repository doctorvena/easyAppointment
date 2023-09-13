using System;
using System.Collections.Generic;
using easyAppointment.Database;
using Microsoft.EntityFrameworkCore;

namespace easyAppointment.Services.Database;

public partial class EasyAppointmnetDbContext : DbContext
{
    public EasyAppointmnetDbContext()
    {
    }

    public EasyAppointmnetDbContext(DbContextOptions<EasyAppointmnetDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Reservation> Reservations { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Salon> Salons { get; set; }

    public virtual DbSet<SalonEmployee> SalonEmployees { get; set; }

    public virtual DbSet<SalonPhoto> SalonPhotos { get; set; }

    public virtual DbSet<SalonRating> SalonRatings { get; set; }

    public virtual DbSet<Sex> Sexes { get; set; }

    public virtual DbSet<TimeSlot> TimeSlots { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserRole> UserRoles { get; set; }

    //    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    //#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
    //        => optionsBuilder.UseSqlServer("Data Source=localhost; Database=easyAppointmnetDB; TrustServerCertificate=True; Trusted_Connection=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.CityId).HasName("PK__City__F2D21B768B8B25DD");

            entity.ToTable("City");

            entity.HasIndex(e => e.CityName, "UQ__City__886159E5246AA21C").IsUnique();

            entity.Property(e => e.CityName).HasMaxLength(255);
            entity.Property(e => e.Country).HasMaxLength(255);
        });

        modelBuilder.Entity<Reservation>(entity =>
        {
            entity.HasKey(e => e.ReservationId).HasName("PK__Reservat__B7EE5F04AB215F8C");

            entity.Property(e => e.ReservationId).HasColumnName("ReservationID");
            entity.Property(e => e.ReservationDate).HasColumnType("date");
            entity.Property(e => e.CancellationDate).HasColumnType("date");
            entity.Property(e => e.SalonId).HasColumnName("SalonID");
            entity.Property(e => e.Status).HasColumnName("Status");
            entity.Property(e => e.TimeSlotId).HasColumnName("TimeSlotID");
            entity.Property(e => e.UserCustomerId).HasColumnName("UserCustomerID");

            entity.HasOne(d => d.Salon).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.SalonId)
                .HasConstraintName("FK__Reservati__Salon__6C190EBB");

            entity.HasOne(d => d.TimeSlot).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.TimeSlotId)
                .HasConstraintName("FK__Reservati__TimeS__6E01572D");

            entity.HasOne(d => d.UserCustomer).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.UserCustomerId)
                .HasConstraintName("FK__Reservati__UserC__6D0D32F4");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Roles__8AFACE1A9DFC64B6");

            entity.HasIndex(e => e.RoleName, "UQ__Roles__8A2B61608A1658ED").IsUnique();

            entity.Property(e => e.RoleName).HasMaxLength(255);
        });

        modelBuilder.Entity<Salon>(entity =>
        {
            entity.HasKey(e => e.SalonId).HasName("PK__Salon__5E25586114FE893D");

            entity.ToTable("Salon");

            entity.Property(e => e.SalonName).HasMaxLength(255);

            entity.HasOne(d => d.City).WithMany(p => p.Salons)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__Salon__CityId__36B12243");

            entity.HasOne(d => d.OwnerUser).WithMany(p => p.Salons)
                .HasForeignKey(d => d.OwnerUserId)
                .HasConstraintName("FK__Salon__OwnerUser__35BCFE0A");
        });

        modelBuilder.Entity<SalonEmployee>(entity =>
        {
            entity.HasKey(e => e.SalonEmployeeId).HasName("PK__SalonEmp__D71B354531CAE998");

            entity.HasOne(d => d.EmployeeUser).WithMany(p => p.SalonEmployees)
                .HasForeignKey(d => d.EmployeeUserId)
                .HasConstraintName("FK__SalonEmpl__Emplo__3A81B327");

            entity.HasOne(d => d.Salon).WithMany(p => p.SalonEmployees)
                .HasForeignKey(d => d.SalonId)
                .HasConstraintName("FK__SalonEmpl__Salon__398D8EEE");
        });

        modelBuilder.Entity<SalonPhoto>(entity =>
        {
            entity.HasKey(e => e.PhotoId).HasName("PK__SalonPho__21B7B5E21D85B570");
        });

        modelBuilder.Entity<SalonRating>(entity =>
        {
            entity.HasKey(e => e.SalonRatingId).HasName("PK__SalonRat__A5496F32DA8AA6FD");

            entity.ToTable("SalonRating");

            entity.Property(e => e.RatingDate).HasColumnType("datetime");

            entity.HasOne(d => d.Salon).WithMany(p => p.SalonRatings)
                .HasForeignKey(d => d.SalonId)
                .HasConstraintName("FK__SalonRati__Salon__5EBF139D");

            entity.HasOne(d => d.User).WithMany(p => p.SalonRatings)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__SalonRati__UserI__5DCAEF64");
        });

        modelBuilder.Entity<Sex>(entity =>
        {
            entity.HasKey(e => e.SexId).HasName("PK__Sex__75622D961C4886BA");

            entity.ToTable("Sex");

            entity.HasIndex(e => e.SexName, "UQ__Sex__BA354290C883E171").IsUnique();

            entity.Property(e => e.SexName).HasMaxLength(255);
        });

        modelBuilder.Entity<TimeSlot>(entity =>
        {
            entity.HasKey(e => e.TimeSlotId).HasName("PK__TimeSlot__41CC1F52BA833311");

            entity.Property(e => e.TimeSlotId).HasColumnName("TimeSlotID");
            entity.Property(e => e.EndTime).HasColumnType("datetime");
            entity.Property(e => e.SlotDate).HasColumnType("datetime");
            entity.Property(e => e.StartTime).HasColumnType("datetime");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.SalonEmployee).WithMany(p => p.TimeSlots)
                .HasForeignKey(d => d.SalonEmployeeId)
                .HasConstraintName("FK__TimeSlots__Emplo__412EB0B6");

            entity.HasOne(d => d.Salon).WithMany(p => p.TimeSlots)
                .HasForeignKey(d => d.SalonId)
                .HasConstraintName("FK__TimeSlots__Servi__403A8C7D");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__1788CC4C7DCBF4CC");

            entity.HasIndex(e => e.Username, "UQ__Users__536C85E4D1C3D823").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__Users__A9D105349F522305").IsUnique();

            entity.Property(e => e.Email).HasMaxLength(255);
            entity.Property(e => e.FirstName).HasMaxLength(255);
            entity.Property(e => e.LastName).HasMaxLength(255);
            entity.Property(e => e.Phone).HasMaxLength(50);
            entity.Property(e => e.Status).HasMaxLength(255);
            entity.Property(e => e.Username).HasMaxLength(255);

            entity.HasOne(d => d.Sex).WithMany(p => p.Users)
                .HasForeignKey(d => d.SexId)
                .HasConstraintName("FK__Users__SexId__2C3393D0");
        });

        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.HasKey(e => e.UserRoleId).HasName("PK__UserRole__3D978A3557925A30");

            entity.Property(e => e.ModificationDate).HasColumnType("datetime");

            entity.HasOne(d => d.Role).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("FK__UserRoles__RoleI__32E0915F");

            entity.HasOne(d => d.User).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__UserRoles__UserI__31EC6D26");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
