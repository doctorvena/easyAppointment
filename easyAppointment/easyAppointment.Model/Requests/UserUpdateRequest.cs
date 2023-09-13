using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class UserUpdateRequest
    {
        public string? FirstName { get; set; } = null!;
        public string? LastName { get; set; } = null!;
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public byte[]? Photo { get; set; }
    }
}
