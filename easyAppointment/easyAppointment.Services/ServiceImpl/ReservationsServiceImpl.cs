using AutoMapper;
using easyAppointment.Model;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Linq;

namespace easyAppointment.Services.ServiceImpl
{
    public class ReservationsServiceImpl : BaseCRUDService<ReservationsResponse, Database.Reservation, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>, ReservationsService
    {
        private readonly IRabbitMqService _rabbitMqService;
        protected IMapper _mapper { get; set; }
        protected readonly EasyAppointmnetDbContext _context;
        private readonly ILogger<BaseCRUDService<ReservationsResponse, Database.Reservation, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>> logger;
        public ReservationsServiceImpl(ILogger<BaseCRUDService<ReservationsResponse, Database.Reservation, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>> _logger, EasyAppointmnetDbContext _context, IMapper _mapper, IRabbitMqService rabbitMqService) : base(_logger, _context, _mapper)
        {
            this._mapper = _mapper;
            this._context = _context;
            logger = _logger;
            _rabbitMqService = rabbitMqService;

        }

        public override async Task<List<ReservationsResponse>> Get(ReservationSearchObjecs? search = null)
        {
            var query = _context.Set<Database.Reservation>().AsQueryable();
            query = AddFilter(query, search);
            query = AddInclude(query, search);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
            }

            var list = await query.ToListAsync();

            var reservationsResponseList = _mapper.Map<List<ReservationsResponse>>(list);

            var timeSlotIds = list.Select(r => r.TimeSlotId).Distinct().ToList();

            var timeSlots = await _context.TimeSlots.Where(t => timeSlotIds.Contains(t.TimeSlotId)).ToListAsync();

            var timeSlotResponses = _mapper.Map<List<TimeslotResponse>>(timeSlots);

            foreach (var reservationsResponse in reservationsResponseList)
            {
                reservationsResponse.TimeSlots = timeSlotResponses.Where(t => t.TimeSlotId == reservationsResponse.TimeSlotId).ToList();
            }

            return reservationsResponseList;
        }

        public override IQueryable<Database.Reservation> AddFilter(IQueryable<Database.Reservation> query, ReservationSearchObjecs? search = null)
        {
            if (search != null)
            {
                query = query.Where(x =>
                    (search.SalonId == null || x.SalonId.Equals(search.SalonId)) &&
                    (search.UserCustomerId == null || x.UserCustomerId.Equals(search.UserCustomerId)) &&
                    (search.TimeSlotId == null || x.TimeSlotId.Equals(search.TimeSlotId)) &&
                    (search.ReservationDate == null || x.ReservationDate.Equals(search.ReservationDate))
                );

                if (search.IsActive.HasValue)
                {
                    if (search.IsActive.Value)
                    {
                        query = query.Where(x => x.Status.Equals("Active"));
                    }
                    else
                    {
                        query = query.Where(x => x.Status.Equals("Canceled") || x.Status.Equals("Completed"));
                    }
                }
            }

            return base.AddFilter(query, search);
        }

        public override async Task BeforeInsert(Database.Reservation db, ReservationInsertRequest insert)
        {
            var overlappingReservations = await _context.Set<Database.Reservation>()
                .AnyAsync(r => r.UserCustomerId == insert.UserCustomerId && r.TimeSlotId == insert.TimeSlotId);

            if (overlappingReservations)
            {
                throw new UserException("You already have a reservation for this time slot.");
            }

            var salon = await _context.Set<Database.TimeSlot>()
                 .Where(t => t.TimeSlotId == insert.TimeSlotId)
                 .Include(t => t.Salon)
                 .ThenInclude(s => s.OwnerUser)
                 .Select(t => t.Salon)
                 .FirstOrDefaultAsync();

            var timeSlot = await _context.Set<Database.TimeSlot>().FindAsync(insert.TimeSlotId);


            if (salon != null && salon.OwnerUser != null)
            {
                var ownerEmail = salon.OwnerUser.Email;

                try
                {
                    _rabbitMqService.PublishReservationNotification2($"Nova rezervacija u {timeSlot.StartTime}.", ownerEmail);

                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Failed to publish reservation notification.");
                }
            }

            await base.BeforeInsert(db, insert);
            return;
        }
        public async Task<List<ReservationsResponse>> GetReservationsForEmployeeUserId(int employeeUserId)
        {
            var salonEmployeeId = await _context.SalonEmployees
                                                .Where(se => se.EmployeeUserId == employeeUserId)
                                                .Select(se => se.SalonEmployeeId)
                                                .FirstOrDefaultAsync();

            if (salonEmployeeId == 0)
            {
                return new List<ReservationsResponse>();
            }

            var reservations = await (from r in _context.Reservations
                                      join t in _context.TimeSlots on r.TimeSlotId equals t.TimeSlotId
                                      where t.SalonEmployeeId == salonEmployeeId
                                      select r).Distinct().ToListAsync();


            return _mapper.Map<List<ReservationsResponse>>(reservations);
        }



        public override async Task<bool> Delete(int id)
        {
            var entity = await _context.Set<Database.Reservation>().FindAsync(id);

            if (entity == null)
                return false;

            if (entity.TimeSlotId.HasValue)
            {
                var timeSlot = await _context.TimeSlots.FindAsync(entity.TimeSlotId.Value);
                if (timeSlot != null)
                {
                    timeSlot.Status = "Available";
                    _context.TimeSlots.Update(timeSlot);
                }
            }

            _context.Set<Database.Reservation>().Remove(entity);
            await _context.SaveChangesAsync();

            return true;
        }

    }
}
