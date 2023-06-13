using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public class ServiceResponse
    {
        public int ServiceId { get; set; }
        public string ServiceName { get; set; } = null!;

        public string? Description { get; set; }

        public decimal Price { get; set; }

        public int? SalonId { get; set; }

    }
}
