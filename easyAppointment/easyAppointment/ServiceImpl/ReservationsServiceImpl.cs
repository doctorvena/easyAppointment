using AutoMapper;
using easyAppointment.Reservation.SearchObjects;
using easyAppointment.Reservation.Database;
using easyAppointment.Reservation.InterfaceServices;
using easyAppointment.Reservation.Requests;
using easyAppointment.Reservation.Responses;
using Microsoft.EntityFrameworkCore;

namespace easyAppointment.Reservation.ServiceImpl
{
    public class ReservationsServiceImpl : BaseCRUDService<ReservationsResponse, Database.Reservation, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>, ReservationsService
    {
        protected IMapper _mapper { get; set; }
        protected readonly EasyAppointmnetReservationDbContext _context;
        public ReservationsServiceImpl(ILogger<BaseCRUDService<ReservationsResponse, Database.Reservation, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>> _logger, EasyAppointmnetReservationDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
            this._mapper = _mapper;
            this._context = _context;
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


    }
}
