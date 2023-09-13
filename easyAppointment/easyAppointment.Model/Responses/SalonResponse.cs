using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public class SalonResponse
    {
        public int SalonId { get; set; }
        public string SalonName { get; set; } = null!;
        public string? Address { get; set; }
        public byte[]? Photo { get; set; }
        public int? OwnerUserId { get; set; }
        public int? ReservationPrice { get; set; }
        public int? CityId { get; set; }
        public double? Rating { get; set; }
    }
}
