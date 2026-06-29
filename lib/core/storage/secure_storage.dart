import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage() : _storage = const FlutterSecureStorage();

  // 令牌管理
  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.refreshTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: AppConstants.userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: AppConstants.userIdKey);
  }

  // Token过期时间管理
  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _storage.write(
      key: AppConstants.tokenExpiryKey,
      value: expiry.toIso8601String(),
    );
  }

  Future<DateTime?> getTokenExpiry() async {
    final value = await _storage.read(key: AppConstants.tokenExpiryKey);
    if (value != null) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  // 用户信息缓存
  Future<void> saveUserInfo(String userInfoJson) async {
    await _storage.write(key: AppConstants.userInfoKey, value: userInfoJson);
  }

  Future<String?> getUserInfo() async {
    return await _storage.read(key: AppConstants.userInfoKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.tokenExpiryKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
