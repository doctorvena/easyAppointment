using easyAppointment.Contributor;
using easyAppointment.Contributor.Database;
using easyAppointment.Contributor.FeignClient;
using easyAppointment.Contributor.Models;
using easyAppointment.Contributor.SearchObjects;
using easyAppointment.Contributor.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<Service<SexResponse, SexSearchObject>, SexServiceImpl>();
builder.Services.AddScoped<Service<RoleResponse, RoleSearchObject>, RolesServiceImpl>();

builder.Services.AddHttpClient<SalonFeignClient>();
builder.Services.AddAutoMapper(typeof(IUserService));

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
builder.Services.AddDbContext<EasyAppointmnetUserDbContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services.AddHttpContextAccessor();

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
    var dataContext = scope.ServiceProvider.GetRequiredService<EasyAppointmnetUserDbContext>();
    dataContext.Database.EnsureCreated();

    new SetupService().Init(dataContext);
    new SetupService().InsertData(dataContext);
}

app.Run();
