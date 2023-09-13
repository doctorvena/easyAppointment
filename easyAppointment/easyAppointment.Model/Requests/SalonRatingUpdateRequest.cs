using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class SalonRatingUpdateRequest
    {
        public double Rating { get; set; }

        public DateTime RatingDate { get; set; }

        public int? UserId { get; set; }

    }
}
