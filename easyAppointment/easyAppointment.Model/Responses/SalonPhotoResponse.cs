﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Model.Responses
{
    public class SalonPhotoResponse
    {
        public int Id { get; set; }

        public byte[]? Photo { get; set; }

        public int? ServiceId { get; set; }

    }
}
