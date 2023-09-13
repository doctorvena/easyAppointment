using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.SearchObjects
{
    public class SalonRatingSearcchObject : BaseSearchObject
    {
        public string? comment { get; set; }
        public string? FTS { get; set; }
    }
}
