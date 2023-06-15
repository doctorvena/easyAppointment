using easyAppointment.Model.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.InterfaceServices
{
    public interface ServiceRecommenderService
    {
        List<ServiceResponse> Recommend(int proizvodid);

    }
}
