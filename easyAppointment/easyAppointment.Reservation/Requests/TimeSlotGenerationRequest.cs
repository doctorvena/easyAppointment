namespace easyAppointment.Reservation.Requests
{
    public class TimeSlotGenerationRequest
    {
        public int EmployeeId { get; set; }
        public DateTime StartingWorkTime { get; set; }
        public DateTime EndingWorkTime { get; set; }
        public TimeSpan TimeSlotDuration { get; set; }

    }
}
