namespace easyAppointment.Model.Responses
{
    public class LoginResponse
    {
        public string Token { get; set; }
        public HttpResponseMessage responseMsg { get; set; }
        public UserResponse user { get; set; }
    }
}


