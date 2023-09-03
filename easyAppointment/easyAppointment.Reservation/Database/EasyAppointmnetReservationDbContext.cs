using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace easyAppointment.Reservation.Database;

public partial class EasyAppointmnetReservationDbContext : DbContext
{
    public EasyAppointmnetReservationDbContext()
    {
    }

    public EasyAppointmnetReservationDbContext(DbContextOptions<EasyAppointmnetReservationDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Reservation> Reservations { get; set; }

    public virtual DbSet<TimeSlot> TimeSlots { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
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

            entity.HasOne(d => d.TimeSlot).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.TimeSlotId)
                .HasConstraintName("FK__Reservati__TimeS__6E01572D");
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
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
