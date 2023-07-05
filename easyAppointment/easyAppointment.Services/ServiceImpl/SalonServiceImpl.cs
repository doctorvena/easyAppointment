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

        public override async Task<SalonResponse> Insert(SalonInsertRequest insert)
        {
            // Check if a salon already exists for the user
            var existingSalon = await _context.Set<Salon>().FirstOrDefaultAsync(s => s.OwnerUserId == insert.OwnerUserId);

            if (existingSalon != null)
            {
                // Throw an exception or handle the error accordingly
                throw new Exception("A salon already exists for this user.");
            }

            return await base.Insert(insert);
        }

        public override IQueryable<Salon> AddFilter(IQueryable<Salon> query, SalonSearchObject? search = null)
        {
            if (search != null)
            {
                query = query.Where(x =>
                    (search.OwnerUserId == null || x.OwnerUserId.Equals(search.OwnerUserId))
                );
            }


            return base.AddFilter(query, search);
        }
    }
}
