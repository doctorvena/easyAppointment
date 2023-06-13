using AutoMapper;
using easyAppointment.Model;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class CityServiceImpl : ServiceImpl<CityResponse, City, BaseSearchObject>, CityService
    {
        public CityServiceImpl(EasyAppointmnetDbContext _context, IMapper _mapper) : base(_context, _mapper)
        {
        }
    }
}
