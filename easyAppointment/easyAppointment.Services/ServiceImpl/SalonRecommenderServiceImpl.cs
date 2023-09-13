using easyAppointment.Services.Database;
using easyAppointment.Services.InterfaceServices;
using easyAppointment.Model.Requests;
using easyAppointment.Model.Responses;
using easyAppointment.Model.SearchObjects;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;

namespace easyAppointment.Salon.ServiceImpl
{
    public class SalonRecommenderServiceImpl : SalonRecommenderService
    {
        private readonly EasyAppointmnetDbContext _context;
        private readonly IMapper _mapper;
        Dictionary<int, List<SalonRating>> salons = new Dictionary<int, List<SalonRating>>();

        public SalonRecommenderServiceImpl(EasyAppointmnetDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }


        public List<SalonResponse> Recommend(int salonId)
        {
            if (salonId == 0)
            {
                var bestRatedSalons = _context.Salons
                   .OrderByDescending(s => s.SalonRatings.Average(r => r.Rating))
                   .Take(5)
                   .ToList();

                return _mapper.Map<List<SalonResponse>>(bestRatedSalons);
            }

            var salon = _context.Salons.FirstOrDefault(s => s.SalonId == salonId);
            if (salon == null) throw new Exception("Salon does not exist.");

            var mlContext = new MLContext();

            var model = LoadModel(mlContext);

            var salonIds = _context.Salons
                .Where(x => x.SalonId != salonId)
                .Select(x => x.SalonId)
                .ToList();

            var recommendedsalonIds = GetSalonPredictions(mlContext, model, salonId, salonIds);

            var recommendedSalons = _context.Salons
                .Where(s => recommendedsalonIds.Contains(s.SalonId))
                .ToList();

            return _mapper.Map<List<SalonResponse>>(recommendedSalons);
        }

        List<int> GetSalonPredictions(MLContext mlContext, ITransformer model, int salonId, List<int> salonIds)
        {
            var predictionEngine = mlContext.Model.CreatePredictionEngine<SalonRatingEntry, SalonRatingPrediction>(model);
            var predictionList = new List<SalonRatingPrediction>();

            var predictionResult = new List<Tuple<int, float>>();

            salonIds.ForEach(id =>
            {
                var prediction = predictionEngine.Predict(new SalonRatingEntry()
                {
                    SalonId = (uint)salonId,
                    CoRatedSalonId = (uint)id
                });

                predictionResult.Add(new Tuple<int, float>(id, prediction.Score));
            });

            return predictionResult.OrderByDescending(pr => pr.Item2)
               .Select(pr => pr.Item1).Take(3).ToList();
        }

        ITransformer LoadModel(MLContext mlContext)
        {
            DataViewSchema modelSchema;

            var modelPath = Path.Combine(Environment.CurrentDirectory, "SalonRecommenderModel.zip");

            ITransformer trainedModel = mlContext.Model.Load(modelPath, out modelSchema);

            return trainedModel;
        }

        public async Task CreateModel()
        {
            var mlContext = new MLContext();
            //var users = _context.Users.Include(u => u.SalonRatings.Where(usr => usr.Rating >= 3)).ToList();
            var users = _context.Users
            .Include(u => u.SalonRatings.Where(usr => usr.Rating >= 3))
            .Where(u => u.UserRoles.Any(ur => ur.Role.RoleName == "Customer"))
            .ToList();
            var data = new List<SalonRatingEntry>();

            if (users != null)
            {
                users.ForEach(u =>
                {
                    if (u.SalonRatings.Count > 1)
                    {
                        var userSalonIds = u.SalonRatings.Select(usr => usr.SalonId).ToList();

                        userSalonIds.ForEach(usId =>
                        {
                            var relatedSalons = u.SalonRatings.Where(usr => usr.SalonId != usId).ToList();

                            relatedSalons.ForEach(rs =>
                            {
                                data.Add(new SalonRatingEntry
                                {
                                    SalonId = (uint)usId,
                                    CoRatedSalonId = (uint)rs.SalonId
                                });
                            });
                        });
                    }
                });
            }

            var trainingData = mlContext.Data.LoadFromEnumerable(data);

            ITransformer model = BuildAndTrainModel(mlContext, trainingData);

            SaveModel(mlContext, trainingData.Schema, model);
        }

        ITransformer BuildAndTrainModel(MLContext mlContext, IDataView trainingData)
        {
            var options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = nameof(SalonRatingEntry.SalonId),
                MatrixRowIndexColumnName = nameof(SalonRatingEntry.CoRatedSalonId),
                LabelColumnName = "Label",

                LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                Alpha = 0.01,
                Lambda = 0.025,

                NumberOfIterations = 100,
                C = 0.00001
            };

            var pipeline = mlContext.Recommendation().Trainers.MatrixFactorization(options);

            var model = pipeline.Fit(trainingData);

            return model;
        }

        void SaveModel(MLContext mlContext, DataViewSchema trainingDataViewSchema, ITransformer model)
        {
            var modelPath = Path.Combine(Environment.CurrentDirectory, "SalonRecommenderModel.zip");

            mlContext.Model.Save(model, trainingDataViewSchema, modelPath);
        }

    }

    public class SalonRatingEntry
    {
        [KeyType(count: 100)]
        public uint SalonId { get; set; }
        [KeyType(count: 100)]
        public uint CoRatedSalonId { get; set; }
        public float Label { get; set; }
    }

    public class SalonRatingPrediction
    {
        public float Score { get; set; }
    }
}