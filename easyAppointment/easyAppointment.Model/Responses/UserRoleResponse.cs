using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public partial class UserRoleResponse
    {
        public int UserRolesId { get; set; }

        public int? UserId { get; set; }

        public int? RoleId { get; set; }

        public DateTime? Date { get; set; }

        public virtual RoleResponse? Role { get; set; }

    }
}
