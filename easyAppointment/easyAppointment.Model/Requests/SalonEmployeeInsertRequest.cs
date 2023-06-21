using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class SalonEmployeeInsertRequest
    {
        public int? SalonId { get; set; }

        public int? EmployeeUserId { get; set; }

        public byte[]? Photo { get; set; }
    }
}
