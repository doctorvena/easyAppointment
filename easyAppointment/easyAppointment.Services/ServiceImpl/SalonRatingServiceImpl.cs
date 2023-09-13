using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class SalonRatingServiceImpl : BaseCRUDService<SalonRatingResponse, SalonRating, SalonRatingSearcchObject, SalonRatingInsertRequest, SalonRatingUpdateRequest>, SalonRatingService
    {
        public SalonRatingServiceImpl(ILogger<BaseCRUDService<SalonRatingResponse, SalonRating, SalonRatingSearcchObject, SalonRatingInsertRequest, SalonRatingUpdateRequest>> _logger, EasyAppointmnetDbContext _context, IMapper _mapper)
            : base(_logger ,_context, _mapper)
        {

        }
        public override async Task<SalonRatingResponse> Insert(SalonRatingInsertRequest insert)
        {
            var response = await base.Insert(insert);

            var salonId = insert.SalonId;     
            var salon = await _context.Salons.FirstOrDefaultAsync(s => s.SalonId == salonId);

            if (salon != null)
            {
                var ratings = await _context.SalonRatings.Where(r => r.SalonId == salonId).ToListAsync();
                var totalRating = ratings.Sum(r => r.Rating);
                var averageRating = ratings.Any() ? Math.Round((double)totalRating / ratings.Count, 1) : 0.0;

                salon.Rating = averageRating;
                _context.Salons.Update(salon);
                await _context.SaveChangesAsync();
            }

            return response;
        }
    }
}
