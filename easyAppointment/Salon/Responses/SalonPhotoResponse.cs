using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Salon.Responses
{
    public class SalonPhotoResponse
    {
        public int PhotoId { get; set; }

        public byte[]? Photo { get; set; }

        public int? SalonId { get; set; }

    }
}
