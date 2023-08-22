using Microsoft.EntityFrameworkCore;
using easyAppointment.Reservation.Database;

namespace easyAppointment.Reservation
{
    public class SetupService
    {
        public void Init(EasyAppointmnetReservationDbContext context)
        {
            context.Database.Migrate();
        }

        public void InsertData(EasyAppointmnetReservationDbContext context)
        {
            var path = Path.Combine(Directory.GetCurrentDirectory(), "dataSeed.sql");
            var query = File.ReadAllText(path);


            context.Database.ExecuteSqlRaw(query);
        }
    }
}