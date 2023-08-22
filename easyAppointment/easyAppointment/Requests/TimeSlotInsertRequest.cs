namespace easyAppointment.Reservation.Requests
{
    public class TimeSlotInsertRequest
    {
        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }
        public int? EmployeeId { get; set; }
        public int Duration { get; set; }
        public string? Status { get; set; }
        public int SalonId { get; set; }    
        public int? OwnerUserId { get; set; }
        public DateTime? SlotDate { get; set; }

    }
}
