using AutoMapper;
using Azure.Core;
using easyAppointment.Model;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace easyAppointment.Services.ServiceImpl
{
    public class UserServiceImpl : BaseCRUDService<UserResponse, User, UserSearchObject, UserInsertRequest, UserUpdateRequest>, UserService
    {
        public UserServiceImpl(ILogger<BaseCRUDService<UserResponse, User, UserSearchObject, UserInsertRequest, UserUpdateRequest>> logger, EasyAppointmnetDbContext context, IMapper mapper)
            : base(logger, context, mapper)
        {
        }
        public override async Task BeforeInsert(User entity, UserInsertRequest insert)
        {
            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, insert.Password);
        }

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override IQueryable<User> AddInclude(IQueryable<User> query, UserSearchObject? search = null)
        {
            if (search?.AreRolesIncluded == true)
            {
                query = query.Include("UserRoles.Role");
            }
            return base.AddInclude(query, search);
        }

        public async Task<UserResponse> Login(string username, string password)
        {
            try
            {
                var entity = await _context.Users.Include("UserRoles.Role").FirstOrDefaultAsync(x => x.Username == username);

                if (entity == null)
                {
                    throw new UserException("Wrong username or password");
                }
                var hash = GenerateHash(entity.PasswordSalt, password);

                if (hash != entity.PasswordHash)
                {
                    throw new UserException("Wrong username or password");
                }
                return _mapper.Map<UserResponse>(entity);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public UserResponse Register(UserInsertRequest request)
        {
            var entity = _mapper.Map<User>(request);

            if (request.Password != request.PasswordRepeat)
            {
                throw new UserException("Password and PasswordRepeat are not the same!");
            }

            var korisnici = _context.Users.ToList();
            foreach (var korisnik in korisnici)
            {
                if (korisnik.Username == request.Username)
                    throw new UserException("Username is taken!");
                if (korisnik.Email == request.Email)
                    throw new UserException("Email is taken!");
            }

            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);

            _context.Add(entity);
            _context.SaveChanges(); // Ensure that entity is saved and UserId is generated

            var userRoles = new UserRole
            {
                UserId = entity.UserId,
                RoleId = request.RoleId,
                ModificationDate = DateTime.Now
            };
            _context.UserRoles.AddRange(userRoles);
            _context.SaveChanges();

            return _mapper.Map<UserResponse>(entity);
        }
    }
}
