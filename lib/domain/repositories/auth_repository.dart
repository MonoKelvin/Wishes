import '../entities/user.dart';

abstract class AuthRepository {
  /// 生成OAuth授权URL
  String getAuthorizationUrl();

  /// 用授权码完成登录（保存token、获取用户信息）
  Future<User> loginWithCode(String authorizationCode);

  /// 登出
  Future<void> logout();

  /// 获取access_token
  Future<String> getAccessToken();

  /// 刷新token
  Future<String> refreshToken();

  /// 是否已登录
  Future<bool> isLoggedIn();

  /// 获取当前用户
  Future<User?> getCurrentUser();
}
