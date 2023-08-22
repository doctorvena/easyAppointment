﻿using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.SearchObjects;
using easyAppointment.Contributor.Services;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Contributor.Controllers
{
    public class RoleController : BaseController<RoleResponse, RoleSearchObject>
    {
        public RoleController(ILogger<BaseController<RoleResponse, RoleSearchObject>> _logger, Service<RoleResponse, RoleSearchObject> _service) : base(_logger, _service)
        {
        }
    }
}
