using easyAppointment.Salon.Database;
using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using AutoMapper;

namespace easyAppointment.Salon.ServiceImpl
{
    public class SalonPhotoServiceImpl : BaseCRUDService<SalonPhotoResponse, SalonPhoto, SalonPhotoSearchObject, SalonPhotoInsertRequest, SalonPhotoUpdateRequest>, SalonPhotoService
    {
        public SalonPhotoServiceImpl(ILogger<BaseCRUDService<SalonPhotoResponse, SalonPhoto, SalonPhotoSearchObject, SalonPhotoInsertRequest, SalonPhotoUpdateRequest>> _logger, EasyAppointmnetSalonDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
        }
        public override IQueryable<SalonPhoto> AddFilter(IQueryable<SalonPhoto> query, SalonPhotoSearchObject? search = null)
        {
            if (search != null)
            {
                query = query.Where(x =>
                    (search.SalonId == null || x.SalonId.Equals(search.SalonId))
                );
            }
            return base.AddFilter(query, search);
        }
    }
}
