using easyAppointment.Contributor.Database;
using Microsoft.EntityFrameworkCore;
using System.IO;

namespace easyAppointment.Contributor
{
    public class SetupService
    {
        public void Init(EasyAppointmnetUserDbContext context)
        {
            context.Database.Migrate();
        }

        public void InsertData(EasyAppointmnetUserDbContext context)
        {
            var path = Path.Combine(Directory.GetCurrentDirectory(), "dataSeedUser.sql");
            var query = File.ReadAllText(path);


            context.Database.ExecuteSqlRaw(query);
        }
    }
}