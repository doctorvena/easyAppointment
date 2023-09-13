using RabbitMQ.Client;
using rabiitMqWebApi.Service;

var builder = WebApplication.CreateBuilder(args);


builder.Services.AddHostedService<RabbitMqListenerService>();
builder.Services.AddSingleton<RabbitMqConsumerService>();
builder.Services.AddSingleton<EmailService>();

builder.Services.AddControllers();

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


app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
