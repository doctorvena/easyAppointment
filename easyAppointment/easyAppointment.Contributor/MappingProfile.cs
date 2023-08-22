using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using easyAppointment.Contributor.Database;
using easyAppointment.Contributor.Models;

namespace easyAppointment.Contributor
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            //User
            CreateMap<Database.User, UserResponse>();
            CreateMap<UserInsertRequest, Database.User>();
            CreateMap<UserUpdateRequest, Database.User>();

            
            //UserRole
            CreateMap<UserRole, UserRoleResponse>();

            //Role
            CreateMap<Role, RoleResponse>();

            //Sex
            CreateMap<Sex, SexResponse>();
        }
    }
}
