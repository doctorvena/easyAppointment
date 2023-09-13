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

        public override IQueryable<SalonEmployee> AddInclude(IQueryable<SalonEmployee> query, SalonEmployeeSearchObject? search = null)
        {
            if(search != null && search.AreUsersIncluded==true)
            {
                query = query.Include(x => x.EmployeeUser);

            }

            return base.AddInclude(query, search);
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

        public override async Task BeforeInsert(SalonEmployee db, SalonEmployeeInsertRequest insert)
        {
            var existingEmployee = await _context.Set<SalonEmployee>()
                .FirstOrDefaultAsync(x => x.EmployeeUserId == insert.EmployeeUserId);

            if (existingEmployee != null)
            {
                throw new Exception("Employee is already associated with a salon");
            }

            await base.BeforeInsert(db, insert);
        }

        public virtual async Task<SalonEmployeeResponse> AddSalonEmployee(string username, int salonId)
        {
            var user = await _context.Set<User>().FirstOrDefaultAsync(u => u.Username == username);
            if (user == null)
            {
                throw new Exception("User not found");
            }

            var existingEmployee = await _context.Set<SalonEmployee>().FirstOrDefaultAsync(e => e.EmployeeUserId == user.UserId);
            if (existingEmployee != null)
            {
                throw new Exception("Employee is already employed");
            }

            var salonEmployee = new SalonEmployee
            {
                SalonId = salonId,
                EmployeeUserId = user.UserId,
                Photo = user.Photo
            };

            await BeforeInsert(salonEmployee, new SalonEmployeeInsertRequest
            {
                SalonId = salonEmployee.SalonId,
                EmployeeUserId = salonEmployee.EmployeeUserId,
                Photo = salonEmployee.Photo
            });

            _context.Set<SalonEmployee>().Add(salonEmployee);
            await _context.SaveChangesAsync();

            var response = _mapper.Map<SalonEmployeeResponse>(salonEmployee);

            response.FirstName = user.FirstName;
            response.LastName = user.LastName;
            response.Username = user.Username;
            response.Phone = user.Phone;
            response.Email = user.Email;

            return response;
        }


    }
}
