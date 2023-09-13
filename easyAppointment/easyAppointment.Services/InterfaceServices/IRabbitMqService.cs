public interface IRabbitMqService
{
    void PublishReservationNotification(string message);
    void PublishReservationNotification2(string message, string emailTo);
}
