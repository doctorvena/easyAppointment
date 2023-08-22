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

// Add services to the container.
builder.Services.AddScoped<ReservationsService, ReservationsServiceImpl>();
builder.Services.AddScoped<TimeSlotsService, TimeSlotsServiceImpl>();

builder.Services.AddHttpClient<UserFeignClient>();
builder.Services.AddHttpClient<SalonEmployeeFeignClient>();

builder.Services.AddControllers(x=>
{
    //x.Filters.Add<ErrorFilter>();
});


// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<EasyAppointmnetReservationDbContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(ReservationsService));
builder.Services.AddAutoMapper(typeof(TimeSlotsService));


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
    //var dataContext = scope.ServiceProvider.GetRequiredService<EasyAppointmnetReservationDbContext>();
    //dataContext.Database.EnsureCreated();

    //new SetupService().Init(dataContext);
    //new SetupService().InsertData(dataContext);

}

app.Run();
