using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using System.Text;
using System.Net.Mail;
using Newtonsoft.Json;

namespace rabiitMqWebApi.Service
{
    public class RabbitMqConsumerService
    {
        private readonly IModel _channel;
        private readonly string _queueName;
        private readonly string _emailTo = "sjor.venandi@outlook.com";
        private readonly string _smtpServer = "smtp.outlook.com"; // For Outlook
        private readonly int _smtpPort = 587; // Common port for SMTP with TLS
        private readonly string _smtpUser; // The email used to send from.
        private readonly string _smtpPassword; // Be cautious with hardcoding passwords.

        public RabbitMqConsumerService(IModel channel, IConfiguration configuration)
        {
            _smtpUser = configuration["SMTP:User"];
            _smtpPassword = configuration["SMTP:Password"];

            _channel = channel;
            _queueName = configuration["RabbitMq:QueueName"];

            // Using _queueName for queue declaration.
            _channel.QueueDeclare(queue: _queueName,
                                  durable: false,
                                  exclusive: false,
                                  autoDelete: false,
                                  arguments: null);
        }

        public void StartListening()
        {
            var consumer = new EventingBasicConsumer(_channel);

            consumer.Received += (model, ea) =>
            {
                var body = ea.Body.ToArray();
                var combinedMessage = Encoding.UTF8.GetString(body);
                var splitMessage = combinedMessage.Split('|');

                var emailTo = splitMessage[0];
                var message = splitMessage[1];

                SendEmail2(message, emailTo);
            };


            //consumer.Received += (model, ea) =>
            //{
            //    var body = ea.Body.ToArray();
            //    var message = Encoding.UTF8.GetString(body);
            //    SendEmail(message);
            //};

            _channel.BasicConsume(queue: _queueName, autoAck: true, consumer: consumer);
        }
        private void SendEmail(string bodyContent)
        {
            using (var client = new SmtpClient(_smtpServer, _smtpPort))
            {
                client.EnableSsl = true;
                client.Credentials = new System.Net.NetworkCredential(_smtpUser, _smtpPassword);

                var mailMessage = new MailMessage
                {
                    From = new MailAddress(_smtpUser),
                    Subject = "New RabbitMQ Message",
                    Body = bodyContent,
                };

                mailMessage.To.Add(_emailTo);

                client.Send(mailMessage);
            }
        }

        private void SendEmail2(string bodyContent, string emailTo)
        {
            using (var client = new SmtpClient(_smtpServer, _smtpPort))
            {
                client.EnableSsl = true;
                client.Credentials = new System.Net.NetworkCredential(_smtpUser, _smtpPassword);

                var mailMessage = new MailMessage
                {
                    From = new MailAddress(_smtpUser),
                    Subject = "New RabbitMQ Message",
                    Body = bodyContent,
                };

                mailMessage.To.Add(emailTo);  // use the passed emailTo instead of the hardcoded one
                client.Send(mailMessage);
            }
        }

    }
}
