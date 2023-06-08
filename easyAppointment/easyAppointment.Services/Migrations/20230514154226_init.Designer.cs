﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using easyAppointment.Services.Database;

#nullable disable

namespace easyAppointment.Services.Migrations
{
    [DbContext(typeof(EasyAppointmnetDbContext))]
    [Migration("20230514154226_init")]
    partial class init
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.5")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("easyAppointment.Services.Database.Reservation", b =>
                {
                    b.Property<int>("ReservationId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ReservationID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ReservationId"));

                    b.Property<DateTime?>("ReservationDate")
                        .HasColumnType("date");

                    b.Property<string>("ReservationName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("TimeSlotId")
                        .HasColumnType("int")
                        .HasColumnName("TimeSlotID");

                    b.Property<int?>("UserBusinessId")
                        .HasColumnType("int")
                        .HasColumnName("UserBusinessID");

                    b.Property<int?>("UserCustomerId")
                        .HasColumnType("int")
                        .HasColumnName("UserCustomerID");

                    b.HasKey("ReservationId")
                        .HasName("PK__Reservat__B7EE5F04C1A616ED");

                    b.HasIndex("TimeSlotId");

                    b.HasIndex("UserBusinessId");

                    b.HasIndex("UserCustomerId");

                    b.ToTable("Reservations");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.Review", b =>
                {
                    b.Property<int>("ReviewId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ReviewID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ReviewId"));

                    b.Property<string>("Comment")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.Property<int?>("Rating")
                        .HasColumnType("int");

                    b.Property<int?>("ReservationId")
                        .HasColumnType("int")
                        .HasColumnName("ReservationID");

                    b.Property<int?>("UserId")
                        .HasColumnType("int")
                        .HasColumnName("UserID");

                    b.HasKey("ReviewId")
                        .HasName("PK__Reviews__74BC79AE2A36C8A0");

                    b.HasIndex("ReservationId");

                    b.HasIndex("UserId");

                    b.ToTable("Reviews");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.Role", b =>
                {
                    b.Property<int>("RoleId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("RoleId"));

                    b.Property<string>("Description")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("RoleName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("RoleId")
                        .HasName("PK__Roles__8AFACE1A178E0BCC");

                    b.ToTable("Roles");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.TimeSlot", b =>
                {
                    b.Property<int>("TimeSlotId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("TimeSlotID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("TimeSlotId"));

                    b.Property<int?>("BusinessId")
                        .HasColumnType("int");

                    b.Property<TimeSpan>("Duration")
                        .HasColumnType("time");

                    b.Property<TimeSpan?>("EndTime")
                        .HasColumnType("time");

                    b.Property<TimeSpan?>("StartTime")
                        .HasColumnType("time");

                    b.HasKey("TimeSlotId")
                        .HasName("PK__TimeSlot__41CC1F52885FB438");

                    b.HasIndex("BusinessId");

                    b.ToTable("TimeSlots");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.User", b =>
                {
                    b.Property<int>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UserId"));

                    b.Property<string>("Email")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("LastName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PasswordSalt")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Phone")
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool?>("Status")
                        .HasColumnType("bit");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("UserId")
                        .HasName("PK__Users__1788CC4CD38AB606");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.UserRole", b =>
                {
                    b.Property<int>("UserRoleId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UserRoleId"));

                    b.Property<DateTime?>("ModificationDate")
                        .HasColumnType("datetime");

                    b.Property<int?>("RoleId")
                        .HasColumnType("int");

                    b.Property<int?>("UserId")
                        .HasColumnType("int");

                    b.HasKey("UserRoleId")
                        .HasName("PK__UserRole__3D978A3540EDB3D0");

                    b.HasIndex("RoleId");

                    b.HasIndex("UserId");

                    b.ToTable("UserRoles");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.Reservation", b =>
                {
                    b.HasOne("easyAppointment.Services.Database.TimeSlot", "TimeSlot")
                        .WithMany("Reservations")
                        .HasForeignKey("TimeSlotId")
                        .HasConstraintName("FK__Reservati__TimeS__30F848ED");

                    b.HasOne("easyAppointment.Services.Database.User", "UserBusiness")
                        .WithMany("ReservationUserBusinesses")
                        .HasForeignKey("UserBusinessId")
                        .HasConstraintName("FK__Reservati__UserB__2F10007B");

                    b.HasOne("easyAppointment.Services.Database.User", "UserCustomer")
                        .WithMany("ReservationUserCustomers")
                        .HasForeignKey("UserCustomerId")
                        .HasConstraintName("FK__Reservati__UserC__300424B4");

                    b.Navigation("TimeSlot");

                    b.Navigation("UserBusiness");

                    b.Navigation("UserCustomer");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.Review", b =>
                {
                    b.HasOne("easyAppointment.Services.Database.Reservation", "Reservation")
                        .WithMany("Reviews")
                        .HasForeignKey("ReservationId")
                        .HasConstraintName("FK__Reviews__Reserva__34C8D9D1");

                    b.HasOne("easyAppointment.Services.Database.User", "User")
                        .WithMany("Reviews")
                        .HasForeignKey("UserId")
                        .HasConstraintName("FK__Reviews__UserID__33D4B598");

                    b.Navigation("Reservation");

                    b.Navigation("User");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.TimeSlot", b =>
                {
                    b.HasOne("easyAppointment.Services.Database.User", "Business")
                        .WithMany("TimeSlots")
                        .HasForeignKey("BusinessId")
                        .HasConstraintName("FK_TimeSlots_Business");

                    b.Navigation("Business");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.UserRole", b =>
                {
                    b.HasOne("easyAppointment.Services.Database.Role", "Role")
                        .WithMany("UserRoles")
                        .HasForeignKey("RoleId")
                        .HasConstraintName("FK__UserRoles__RoleI__29572725");

                    b.HasOne("easyAppointment.Services.Database.User", "User")
                        .WithMany("UserRoles")
                        .HasForeignKey("UserId")
                        .HasConstraintName("FK__UserRoles__UserI__286302EC");

                    b.Navigation("Role");

                    b.Navigation("User");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.Reservation", b =>
                {
                    b.Navigation("Reviews");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.Role", b =>
                {
                    b.Navigation("UserRoles");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.TimeSlot", b =>
                {
                    b.Navigation("Reservations");
                });

            modelBuilder.Entity("easyAppointment.Services.Database.User", b =>
                {
                    b.Navigation("ReservationUserBusinesses");

                    b.Navigation("ReservationUserCustomers");

                    b.Navigation("Reviews");

                    b.Navigation("TimeSlots");

                    b.Navigation("UserRoles");
                });
#pragma warning restore 612, 618
        }
    }
}
