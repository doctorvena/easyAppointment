import 'package:eprodaja_admin/models/salon.dart';

class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();

  factory UserSingleton() {
    return _instance;
  }

  UserSingleton._internal();

  late int loggedInUserId;
  late Salon? loggedInUserSalon = null;
  late String role;
  String? jwtToken;
}
