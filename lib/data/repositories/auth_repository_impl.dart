import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../core/config/api_config.dart';
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
  String getAuthorizationUrl() {
    final state = const Uuid().v4();
    final params = Uri(queryParameters: {
      'client_id': ApiConfig.pddClientId,
      'response_type': 'code',
      'redirect_uri': ApiConfig.pddRedirectUri,
      'state': state,
    }).query;
    return '${ApiConfig.pddAuthUrl}?$params';
  }

  @override
  Future<User> loginWithCode(String authorizationCode) async {
    try {
      // 1. 用授权码换取token
      final tokenResponse = await _apiDataSource.exchangeToken(authorizationCode);

      // 2. 保存token
      await _secureStorage.saveToken(tokenResponse.accessToken);
      await _secureStorage.saveRefreshToken(tokenResponse.refreshToken);

      // 3. 计算并保存token过期时间
      final expiry = DateTime.now().add(Duration(seconds: tokenResponse.expiresIn));
      await _secureStorage.saveTokenExpiry(expiry);

      // 4. 创建用户对象（拼多多API不提供用户信息接口，使用默认信息）
      final user = User(
        id: tokenResponse.accessToken.hashCode.toString(),
        nickname: '拼多多用户',
        avatarUrl: '',
        createdAt: DateTime.now(),
      );

      // 5. 保存用户信息
      await _secureStorage.saveUserId(user.id);
      await _secureStorage.saveUserInfo(jsonEncode(user.toJson()));

      return user;
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw AuthException('登录失败: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearAll();
  }

  @override
  Future<String> getAccessToken() async {
    final token = await _secureStorage.getToken();
    if (token == null || token.isEmpty) {
      throw AuthException('未登录');
    }

    // 检查token是否即将过期
    final expiry = await _secureStorage.getTokenExpiry();
    if (expiry != null && DateTime.now().isAfter(expiry.subtract(const Duration(minutes: 5)))) {
      // Token即将过期，刷新
      return await refreshToken();
    }

    return token;
  }

  @override
  Future<String> refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw AuthException('刷新令牌不存在，请重新登录');
    }

    try {
      final tokenResponse = await _apiDataSource.refreshAccessToken(refreshToken);

      // 保存新token
      await _secureStorage.saveToken(tokenResponse.accessToken);
      await _secureStorage.saveRefreshToken(tokenResponse.refreshToken);

      // 更新过期时间
      final expiry = DateTime.now().add(Duration(seconds: tokenResponse.expiresIn));
      await _secureStorage.saveTokenExpiry(expiry);

      return tokenResponse.accessToken;
    } catch (e) {
      // 刷新失败，清除所有token
      await _secureStorage.clearTokens();
      throw AuthException('Token刷新失败，请重新登录');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // 先从缓存读取
      final userInfoJson = await _secureStorage.getUserInfo();
      if (userInfoJson != null) {
        return User.fromJson(jsonDecode(userInfoJson));
      }

      // 缓存不存在，检查是否有token
      final isLoggedIn = await this.isLoggedIn();
      if (!isLoggedIn) return null;

      // 有token但没有用户信息，返回默认用户
      final userId = await _secureStorage.getUserId();
      return User(
        id: userId ?? 'unknown',
        nickname: '拼多多用户',
        avatarUrl: '',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }
}
