using easyAppointment.Reservation.SearchObjects;
using easyAppointment.Reservation.InterfaceServices;
using easyAppointment.Reservation.ServiceImpl;
using Microsoft.EntityFrameworkCore;
using easyAppointment.Reservation.Database;
using easyAppointment.Reservation.FeignClient;
using easyAppointment.Reservation.Responses;
using easyAppointment.Reservation;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<ReservationsService, ReservationsServiceImpl>();
builder.Services.AddScoped<TimeSlotsService, TimeSlotsServiceImpl>();

builder.Services.AddHttpClient<UserFeignClient>();
builder.Services.AddHttpClient<SalonEmployeeFeignClient>();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(
    opt => {
        opt.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8
            .GetBytes(builder.Configuration.GetSection("AppSettings:Token").Value)),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    }
  );

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<EasyAppointmnetReservationDbContext>(options =>
    options.UseSqlServer(connectionString));

var app = builder.Build();

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
    var dataContext = scope.ServiceProvider.GetRequiredService<EasyAppointmnetReservationDbContext>();
    dataContext.Database.EnsureCreated();

    new SetupService().Init(dataContext);
    new SetupService().InsertData(dataContext);

}

app.Run();
