using AutoMapper;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Services.ServiceImpl;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class SalonPhotoServiceImpl : BaseCRUDService<SalonPhotoResponse, SalonPhoto, SalonPhotoSearchObject, SalonPhotoInsertRequest, SalonPhotoUpdateRequest>, SalonPhotoService
    {
        public SalonPhotoServiceImpl(ILogger<BaseCRUDService<SalonPhotoResponse, SalonPhoto, SalonPhotoSearchObject, SalonPhotoInsertRequest, SalonPhotoUpdateRequest>> _logger, EasyAppointmnetDbContext _context, IMapper _mapper) : base(_logger, _context, _mapper)
        {
        }
        public override IQueryable<SalonPhoto> AddFilter(IQueryable<SalonPhoto> query, SalonPhotoSearchObject? search = null)
        {
            if (search != null)
            {
                query = query.Where(x =>
                    (search.SalonId == null || x.SalonId.Equals(search.SalonId))
                );
            }
            return base.AddFilter(query, search);
        }
    }
}
