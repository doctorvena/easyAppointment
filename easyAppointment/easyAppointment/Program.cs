
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using RabbitMQ.Client;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.ServiceImpl;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Model.Responses;
using easyAppointment.Services.Database;
using Microsoft.EntityFrameworkCore;
using easyAppointment;
using easyAppointment.Salon.ServiceImpl;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<ReservationsService, ReservationsServiceImpl>();
builder.Services.AddScoped<TimeSlotsService, TimeSlotsServiceImpl>();
builder.Services.AddSingleton<IRabbitMqService, RabbitMqService>();
builder.Services.AddScoped<SalonService, SalonServiceImpl>();
builder.Services.AddScoped<SalonRatingService, SalonRatingServiceImpl>();
builder.Services.AddScoped<SalonPhotoService, SalonPhotoServiceImpl>();
builder.Services.AddScoped<SalonEmployeeService, SalonEmployeeServiceImpl>();
builder.Services.AddScoped<CityService, CityServiceImpl>();
builder.Services.AddScoped<ReservationsService, ReservationsServiceImpl>();
builder.Services.AddScoped<TimeSlotsService, TimeSlotsServiceImpl>();
builder.Services.AddScoped<UserService, UserServiceImpl>();
builder.Services.AddScoped<Service<SexResponse, SexSearchObject>, SexServiceImpl>();
builder.Services.AddScoped<Service<CityResponse, BaseSearchObject>, CityServiceImpl>();
builder.Services.AddScoped<Service<SalonRatingResponse, SalonRatingSearcchObject>, SalonRatingServiceImpl>();
builder.Services.AddScoped<Service<RoleResponse, RoleSearchObject>, RolesServiceImpl>();
builder.Services.AddScoped<SalonService, SalonServiceImpl>();
builder.Services.AddScoped<SalonRatingService, SalonRatingServiceImpl>();
builder.Services.AddScoped<SalonPhotoService, SalonPhotoServiceImpl>();
builder.Services.AddScoped<SalonEmployeeService, SalonEmployeeServiceImpl>();
builder.Services.AddScoped<SalonRecommenderService, SalonRecommenderServiceImpl>();


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

builder.Services.AddAutoMapper(typeof(TimeSlotsService));

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<EasyAppointmnetDbContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(ReservationsService));
builder.Services.AddAutoMapper(typeof(TimeSlotsService));
builder.Services.AddHttpContextAccessor();

builder.Services.AddSingleton(sp =>
{
    var config = sp.GetRequiredService<IConfiguration>();
    var factory = new ConnectionFactory()
    {
        HostName = config["RabbitMq:Hostname"],
        UserName = config["RabbitMq:Username"],
        Password = config["RabbitMq:Password"]
    };

    return new Lazy<IConnection>(() => factory.CreateConnection());
});

builder.Services.AddSingleton(sp =>
{
    var connection = sp.GetRequiredService<Lazy<IConnection>>();
    return connection.Value.CreateModel();
});

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
    var dataContext = scope.ServiceProvider.GetRequiredService<EasyAppointmnetDbContext>();
    dataContext.Database.EnsureCreated();

    new SetupService().Init(dataContext);
    new SetupService().InsertData(dataContext);

    var services = scope.ServiceProvider;
    var recommendationService = services.GetRequiredService<SalonRecommenderService>();
    await recommendationService.CreateModel();
}

app.Run();
