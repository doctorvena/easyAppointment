using AutoMapper;
using easyAppointment.Model.Responses;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class ReportServiceImpl : ReportService
    {
        private readonly EasyAppointmnetDbContext _context;
        protected IMapper _mapper { get; set; }
        public ReportServiceImpl(EasyAppointmnetDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<ReservationsResponse>> GetCancellationReport(int? salonId = null)
        {
            var query = _context.Reservations.AsQueryable();

            // Filtriranje po salonu, ako je potrebno
            if (salonId.HasValue)
            {
                query = query.Where(x => x.SalonId == salonId);
            }

            // Filtriranje po otkazanim rezervacijama
            query = query.Where(x => x.Status.Equals("Canceled"));

            // Učitavanje potrebnih podataka
            var reservations = await query.Include(x => x.UserCustomer).ToListAsync();

            // Mapiranje na ReservationsResponse
            var result = _mapper.Map<List<ReservationsResponse>>(reservations);

            return result;
        }
    }
  }
