using System.Net.Mail;
using System.Net;

public class EmailService
{
    public void SendEmail(string toAddress, string subject, string body)
    {
        var fromAddress = new MailAddress("test-rs2-fitmostar@outlook.com", "Your Name");
        var to = new MailAddress(toAddress);
        var smtp = new SmtpClient
        {
            Host = "smtp.example.com",
            Port = 587,
            EnableSsl = true,
            DeliveryMethod = SmtpDeliveryMethod.Network,
            UseDefaultCredentials = false,
            Credentials = new NetworkCredential(fromAddress.Address, "testRS2fitmostar")
        };

        using var message = new MailMessage(fromAddress, to)
        {
            Subject = subject,
            Body = body
        };

        smtp.Send(message);
    }
}
