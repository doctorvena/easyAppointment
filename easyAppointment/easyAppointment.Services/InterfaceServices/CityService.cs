using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.InterfaceServices
{
    public interface CityService : Service<CityResponse, BaseSearchObject>
    {
    }
}
