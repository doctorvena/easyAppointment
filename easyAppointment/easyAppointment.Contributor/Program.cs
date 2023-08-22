using easyAppointment.Contributor;
using easyAppointment.Contributor.Database;
using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.SearchObjects;
using easyAppointment.Contributor.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<Service<SexResponse, SexSearchObject>, SexServiceImpl>();
builder.Services.AddScoped<Service<RoleResponse, RoleSearchObject>, RolesServiceImpl>();

builder.Services.AddAutoMapper(typeof(IUserService));

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<EasyAppointmnetUserDbContext>(options =>
    options.UseSqlServer(connectionString));

var app = builder.Build();

// Configure the HTTP request pipeline.

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    //var dataContext = scope.ServiceProvider.GetRequiredService<EasyAppointmnetUserDbContext>();
    //dataContext.Database.EnsureCreated();

    //new SetupService().Init(dataContext);
    //new SetupService().InsertData(dataContext);

}

app.Run();
