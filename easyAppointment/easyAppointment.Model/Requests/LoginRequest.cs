namespace easyAppointment.Contributor.Models
{
    public class LoginRequest
    {
        public LoginRequest()
        {
            this.UserName = String.Empty;
            this.Password = String.Empty;
        }

        public string UserName { get; set; }
        public string Password { get; set; }
    }

}
