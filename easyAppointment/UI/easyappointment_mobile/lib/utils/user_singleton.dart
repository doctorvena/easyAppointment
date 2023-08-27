class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();

  factory UserSingleton() {
    return _instance;
  }

  UserSingleton._internal();

  late int loggedInUserId;
  late String role;
  String? jwtToken;
}
