using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Requests
{
    public class UserInsertRequest
    {
        [Required(AllowEmptyStrings =false)]
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public int RoleId { get; set; }
        public string? Status { get; set; }
        public int? SexId { get; set; }
        public byte[]? Photo { get; set; }
        public string? Email { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string? Phone { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string Username { get; set; } = null!;
        [Required(AllowEmptyStrings = false)]
        [Compare("PasswordRepeat", ErrorMessage = "Passwords do not match.")]
        public string Password { get; set; }
        [Compare("Password",ErrorMessage ="Passwords do not match.")]
        public string PasswordRepeat { get; set; }
    }
}
