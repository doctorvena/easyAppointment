using AutoMapper;
using easyAppointment.Contributor.Database;
using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.SearchObjects;

namespace easyAppointment.Contributor.Services
{
    public class RolesServiceImpl : ServiceImpl<RoleResponse, Role, RoleSearchObject>, RoleService
    {
        public RolesServiceImpl(EasyAppointmnetUserDbContext _context, IMapper _mapper) : base( _context, _mapper)
        {
        }
    }
}
