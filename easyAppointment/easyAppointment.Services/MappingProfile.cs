using easyAppointment.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;

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
            CreateMap<Reservation, ReservationsResponse>();
            CreateMap<ReservationInsertRequest, Reservation>();
            CreateMap<ReservationUpdateRequest, Reservation>();
            
            //Reviews
            CreateMap<Review, ReviewResponse>();
            
            //TimeSlot
            CreateMap<TimeSlot, TimeslotResponse>();
            CreateMap<TimeSlotInsertRequest, TimeSlot>();
            CreateMap<TimeSlotUpdateRequest, TimeSlot>();

            CreateMap<UserRole, UserRoleResponse>();
            
            CreateMap<Role, RoleResponse>();

        }
    }
}
