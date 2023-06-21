using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Services.ServiceImpl;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class SalonServiceImpl : BaseCRUDService<SalonResponse, Salon, SalonSearchObject, SalonInsertRequest, SalonUpdateRequest>, SalonService
    {
        public SalonServiceImpl(ILogger<BaseCRUDService<SalonResponse, Salon, SalonSearchObject, SalonInsertRequest, SalonUpdateRequest>> _logger, EasyAppointmnetDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
        }

    }
}
