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
        public int SalonRatingId { get; set; }

        public int? UserId { get; set; }

        public int SalonId { get; set; }

        public int? Rating { get; set; }

        public string? Comment { get; set; }

        public DateTime RatingDate { get; set; }

    }
}
