namespace easyAppointment.Salon.Database;

public partial class City
{
    public int CityId { get; set; }

    public string CityName { get; set; } = null!;

    public string? Country { get; set; }

}
