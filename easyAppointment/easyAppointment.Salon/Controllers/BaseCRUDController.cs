using easyAppointment.Salon.Controllers;
using easyAppointment.Salon.InterfaceServices;
using easyAppointment.Salon.Responses;
using easyAppointment.Salon.SearchObjects;
using Microsoft.AspNetCore.Mvc;

namespace eeasyAppointment.Salon.Controllers
{
    [Route("[controller]")]
    public class BaseCRUDController<T, TSearch, TInsert, TUpdate> : BaseController<T, TSearch> where T : class where TSearch : class
    {
        protected readonly ICRUDService<T, TSearch, TInsert, TUpdate> service;
        protected readonly ILogger<BaseController<T, TSearch>> logger;
        private ILogger<BaseController<SalonResponse, SalonSearchObject>> logger1;
        private SalonService service1;

        public BaseCRUDController(ILogger<BaseController<T, TSearch>> _logger, ICRUDService<T, TSearch, TInsert, TUpdate> _service)
            : base(_logger, _service) 
        {
            service= _service;
            logger= _logger;
        }

        [HttpPost()]
        public virtual async Task<T> Insert([FromBody]TInsert request)
        {
            return await service.Insert(request);
        }
        [HttpPut("{id}")]
        public virtual async Task<T> Update(int id, [FromBody]TUpdate request)
        {
            return await service.Update(id, request);
        }

    }
}
