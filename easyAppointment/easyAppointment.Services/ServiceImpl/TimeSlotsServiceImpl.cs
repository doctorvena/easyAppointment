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
                (search.OwnerUserId == null || x.OwnerUserId.Equals(search.OwnerUserId)) &&
                (search.EmployeeId == null || x.SalonEmployeeId.Equals(search.EmployeeId)) &&
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
                var entity = await _context.Set<TimeSlot>().FindAsync(id);
                if (entity == null)
                {
                    return false;
                }
                var isActiveReservation = await _context.Set<Database.Reservation>()
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
                throw;
            }
        }

        public override async Task BeforeInsert(TimeSlot db, TimeSlotInsertRequest insert)
        {
            var salonEmployee = await _context.SalonEmployees.FindAsync(insert.EmployeeId);
            if (salonEmployee == null)
            {
                throw new Exception("Employee does not exist.");
            }

            db.SalonEmployeeId = salonEmployee.SalonEmployeeId;

            bool hasConflictingTimeslot = await _context.Set<TimeSlot>()
                .AnyAsync(t =>
                    t.SalonEmployeeId == salonEmployee.SalonEmployeeId &&
                    t.SlotDate == insert.SlotDate &&
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

        public override async Task<List<TimeslotResponse>> Get(TimeSlotSearchObject? search = null)
        {
            var query = _context.Set<TimeSlot>().AsQueryable();
            query = AddFilter(query, search); 
            query = AddInclude(query, search);
            var timeSlots = await query.ToListAsync();

            var results = new List<TimeslotResponse>();
            foreach (var slot in timeSlots)
            {
                var salonEmployeeResponse = new SalonEmployeeResponse();

                var salonEmployee = await _context.SalonEmployees.FindAsync(slot.SalonEmployeeId);
                if (salonEmployee != null)
                {
                    var user = await _context.Users.FindAsync(salonEmployee.EmployeeUserId);
                    if (user != null)
                    {
                        UserResponse userResponse = new UserResponse
                        {
                            UserId = user.UserId,
                            FirstName = user.FirstName,
                            LastName = user.LastName,
                            Email = user.Email,
                            Photo = user.Photo,
                            Phone = user.Phone,
                            Username = user.Username,
                            Status = user.Status
                        };

                        salonEmployeeResponse = new SalonEmployeeResponse
                        {
                            SalonEmployeeId = salonEmployee.SalonEmployeeId,
                            SalonId = salonEmployee.SalonId,
                            EmployeeUserId = salonEmployee.EmployeeUserId,
                            User = userResponse,
                            Photo = salonEmployee.Photo,
                                                 FirstName = user.FirstName,
                            LastName = user.LastName,
                            Username = user.Username,
                            Phone = user.Phone,
                            Email = user.Email
                        };
                    }

                    results.Add(new TimeslotResponse
                    {
                        TimeSlotId = slot.TimeSlotId,
                        Status = slot.Status,
                        StartTime = slot.StartTime,
                        EndTime = slot.EndTime,
                        SalonEmployeeId = slot.SalonEmployeeId,
                        SlotDate = slot.SlotDate,
                        Duration = slot.Duration,
                        BusinessId = slot.SalonId,
                        Employee = salonEmployeeResponse
                    });
                }
            }
            return _mapper.Map<List<TimeslotResponse>>(results);
        }
    }
}