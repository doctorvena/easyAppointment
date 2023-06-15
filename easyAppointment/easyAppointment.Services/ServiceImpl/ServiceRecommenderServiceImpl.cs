using AutoMapper;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class ServiceRecommenderServiceImpl : ServiceRecommenderService
    {
        private readonly EasyAppointmnetDbContext _context;
        private readonly IMapper _mapper;
        Dictionary<int, List<ServiceRating>> services = new Dictionary<int, List<ServiceRating>>();

        public ServiceRecommenderServiceImpl(EasyAppointmnetDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        private List<Service> LoadSimilar(int serviceId)
        {
            LoadOtherServices(serviceId);
            List<ServiceRating> ratingOfCurrent = _context.ServiceRatings.Where(x => x.ServiceId == serviceId).OrderBy(x => x.UserId).ToList();

            List<ServiceRating> ratings1 = new List<ServiceRating>();
            List<ServiceRating> ratings2 = new List<ServiceRating>();
            List<Service> recommendedServices = new List<Service>();

            foreach (var service in services)
            {
                foreach (ServiceRating rating in ratingOfCurrent)
                {
                    if (service.Value.Where(w => w.UserId == rating.UserId).Count() > 0)
                    {
                        ratings1.Add(rating);
                        ratings2.Add(service.Value.Where(w => w.UserId == rating.UserId).First());
                    }
                }
                double similarity = GetSimilarity(ratings1, ratings2);
                if (similarity > 0.5)
                {
                    recommendedServices.Add(_context.Services.AsQueryable().Where(w => w.ServiceId == service.Key).FirstOrDefault());
                }
                ratings1.Clear();
                ratings2.Clear();
            }
            return recommendedServices;
        }

        private double GetSimilarity(List<ServiceRating> ratings1, List<ServiceRating> ratings2)
        {
            if (ratings1.Count != ratings2.Count)
            {
                return 0;
            }
            double x = 0, y1 = 0, y2 = 0;

            for (int i = 0; i < ratings1.Count; i++)
            {
                x += ratings1[i].Rating * ratings2[i].Rating;
                y1 += ratings1[i].Rating * ratings1[i].Rating;
                y2 += ratings2[i].Rating * ratings2[i].Rating;
            }
            y1 = Math.Sqrt(y1);
            y2 = Math.Sqrt(y2);

            double y = y1 * y2;
            if (y == 0)
                return 0;
            return x / y;
        }

        private void LoadOtherServices(int serviceId)
        {
            List<Service> list = _context.Services.Where(w => w.ServiceId != serviceId).ToList();
            List<ServiceRating> ratings = new List<ServiceRating>();
            foreach (var item in list)
            {
                ratings = _context.ServiceRatings.Where(w => w.ServiceId == item.ServiceId).OrderBy(w => w.ServiceId).ToList();
                if (ratings.Count > 0)
                {
                    services.Add(item.ServiceId, ratings);
                }
            }

        }

        public List<ServiceResponse> Recommend(int serviceId)
        {
            var tmp = LoadSimilar(serviceId);
            return _mapper.Map<List<ServiceResponse>>(tmp);
        }

    }
}
