using easyAppointment.Reservation.InterfaceServices;

namespace easyAppointment.Reservation.InterfaceServices
{
    public interface ICRUDService<T, TSearch, TInsert, TUpdate> : Service<T, TSearch> where TSearch : class
    {
        Task<T> Insert(TInsert insert);
        Task<T> Update(int id, TUpdate update);


    }

}
