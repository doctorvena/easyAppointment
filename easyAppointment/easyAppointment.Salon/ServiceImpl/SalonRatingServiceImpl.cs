using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Requests;
using easyAppointment.Salon.Database;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace easyAppointment.Salon.ServiceImpl
{
    public class SalonRatingServiceImpl : BaseCRUDService<SalonRatingResponse, Database.SalonRating, SalonRatingSearchObject, SalonRatingInsertRequest, SalonRatingUpdateRequest>, SalonRatingService
    {
        public SalonRatingServiceImpl(ILogger<BaseCRUDService<SalonRatingResponse, Database.SalonRating, SalonRatingSearchObject, SalonRatingInsertRequest, SalonRatingUpdateRequest>> _logger, EasyAppointmnetSalonDbContext _context, IMapper _mapper)
            : base(_logger ,_context, _mapper)
        {

        }

        public override async Task<SalonRatingResponse> Insert(SalonRatingInsertRequest insert)
        {
            var response = await base.Insert(insert);

            // Update Salon's rating field
            var salonId = insert.SalonId; // Assuming there's a SalonId property in SalonRatingInsertRequest
            var salon = await _context.Salons.FirstOrDefaultAsync(s => s.SalonId == salonId);

            if (salon != null)
            {
                var ratings = await _context.SalonRatings.Where(r => r.SalonId == salonId).ToListAsync();
                var totalRating = ratings.Sum(r => r.Rating);
                var averageRating = ratings.Any() ? (double)totalRating / ratings.Count : 0.0;

                salon.Rating = averageRating;
                _context.Salons.Update(salon);
                await _context.SaveChangesAsync();
            }

            return response;
        }
    }
}
