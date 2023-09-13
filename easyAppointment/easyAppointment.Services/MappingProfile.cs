using easyAppointment.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Services.InterfaceServices;

namespace easyAppointment.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            //User
            CreateMap<User, UserResponse>();
            CreateMap<UserInsertRequest, User>();
            CreateMap<UserUpdateRequest, User>();

            //Reservations
            CreateMap<Database.Reservation, ReservationsResponse>();
            CreateMap<ReservationInsertRequest, Database.Reservation>();
            CreateMap<ReservationUpdateRequest, Database.Reservation>();

            //TimeSlot
            CreateMap<TimeSlot, TimeslotResponse>();
            CreateMap<TimeSlotInsertRequest, TimeSlot>();
            CreateMap<TimeSlotUpdateRequest, TimeSlot>();

            //UserRole
            CreateMap<UserRole, UserRoleResponse>();

            //Role
            CreateMap<Role, RoleResponse>();

            //Sex
            CreateMap<Sex, SexResponse>();

            //City
            CreateMap<City, CityResponse>();

            //Salon
            CreateMap<Database.Salon, SalonResponse>();
            CreateMap<SalonInsertRequest, Database.Salon>();
            CreateMap<SalonUpdateRequest, Database.Salon>();

            // SalonPhoto
            CreateMap<SalonPhoto, SalonPhotoResponse>();
            CreateMap<SalonPhotoInsertRequest, SalonPhoto>();
            CreateMap<SalonPhotoUpdateRequest, SalonPhoto>();

            // SalonEmployees
            CreateMap<SalonEmployee, SalonEmployeeResponse>();
            CreateMap<SalonEmployeeInsertRequest, SalonEmployee>();
            CreateMap<SalonEmployeeUpdateRequest, SalonEmployee>();

            // SalonRating
            CreateMap<SalonRating, SalonRatingResponse>();
            CreateMap<SalonRatingInsertRequest, SalonRating>();
            CreateMap<SalonRatingUpdateRequest, SalonRating>();
        }
    }
}
