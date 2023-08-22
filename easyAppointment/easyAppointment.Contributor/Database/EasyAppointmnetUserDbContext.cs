using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace easyAppointment.Contributor.Database;

public partial class EasyAppointmnetUserDbContext : DbContext
{
    public EasyAppointmnetUserDbContext()
    {
    }

    public EasyAppointmnetUserDbContext(DbContextOptions<EasyAppointmnetUserDbContext> options)
        : base(options)
    {
    }
    public virtual DbSet<Sex> Sex { get; set; }
    public virtual DbSet<Role> Roles { get; set; }
    public virtual DbSet<User> Users { get; set; }
    public virtual DbSet<UserRole> UserRoles { get; set; }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Sex>(entity =>
        {
            entity.HasKey(e => e.SexId).HasName("PK__Sex__75622D961C4886BA");

            entity.ToTable("Sex");

            entity.HasIndex(e => e.SexName, "UQ__Sex__BA354290C883E171").IsUnique();

            entity.Property(e => e.SexName).HasMaxLength(255);
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Roles__8AFACE1A9DFC64B6");

            entity.HasIndex(e => e.RoleName, "UQ__Roles__8A2B61608A1658ED").IsUnique();

            entity.Property(e => e.RoleName).HasMaxLength(255);
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
