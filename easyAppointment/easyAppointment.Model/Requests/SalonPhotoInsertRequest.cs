using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public class SalonPhotoInsertRequest 
    {

        public byte[]? Photo { get; set; }

        public int? SalonId { get; set; }

    }
}
