using AutoMapper;
using easyAppointment.Reservation.Database;
using easyAppointment.Reservation.FeignClient;
using easyAppointment.Reservation.FeignResponses;
using easyAppointment.Reservation.InterfaceServices;
using easyAppointment.Reservation.Requests;
using easyAppointment.Reservation.Responses;
using easyAppointment.Reservation.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace easyAppointment.Reservation.ServiceImpl
{
    public class TimeSlotsServiceImpl : BaseCRUDService<TimeslotResponse, TimeSlot, TimeSlotSearchObject, TimeSlotInsertRequest, TimeSlotUpdateRequest>, TimeSlotsService
    {
        private readonly UserFeignClient _userFeignClient;
        private readonly SalonFeignClient _SalonFeignClient;
        public TimeSlotsServiceImpl(ILogger<BaseCRUDService<TimeslotResponse, TimeSlot, TimeSlotSearchObject, TimeSlotInsertRequest, TimeSlotUpdateRequest>> _logger, EasyAppointmnetReservationDbContext _context, IMapper _mapper, UserFeignClient userFeignClient, SalonFeignClient SalonFeignClient) : base(_logger, _context, _mapper)
        {
            _userFeignClient = userFeignClient;
            _SalonFeignClient = SalonFeignClient;
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
                // Perform the delete operation
                var entity = await _context.Set<TimeSlot>().FindAsync(id);
                if (entity == null)
                {
                    return false;
                }

                // Check if the reservation is active
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
                // Handle the error or re-throw the exception
                throw;
            }
        }

        public override async Task BeforeInsert(TimeSlot db, TimeSlotInsertRequest insert)
        {
            // Fetch the SalonEmployeeId that corresponds to the EmployeeId
            var salonEmployee = await _SalonFeignClient.GetById(insert.EmployeeId);
            if (salonEmployee == null)
            {
                throw new Exception("Employee does not exist.");
            }

            // Assign SalonEmployeeId to the TimeSlot object
            db.SalonEmployeeId = salonEmployee.SalonEmployeeId;

            // Check if the employee already has a timeslot within the same time span
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
            query = AddFilter(query, search); // if you have a filtering method
            query = AddInclude(query, search);
            var timeSlots = await query.ToListAsync();

            // Integrate the user data with the time slots here
            var results = new List<TimeslotResponse>();
            foreach (var slot in timeSlots)
            {
                var salonEmployeeResponse = new SalonEmployeeResponse();

                var salonEmployee = await _SalonFeignClient.GetById(slot.SalonEmployeeId);
                if (salonEmployee != null)
                {
                    var user = await _userFeignClient.GetById(salonEmployee.EmployeeUserId);
                    if (user != null)
                    {
                        salonEmployeeResponse = new SalonEmployeeResponse
                        {
                            SalonEmployeeId = salonEmployee.SalonEmployeeId,
                            SalonId = salonEmployee.SalonId,
                            EmployeeUserId = salonEmployee.EmployeeUserId,
                            User = user,
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

            //return results;

            return _mapper.Map<List<TimeslotResponse>>(results);

        }

        public async Task<List<TimeslotResponse>> GenerateTimeSlotsForEmployee(TimeSlotGenerationRequest request)
        {
            // Validate input
            if (request.EndingWorkTime <= request.StartingWorkTime)
                throw new ArgumentException("Ending work time should be greater than starting work time.");

            if (request.TimeSlotDuration <= TimeSpan.Zero)
                throw new ArgumentException("Duration of timeslot should be positive.");

            var timeSlots = new List<TimeSlot>();

            // Fetch the SalonEmployeeId that corresponds to the EmployeeId
            var salonEmployee = await _SalonFeignClient.GetById(request.EmployeeId);
            if (salonEmployee == null)
            {
                throw new Exception("Employee does not exist.");
            }

            var existingTimeSlots = await _context.Set<TimeSlot>().Where(t => t.SalonEmployeeId == salonEmployee.SalonEmployeeId).ToListAsync();
            if (existingTimeSlots.Any())
            {
                throw new Exception("Employee already has timeslots. Can't generate full shift.");
            }

            DateTime currentTimeSlotStart = request.StartingWorkTime;
            DateTime currentTimeSlotEnd = currentTimeSlotStart + request.TimeSlotDuration;

            while (currentTimeSlotEnd <= request.EndingWorkTime)
            {
                var timeSlot = new TimeSlot
                {
                    SalonEmployeeId = salonEmployee.SalonEmployeeId,
                    StartTime = currentTimeSlotStart,
                    EndTime = currentTimeSlotEnd
                    // Add other required properties here
                };

                timeSlots.Add(timeSlot);

                // Move to the next time slot
                currentTimeSlotStart = currentTimeSlotEnd;
                currentTimeSlotEnd = currentTimeSlotStart + request.TimeSlotDuration;
            }

            // Now you can save these to the database or just return them depending on your requirements.
            _context.Set<TimeSlot>().AddRange(timeSlots);
            await _context.SaveChangesAsync();

            return _mapper.Map<List<TimeslotResponse>>(timeSlots);
        }


    }
}
