using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.SearchObjects
{
    public class SalonEmployeeSearchObject : BaseSearchObject
    {
        public bool? AreUsersIncluded { get; set; }

        public int? SalonEmployeeId { get; set; }

        public int? SalonId { get; set; }

        public int? EmployeeUserId { get; set; }
    }
}
