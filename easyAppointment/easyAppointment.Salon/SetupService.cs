using Microsoft.EntityFrameworkCore;
using System.IO;
using easyAppointment.Salon.Database;

namespace easyAppointment.Salon
{
    public class SetupService
    {
        public void Init(EasyAppointmnetSalonDbContext context)
        {
            context.Database.Migrate();
        }

        public void InsertData(EasyAppointmnetSalonDbContext context)
        {
            var path = Path.Combine(Directory.GetCurrentDirectory(), "dataSeedSalon.sql");
            var query = File.ReadAllText(path);


            context.Database.ExecuteSqlRaw(query);
        }
    }
}