using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public class CityResponse
    {
        public int CityId { get; set; }

        public string CityName { get; set; } = null!;

        public string? Country { get; set; }

    }
}
