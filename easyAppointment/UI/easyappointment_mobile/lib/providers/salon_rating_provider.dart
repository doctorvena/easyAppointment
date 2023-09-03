import 'package:easyappointment_mobile/providers/base_provider.dart';

import '../models/salon-rating.dart';

class SalonRatingProvider extends BaseProvider<SalonRating> {
  SalonRatingProvider() : super("/SalonRating");

  @override
  SalonRating fromJson(data) {
    return SalonRating.fromJson(data);
  }
}
