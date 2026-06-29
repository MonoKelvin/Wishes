import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login();
  Future<void> logout();
  Future<String> getAccessToken();
  Future<String> refreshToken();
  Future<bool> isLoggedIn();
  Future<User?> getCurrentUser();
}
