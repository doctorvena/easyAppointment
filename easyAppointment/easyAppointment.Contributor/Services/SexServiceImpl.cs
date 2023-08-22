using AutoMapper;
using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.Database;
using easyAppointment.Contributor.SearchObjects;

namespace easyAppointment.Contributor.Services
{
    public class SexServiceImpl : ServiceImpl<SexResponse, Sex, SexSearchObject>, SexService
    {
        public SexServiceImpl(EasyAppointmnetUserDbContext _context, IMapper _mapper) : base( _context, _mapper)
        {
        }
    }
}
