using AutoMapper;
using easyAppointment.Model;
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
    public class ServiceImpl<T, TDb, TSearch> : Service<T, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        protected IMapper _mapper { get; set; }
        protected readonly EasyAppointmnetDbContext _context;
        public ServiceImpl(EasyAppointmnetDbContext context, IMapper mapper)
        {
            _mapper = mapper;
            _context = context;
        }

        public virtual async Task<List<T>> Get(TSearch? search = null)
        {
            var query = _context.Set<TDb>().AsQueryable();
            query = AddFilter(query, search);
            query = AddInclude(query, search);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
            }

            var list = await query.ToListAsync();
            return _mapper.Map<List<T>>(list);
        }
        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }
        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }
        public virtual async Task<T> GetById(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }

        public virtual async Task<bool> Delete(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            if (entity == null)
                return false;

            _context.Set<TDb>().Remove(entity);
            await _context.SaveChangesAsync();

            return true;
        }
    }
}
