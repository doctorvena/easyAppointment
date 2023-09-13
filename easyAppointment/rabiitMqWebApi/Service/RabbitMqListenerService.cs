using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using rabiitMqWebApi.Service;
using System.Threading;
using System.Threading.Tasks;

public class RabbitMqListenerService : IHostedService
{
    private readonly IServiceProvider _serviceProvider;

    public RabbitMqListenerService(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        using var scope = _serviceProvider.CreateScope();
        var rabbitMqService = scope.ServiceProvider.GetRequiredService<RabbitMqConsumerService>();
        rabbitMqService.StartListening();

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}
