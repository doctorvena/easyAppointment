using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public class SalonUpdateRequest
    {
        public string SalonName { get; set; } = null!;
        public string? Address { get; set; }
        public int? EmployeeUserId { get; set; }
        public int? ReservationPrice { get; set; }
        public byte[]? Photo { get; set; }
        public int? CityId { get; set; }
    }
}
