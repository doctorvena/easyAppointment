using easyAppointment.Salon;
using easyAppointment.Salon.Database;
using easyAppointment.Salon.FeignClient;
using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.ServiceImpl;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<CityService, CityServiceImpl>();
builder.Services.AddScoped<SalonService, SalonServiceImpl>();
builder.Services.AddScoped<SalonRatingService, SalonRatingServiceImpl>();
builder.Services.AddScoped<SalonPhotoService, SalonPhotoServiceImpl>();
builder.Services.AddScoped<SalonEmployeeService, SalonEmployeeServiceImpl>();
//builder.Services.AddScoped<SalonRecommenderService, SalonRecommenderServiceImpl>();

builder.Services.AddHttpClient<UserFeignClient>();

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
builder.Services.AddDbContext<EasyAppointmnetSalonDbContext>(options =>
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
    var dataContext = scope.ServiceProvider.GetRequiredService<EasyAppointmnetSalonDbContext>();
    dataContext.Database.EnsureCreated();

    new SetupService().Init(dataContext);
    new SetupService().InsertData(dataContext);
}

app.Run();
