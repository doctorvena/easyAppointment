using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Reservation.Requests
{
    public class ServiceInsertRequest
    {

        public string ServiceName { get; set; } = null!;

        public string? Description { get; set; }

        public int? BusinessId { get; set; }

        public decimal Price { get; set; }

        public int? SalonId { get; set; }


    }
}
