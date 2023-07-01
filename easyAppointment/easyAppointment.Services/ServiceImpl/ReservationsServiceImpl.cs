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
    public class ReservationsServiceImpl : BaseCRUDService<ReservationsResponse, Reservation, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>, ReservationsService
    {
        protected IMapper _mapper { get; set; }
        protected readonly EasyAppointmnetDbContext _context;
        public ReservationsServiceImpl(ILogger<BaseCRUDService<ReservationsResponse, Reservation, ReservationSearchObjecs, ReservationInsertRequest, ReservationUpdateRequest>> _logger, EasyAppointmnetDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
            this._mapper = _mapper;
            this._context = _context;
        }

        public override async Task<List<ReservationsResponse>> Get(ReservationSearchObjecs? search = null)
        {
            var query = _context.Set<Reservation>().AsQueryable();
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
                reservationsResponse.Timeslots = timeSlotResponses.Where(t => t.TimeSlotId == reservationsResponse.TimeSlotId).ToList();
            }

            return reservationsResponseList;
        }

        public override IQueryable<Reservation> AddFilter(IQueryable<Reservation> query, ReservationSearchObjecs? search = null)
        {

            if (search != null)
            {
                query = query.Where(x =>
                    (search.UserBusinessId == null || x.UserBusinessId.Equals(search.UserBusinessId)) &&
                    (search.UserCustomerId == null || x.UserCustomer.Equals(search.UserCustomerId)) &&
                    (search.TimeSlotId == null || x.TimeSlotId.Equals(search.TimeSlotId)) &&
                    (search.ReservationDate == null || x.ReservationDate.Equals(search.ReservationDate))
                );
            }


            return base.AddFilter(query, search);
        }

    }
}
