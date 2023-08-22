using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Requests;
using easyAppointment.Salon.Database;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using AutoMapper;

namespace easyAppointment.Salon.ServiceImpl
{
    public class SalonRatingServiceImpl : BaseCRUDService<SalonRatingResponse, SalonRating, SalonRatingSearcchObject, SalonRatingInsertRequest, SalonRatingUpdateRequest>, SalonRatingService
    {
        public SalonRatingServiceImpl(ILogger<BaseCRUDService<SalonRatingResponse, SalonRating, SalonRatingSearcchObject, SalonRatingInsertRequest, SalonRatingUpdateRequest>> _logger, EasyAppointmnetSalonDbContext _context, IMapper _mapper)
            : base(_logger ,_context, _mapper)
        {

        }
    }
}
