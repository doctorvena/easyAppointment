using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public partial class SalonRatingResponse
    {
        public int ReviewId { get; set; }

        public int? UserId { get; set; }

        public int? ReservationId { get; set; }

        public int? Rating { get; set; }

        public string? Comment { get; set; }

    }
}
