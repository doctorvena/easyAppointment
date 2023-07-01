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
    public class TimeSlotsServiceImpl : BaseCRUDService<TimeslotResponse, TimeSlot, TimeSlotSearchObject, TimeSlotInsertRequest, TimeSlotUpdateRequest>, TimeSlotsService
    {
        public TimeSlotsServiceImpl(ILogger<BaseCRUDService<TimeslotResponse, TimeSlot, TimeSlotSearchObject, TimeSlotInsertRequest, TimeSlotUpdateRequest>> _logger, EasyAppointmnetDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
        }

        public override IQueryable<TimeSlot> AddFilter(IQueryable<TimeSlot> query, TimeSlotSearchObject? search = null)
        {
            if (search != null)
            {
                query = query.Where(x =>
                    (search.BusinessId == null || x.BusinessId.Equals(search.BusinessId)) &&
                    (search.EmployeeId == null || x.EmployeeId.Equals(search.EmployeeId)) &&
                    (search.ServiceId == null || x.ServiceId.Equals(search.ServiceId))
                );
            }


            return query;
        }

    }
}
