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
    public class SalonRecommenderServiceImpl : SalonRecommenderService
    {
        private readonly EasyAppointmnetDbContext _context;
        private readonly IMapper _mapper;
        Dictionary<int, List<SalonRating>> salons = new Dictionary<int, List<SalonRating>>();

        public SalonRecommenderServiceImpl(EasyAppointmnetDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        private List<Salon> LoadSimilar(int salonId)
        {
            LoadOtherServices(salonId);
            List<SalonRating> ratingOfCurrent = _context.SalonRatings.Where(x => x.SalonId == salonId).OrderBy(x => x.UserId).ToList();

            List<SalonRating> ratings1 = new List<SalonRating>();
            List<SalonRating> ratings2 = new List<SalonRating>();
            List<Salon> recommendedServices = new List<Salon>();

            foreach (var salon in salons)
            {
                foreach (SalonRating rating in ratingOfCurrent)
                {
                    if (salon.Value.Where(w => w.UserId == rating.UserId).Count() > 0)
                    {
                        ratings1.Add(rating);
                        ratings2.Add(salon.Value.Where(w => w.UserId == rating.UserId).First());
                    }
                }
                double similarity = GetSimilarity(ratings1, ratings2);
                if (similarity > 0.5)
                {
                    recommendedServices.Add(_context.Salons.AsQueryable().Where(w => w.SalonId == salon.Key).FirstOrDefault());
                }
                ratings1.Clear();
                ratings2.Clear();
            }
            return recommendedServices;
        }

        private double GetSimilarity(List<SalonRating> ratings1, List<SalonRating> ratings2)
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

        private void LoadOtherServices(int salonId)
        {
            List<Salon> list = _context.Salons.Where(w => w.SalonId != salonId).ToList();
            List<SalonRating> ratings = new List<SalonRating>();
            foreach (var item in list)
            {
                ratings = _context.SalonRatings.Where(w => w.SalonId == item.SalonId).OrderBy(w => w.SalonId).ToList();
                if (ratings.Count > 0)
                {
                    salons.Add(item.SalonId, ratings);
                }
            }

        }

        public List<SalonResponse> Recommend(int salonId)
        {
            var tmp = LoadSimilar(salonId);
            return _mapper.Map<List<SalonResponse>>(tmp);
        }

    }
}
