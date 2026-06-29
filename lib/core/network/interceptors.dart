import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage = SecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 添加访问令牌到请求头
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 尝试刷新令牌
      try {
        final refreshToken = await _secureStorage.getRefreshToken();
        if (refreshToken != null) {
          // TODO: 实现令牌刷新逻辑
          // final newToken = await _refreshToken(refreshToken);
          // await _secureStorage.saveToken(newToken);
          // 重试原始请求
          // final response = await _retryRequest(err.requestOptions);
          // handler.resolve(response);
          // return;
        }
      } catch (e) {
        // 刷新失败，清除令牌并跳转到登录页
        await _secureStorage.clearAll();
      }
    }
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
