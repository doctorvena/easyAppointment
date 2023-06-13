using AppointIT;
using easyAppointment.Filters;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Security;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Services.ServiceImpl;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddScoped<ReservationsService, ReservationsServiceImpl>();
builder.Services.AddScoped<TimeSlotsService, TimeSlotsServiceImpl>();
builder.Services.AddScoped<UserService, UserServiceImpl>();
builder.Services.AddScoped<Service<SexResponse, SexSearchObject>, SexServiceImpl>();
builder.Services.AddScoped<Service<CityResponse, BaseSearchObject>, CityServiceImpl>();
builder.Services.AddScoped<Service<ServiceRatingResponse, ServiceRatingSearcchObject>, ServiceRatingServiceImpl>();
builder.Services.AddScoped<Service<RoleResponse,RoleSearchObject>, RolesServiceImpl>();
builder.Services.AddScoped<SalonService, SalonServiceImpl>();
builder.Services.AddScoped<ServiceRatingService, ServiceRatingServiceImpl>();
builder.Services.AddScoped<ServiceService, ServiceServiceImpl>();
builder.Services.AddScoped<SalonPhotoService, SalonPhotoServiceImpl>();
builder.Services.AddScoped<SalonEmployeeService, SalonEmployeeServiceImpl>();


builder.Services.AddControllers(x=>
{
    //x.Filters.Add<ErrorFilter>();
});


// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
        }
    });
});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<EasyAppointmnetDbContext>(options =>
    options.UseSqlServer(connectionString));


builder.Services.AddAutoMapper(typeof(UserService));
builder.Services.AddAutoMapper(typeof(ReservationsService));
builder.Services.AddAutoMapper(typeof(TimeSlotsService));
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy =>
        policy.RequireRole("Admin"));
     options.AddPolicy("cc", policy =>
        policy.RequireRole("Bussines"));
});



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
    var dataContext = scope.ServiceProvider.GetRequiredService<EasyAppointmnetDbContext>();
    dataContext.Database.EnsureCreated();

    new SetupService().Init(dataContext);
    new SetupService().InsertData(dataContext);


    //var conn = dataContext.Database.GetConnectionString();

    //dataContext.Database.Migrate();
}

app.Run();
