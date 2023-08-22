using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Reservation.FeignResponses
{
    public partial class UserResponse
    {
        public int UserId { get; set; }

        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string? Email { get; set; }

        public byte[]? Photo { get; set; }
        public string? Phone { get; set; }

        public string Username { get; set; } = null!;

        public string? Status { get; set; }

    }
}
