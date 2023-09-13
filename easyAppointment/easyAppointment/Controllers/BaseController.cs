using easyAppointment.Model;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace easyAppointment.Controllers
{
    [Route("[controller]")]
    public class BaseController<T, TSearch> : ControllerBase where T : class where TSearch: class
    {
        protected readonly Service<T, TSearch> service;
        protected readonly ILogger<BaseController<T, TSearch>> logger;

        public BaseController(ILogger<BaseController<T, TSearch>> _logger, Service<T, TSearch> _service)
        {
            logger = _logger;
            service = _service; 
        }

        [HttpGet()]
        public async Task<IEnumerable<T>> Get([FromQuery]TSearch search = null)
        {
            //bool isAuthenticated = User.Identity.IsAuthenticated;
            return await service.Get(search);
        }

        [HttpGet("{id}")]
        public async Task<T> GetById(int id)
        {
            return await service.GetById(id);
        }

        [HttpDelete("{id}")]
        public virtual async Task<IActionResult> Delete(int id)
        {
            var result = await service.Delete(id);
            if (!result)
                return NotFound();

            return NoContent();
        }

    }
}