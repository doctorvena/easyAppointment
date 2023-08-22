using AutoMapper;
using easyAppointment.Reservation.Requests;
using easyAppointment.Reservation.Database;
using easyAppointment.Reservation.Responses;

namespace easyAppointment.Reservation
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            //Reservations
            CreateMap<Database.Reservation, ReservationsResponse>();
            CreateMap<ReservationInsertRequest, Database.Reservation>();
            CreateMap<ReservationUpdateRequest, Database.Reservation>();

            //TimeSlot
            CreateMap<TimeSlot, TimeslotResponse>();
            CreateMap<TimeSlotInsertRequest, TimeSlot>();
            CreateMap<TimeSlotUpdateRequest, TimeSlot>();
        }
    }
}
