using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Text;


public class RabbitMqService : IRabbitMqService
{
    private readonly IModel _channel;
    private readonly string _queueName;

    public RabbitMqService(IModel channel, IConfiguration configuration)
    {
        _channel = channel;
        _queueName = configuration["RabbitMq:QueueName"];
    }

    public void PublishReservationNotification(string message)
    {
        var body = Encoding.UTF8.GetBytes(message);
        _channel.BasicPublish(exchange: "", routingKey: _queueName, basicProperties: null, body: body);
    }
    public void PublishReservationNotification2(string message, string emailTo)
    {
        var combinedMessage = $"{emailTo}|{message}";
        var body = Encoding.UTF8.GetBytes(combinedMessage);
        _channel.BasicPublish(exchange: "", routingKey: _queueName, basicProperties: null, body: body);
    }

}
