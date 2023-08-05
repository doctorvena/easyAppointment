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
                (search.BusinessUserId == null || x.BusinessUserId.Equals(search.BusinessUserId)) &&
                (search.EmployeeId == null || x.EmployeeId.Equals(search.EmployeeId)) &&
                (search.SalonId == null || x.SalonId.Equals(search.SalonId)) &&
                (search.Status == null || x.Status == search.Status) &&
                (search.SearchDate == null || (x.StartTime.HasValue && x.StartTime.Value.Date == search.SearchDate.Value.Date))
                );
            }

            return query;
        }


        public override async Task<bool> Delete(int id)
        {
            try
            {
                // Perform the delete operation
                var entity = await _context.Set<TimeSlot>().FindAsync(id);
                if (entity == null)
                {
                    return false;
                }

                // Check if the reservation is active
                var isActiveReservation = await _context.Set<Reservation>()
                    .AnyAsync(r => r.TimeSlotId == id);

                if (isActiveReservation)
                {
                    throw new Exception("You can't delete the timeslot if there is an active reservation!");
                }

                _context.Set<TimeSlot>().Remove(entity);
                await _context.SaveChangesAsync();

                return true;
            }
            catch (Exception ex)
            {
                // Handle the error or re-throw the exception
                throw;
            }
        }

        public override async Task BeforeInsert(TimeSlot db, TimeSlotInsertRequest insert)
        {
            // Fetch the SalonEmployeeId that corresponds to the EmployeeId
            var salonEmployee = await _context.SalonEmployees.FirstOrDefaultAsync(e => e.EmployeeUserId == insert.EmployeeId);
            if (salonEmployee == null)
            {
                throw new Exception("Employee does not exist.");
            }

            // Assign SalonEmployeeId to the TimeSlot object
            db.EmployeeId = salonEmployee.SalonEmployeeId;

            // Check if the employee already has a timeslot within the same time span
            bool hasConflictingTimeslot = await _context.Set<TimeSlot>()
                .AnyAsync(t =>
                    t.EmployeeId == insert.EmployeeId &&
                    (
                        (t.StartTime <= insert.StartTime && insert.StartTime < t.EndTime) ||
                        (t.StartTime < insert.EndTime && insert.EndTime <= t.EndTime) ||
                        (insert.StartTime <= t.StartTime && t.StartTime < insert.EndTime) ||
                        (insert.StartTime < t.EndTime && t.EndTime <= insert.EndTime)
                    )
                );

            if (hasConflictingTimeslot)
            {
                throw new Exception("The employee already has a timeslot within the same time span.");
            }
        }



    }
}
