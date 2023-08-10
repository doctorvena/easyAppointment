using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Services.ServiceImpl;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    public class ReportController 
    {
        ReportService _reportService;
        public ReportController(ReportService reportService)
        {
            _reportService = reportService;
        }
            //[HttpGet("download-report")]
            //public async Task<IActionResult> DownloadReport()
            //{

            //}
    }
}
