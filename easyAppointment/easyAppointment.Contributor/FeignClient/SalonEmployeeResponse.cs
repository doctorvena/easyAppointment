using easyAppointment.Contributor.FeignResponses;
using easyAppointment.Contributor.Models;

namespace easyAppointment.Contributor.FeignResponses
{
    public class SalonEmployeeResponse
    {
        public int SalonEmployeeId { get; set; }
        public int? SalonId { get; set; }
        public int EmployeeUserId { get; set; }
        public UserResponse User { get; set; }
        public byte[]? Photo { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Username { get; set; }
        public string? Phone { get; set; }
        public string? Email { get; set; }
    }
}
