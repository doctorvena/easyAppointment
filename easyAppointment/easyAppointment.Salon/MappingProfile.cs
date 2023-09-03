using easyAppointment.Salon.Database;
using AutoMapper;
using easyAppointment.Salon.Requests;
using easyAppointment.Salon.Responses;

namespace easyAppointment.Salon.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

            //City
            CreateMap<City, CityResponse>();
            CreateMap<CityResponse, City>();

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
            CreateMap<Database.SalonRating, SalonRatingResponse>();
            CreateMap<SalonRatingInsertRequest, Database.SalonRating>();
            CreateMap<SalonRatingUpdateRequest, Database.SalonRating>();
        }
    }
}
