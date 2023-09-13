using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public class SalonEmployeeResponse
    {
        public int SalonEmployeeId { get; set; }
        public int? SalonId { get; set; }
        public int? EmployeeUserId { get; set; }
        public UserResponse? User { get; set; }
        public byte[]? Photo { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Username { get; set; }
        public string? Phone { get; set; }
        public string? Email { get; set; }
    }
}
