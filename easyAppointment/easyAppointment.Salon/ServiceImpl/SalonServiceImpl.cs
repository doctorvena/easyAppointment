using easyAppointment.Salon.Database;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using easyAppointment.Salon.InterfaceServices;

namespace easyAppointment.Salon.ServiceImpl
{
    public class SalonServiceImpl : BaseCRUDService<SalonResponse, Database.Salon, SalonSearchObject, SalonInsertRequest, SalonUpdateRequest>, SalonService
    {
        public SalonServiceImpl(ILogger<BaseCRUDService<SalonResponse, Database.Salon, SalonSearchObject, SalonInsertRequest, SalonUpdateRequest>> _logger, EasyAppointmnetSalonDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
        }

        public override async Task<SalonResponse> Insert(SalonInsertRequest insert)
        {
            // Check if a salon already exists for the user
            var existingSalon = await _context.Set<Database.Salon>().FirstOrDefaultAsync(s => s.OwnerUserId == insert.OwnerUserId);

            if (existingSalon != null)
            {
                // Throw an exception or handle the error accordingly
                throw new Exception("A salon already exists for this user.");
            }

            return await base.Insert(insert);
        }

        public override IQueryable<Database.Salon> AddFilter(IQueryable<Database.Salon> query, SalonSearchObject? search = null)
        {
            if (search != null)
            {
                query = query.Where(x =>
                    (search.OwnerUserId == null || x.OwnerUserId.Equals(search.OwnerUserId))
                );
            }


            return base.AddFilter(query, search);
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


    }
}
