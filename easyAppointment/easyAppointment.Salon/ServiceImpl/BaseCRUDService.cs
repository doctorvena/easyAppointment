using AutoMapper;
using easyAppointment.Salon.Database;
using easyAppointment.Salon.SearchObjects;

namespace easyAppointment.Salon.ServiceImpl
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate> : ServiceImpl<T, TDb, TSearch> where T : class where TDb : class where TSearch : BaseSearchObject
    {

        public BaseCRUDService(ILogger<BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate>> logger, EasyAppointmnetSalonDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(TDb db, TInsert insert)
        {

        }

        public virtual async Task BeforeUpdate(TDb db, TUpdate update)
        {

        }

        public virtual async Task<T> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T> Update(int id, TUpdate update)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            if (entity == null)
            {
                //throw new UserException("Entity with id: " + id + " not found");
                throw new Exception();
            }

            _mapper.Map(update, entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<T>(entity);
        }
    }
}
