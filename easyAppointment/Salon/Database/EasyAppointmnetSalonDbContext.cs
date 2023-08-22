using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace easyAppointment.Salon.Database;

public partial class EasyAppointmnetSalonDbContext : DbContext
{
    public EasyAppointmnetSalonDbContext()
    {
    }

    public EasyAppointmnetSalonDbContext(DbContextOptions<EasyAppointmnetSalonDbContext> options)
        : base(options)
    {
    }
    public virtual DbSet<Salon> Salons { get; set; }
    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<SalonEmployee> SalonEmployees { get; set; }

    public virtual DbSet<SalonPhoto> SalonPhotos { get; set; }

    public virtual DbSet<SalonRating> SalonRatings { get; set; }


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

        modelBuilder.Entity<Salon>(entity =>
        {
            entity.HasKey(e => e.SalonId).HasName("PK__Salon__5E25586114FE893D");

            entity.ToTable("Salon");

            entity.Property(e => e.SalonName).HasMaxLength(255);

        });

        modelBuilder.Entity<SalonEmployee>(entity =>
        {
            entity.HasKey(e => e.SalonEmployeeId).HasName("PK__SalonEmp__D71B354531CAE998");



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

        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
