using Microsoft.EntityFrameworkCore;
using System.IO;
using easyAppointment.Services.Database;

namespace AppointIT
{
    public class SetupService
    {
        public void Init(EasyAppointmnetDbContext context)
        {
            context.Database.Migrate();
        }

        public void InsertData(EasyAppointmnetDbContext context)
        {
            var path = Path.Combine(Directory.GetCurrentDirectory(), "dataSeed.sql");
            var query = File.ReadAllText(path);


            context.Database.ExecuteSqlRaw(query);
        }
    }
}