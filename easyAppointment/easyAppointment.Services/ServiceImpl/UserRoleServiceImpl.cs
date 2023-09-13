using AutoMapper;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;

namespace easyAppointment.Services.ServiceImpl
{
    public class UserRoleServiceImpl : ServiceImpl<UserRoleResponse,UserRole,UserRolesSearchObject>, UserRoleService
    {
        public UserRoleServiceImpl(EasyAppointmnetDbContext context, IMapper mapper)
           : base(context, mapper)
        {
        }
    }
}
