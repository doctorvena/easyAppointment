using System;
using System.Collections.Generic;
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

    public virtual DbSet<Reservation> Reservations { get; set; }

    public virtual DbSet<Review> Reviews { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<TimeSlot> TimeSlots { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserRole> UserRoles { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost; Database=easyAppointmnetDB; TrustServerCertificate=True; Trusted_Connection=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Reservation>(entity =>
        {
            entity.HasKey(e => e.ReservationId).HasName("PK__Reservat__B7EE5F04C1A616ED");

            entity.Property(e => e.ReservationId).HasColumnName("ReservationID");
            entity.Property(e => e.ReservationDate).HasColumnType("date");
            entity.Property(e => e.TimeSlotId).HasColumnName("TimeSlotID");
            entity.Property(e => e.UserBusinessId).HasColumnName("UserBusinessID");
            entity.Property(e => e.UserCustomerId).HasColumnName("UserCustomerID");

            entity.HasOne(d => d.TimeSlot).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.TimeSlotId)
                .HasConstraintName("FK__Reservati__TimeS__30F848ED");

            entity.HasOne(d => d.UserBusiness).WithMany(p => p.ReservationUserBusinesses)
                .HasForeignKey(d => d.UserBusinessId)
                .HasConstraintName("FK__Reservati__UserB__2F10007B");

            entity.HasOne(d => d.UserCustomer).WithMany(p => p.ReservationUserCustomers)
                .HasForeignKey(d => d.UserCustomerId)
                .HasConstraintName("FK__Reservati__UserC__300424B4");
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.HasKey(e => e.ReviewId).HasName("PK__Reviews__74BC79AE2A36C8A0");

            entity.Property(e => e.ReviewId).HasColumnName("ReviewID");
            entity.Property(e => e.Comment)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.ReservationId).HasColumnName("ReservationID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Reservation).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.ReservationId)
                .HasConstraintName("FK__Reviews__Reserva__34C8D9D1");

            entity.HasOne(d => d.User).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__Reviews__UserID__33D4B598");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Roles__8AFACE1A178E0BCC");
        });

        modelBuilder.Entity<TimeSlot>(entity =>
        {
            entity.HasKey(e => e.TimeSlotId).HasName("PK__TimeSlot__41CC1F52885FB438");

            entity.Property(e => e.TimeSlotId).HasColumnName("TimeSlotID");

            entity.HasOne(d => d.Business).WithMany(p => p.TimeSlots)
                .HasForeignKey(d => d.BusinessId)
                .HasConstraintName("FK_TimeSlots_Business");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__1788CC4CD38AB606");
        });

        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.HasKey(e => e.UserRoleId).HasName("PK__UserRole__3D978A3540EDB3D0");

            entity.Property(e => e.ModificationDate).HasColumnType("datetime");

            entity.HasOne(d => d.Role).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("FK__UserRoles__RoleI__29572725");

            entity.HasOne(d => d.User).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__UserRoles__UserI__286302EC");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
