using easyAppointment.Salon.Responses;

namespace easyAppointment.Salon.InterfaceServices
{
    public interface SalonRecommenderService
    {
        List<SalonResponse> Recommend(int salonId);

    }
}
