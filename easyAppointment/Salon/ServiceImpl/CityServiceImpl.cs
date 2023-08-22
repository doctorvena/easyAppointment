using AutoMapper;
using easyAppointment.Salon.Database;
using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;

namespace easyAppointment.Salon.ServiceImpl
{
    public class CityServiceImpl : ServiceImpl<CityResponse, City, BaseSearchObject>, CityService
    {
        public CityServiceImpl(EasyAppointmnetSalonDbContext _context, IMapper _mapper) : base(_context, _mapper)
        {
        }
    }
}
