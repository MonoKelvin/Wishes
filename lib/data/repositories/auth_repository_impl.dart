import '../../core/error/exceptions.dart';
import '../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/pdd_api_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final PddApiDataSource _apiDataSource;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl({
    required PddApiDataSource apiDataSource,
    required SecureStorage secureStorage,
  })  : _apiDataSource = apiDataSource,
        _secureStorage = secureStorage;

  @override
  Future<User> login() async {
    try {
      // TODO: 实现拼多多OAuth2.0授权流程
      // 1. 打开拼多多授权页面
      // 2. 获取authorization_code
      // 3. 用code换取access_token
      // 4. 获取用户信息

      // 临时返回模拟用户
      final user = User(
        id: 'temp_user_id',
        nickname: '测试用户',
        avatarUrl: '',
        createdAt: DateTime.now(),
      );

      await _secureStorage.saveUserId(user.id);
      return user;
    } catch (e) {
      throw AuthException('登录失败: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _secureStorage.clearAll();
    } catch (e) {
      throw AuthException('登出失败: $e');
    }
  }

  @override
  Future<String> getAccessToken() async {
    try {
      final token = await _secureStorage.getToken();
      if (token == null) {
        throw AuthException('未登录');
      }
      return token;
    } catch (e) {
      throw AuthException('获取令牌失败: $e');
    }
  }

  @override
  Future<String> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        throw AuthException('刷新令牌不存在');
      }

      // TODO: 实现令牌刷新逻辑
      // 调用拼多多API刷新令牌

      return 'new_token';
    } catch (e) {
      throw AuthException('刷新令牌失败: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _secureStorage.hasToken();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userId = await _secureStorage.getUserId();
      if (userId == null) return null;

      // TODO: 从本地存储或API获取用户信息
      return User(
        id: userId,
        nickname: '用户',
        avatarUrl: '',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }
}
