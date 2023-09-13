using easyAppointment.Model.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.InterfaceServices
{
    public interface SalonRecommenderService
    {
        List<SalonResponse> Recommend(int proizvodid);
        Task CreateModel();
    }
}
