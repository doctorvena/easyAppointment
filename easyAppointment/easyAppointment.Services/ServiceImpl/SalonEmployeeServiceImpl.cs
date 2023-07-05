using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class SalonEmployeeServiceImpl : BaseCRUDService< SalonEmployeeResponse,  SalonEmployee,  SalonEmployeeSearchObject,  SalonEmployeeInsertRequest,  SalonEmployeeUpdateRequest>,  SalonEmployeeService
    {
        public  SalonEmployeeServiceImpl(ILogger<BaseCRUDService< SalonEmployeeResponse,  SalonEmployee,  SalonEmployeeSearchObject,  SalonEmployeeInsertRequest,  SalonEmployeeUpdateRequest>> _logger, EasyAppointmnetDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
        }

        public override IQueryable<SalonEmployee> AddFilter(IQueryable<SalonEmployee> query, SalonEmployeeSearchObject? search = null)
        {

            if (search != null)
            {
                query = query.Where(x =>
                    (search.SalonId == null || x.SalonId.Equals(search.SalonId)) &&
                    (search.EmployeeUserId == null || x.SalonId.Equals(search.EmployeeUserId)) &&
                    (search.SalonEmployeeId == null || x.SalonId.Equals(search.SalonEmployeeId))
                );
            }

            return base.AddFilter(query, search);
        }

        public override async Task<List<SalonEmployeeResponse>> Get(SalonEmployeeSearchObject? search = null)
        {
            var query = _context.Set<SalonEmployee>().AsQueryable();
            query = AddFilter(query, search);
            query = AddInclude(query, search);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
            }

            var list = await query.ToListAsync();

            var responseList = _mapper.Map<List<SalonEmployeeResponse>>(list);

            // Include additional properties from the user table
            foreach (var response in responseList)
            {
                var user = await _context.Set<User>().FirstOrDefaultAsync(u => u.UserId == response.EmployeeUserId);
                if (user != null)
                {
                    response.FirstName = user.FirstName;
                    response.LastName = user.LastName;
                    response.Username = user.Username;
                    response.Phone = user.Phone;
                    response.Email = user.Email;
                }
            }

            return responseList;
        }
    }
}
