using AutoMapper;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class ReviewServiceImpl : ServiceImpl<ReviewResponse, Review, ReviewSearcchObject>, Service<ReviewResponse, ReviewSearcchObject>
    {
        public ReviewServiceImpl(EasyAppointmnetDbContext _context, IMapper _mapper)
            : base(_context, _mapper)
        {

        }

        public override IQueryable<Review> AddFilter(IQueryable<Review> query, ReviewSearcchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.comment))
            {
                query = query.Where(x => x.Comment.StartsWith(search.comment));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Comment.Contains(search.FTS));
            }

            return base.AddFilter(query, search);
        }


    }


}
