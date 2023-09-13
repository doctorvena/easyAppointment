using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.SearchObjects
{
    public class SalonSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; }
        public int? OwnerUserId { get; set; }
    }
}
