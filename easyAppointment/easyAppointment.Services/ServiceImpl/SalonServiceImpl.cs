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
    public class SalonServiceImpl : BaseCRUDService<SalonResponse, Database.Salon, SalonSearchObject, SalonInsertRequest, SalonUpdateRequest>, SalonService
    {
        public SalonServiceImpl(ILogger<BaseCRUDService<SalonResponse, Database.Salon, SalonSearchObject, SalonInsertRequest, SalonUpdateRequest>> _logger, EasyAppointmnetDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
        }

        public override async Task<SalonResponse> Insert(SalonInsertRequest insert)
        {
            var existingSalon = await _context.Set<Database.Salon>().FirstOrDefaultAsync(s => s.OwnerUserId == insert.OwnerUserId);

            if (existingSalon != null)
            {
                throw new Exception("A salon already exists for this user.");
            }

            return await base.Insert(insert);
        }

        public override IQueryable<Database.Salon> AddFilter(IQueryable<Database.Salon> query, SalonSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search != null)
            {
                if (!string.IsNullOrWhiteSpace(search.FTS))
                {
                    filteredQuery = filteredQuery.Where(x => x.SalonName.Contains(search.FTS));
                }

                filteredQuery = filteredQuery.Where(x =>
                    (search.OwnerUserId == null || x.OwnerUserId.Equals(search.OwnerUserId))
                );
            }

            return base.AddFilter(filteredQuery, search);
        }
        public async Task<SalonResponse> GetSalonByEmployeeId(int employeeId)
        {
            var salonEmployee = await _context.Set<SalonEmployee>()
                .Include(se => se.Salon)
                .FirstOrDefaultAsync(e => e.EmployeeUserId == employeeId);


            if (salonEmployee == null)
            {
                return null;
            }

            var salon = salonEmployee.Salon;
            return _mapper.Map<SalonResponse>(salon);
        }
        public async Task<int?> GetLastRatedSalonByUserId(int userId)
        {
            var lastRating = await _context.Set<SalonRating>()
                .Where(r => r.UserId == userId)
                .OrderByDescending(r => r.RatingDate)
                .FirstOrDefaultAsync();

            return lastRating?.SalonId; // This will return either the SalonId or null
        }
    }
}
