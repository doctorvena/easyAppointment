namespace easyAppointment.Salon.InterfaceServices
{
    public interface Service<T, TSearch> where TSearch : class
    {
        Task<List<T>> Get(TSearch search = null);
        Task<T> GetById(int id);
        Task<bool> Delete(int id);
    }
}
