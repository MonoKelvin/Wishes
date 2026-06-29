import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';
import '../error/exceptions.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 添加访问令牌到请求头
    final token = await _secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 如果正在刷新token，将请求加入待处理队列
      if (_isRefreshing) {
        _pendingRequests.add(err.requestOptions);
        return;
      }

      _isRefreshing = true;

      try {
        // 尝试刷新token
        final refreshToken = await _secureStorage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          throw AuthException('刷新令牌不存在');
        }

        // 这里不能直接调用AuthRepository，因为会产生循环依赖
        // 实际的token刷新逻辑需要在Provider层处理
        // 这里先清除token，让应用跳转到登录页
        await _secureStorage.clearTokens();

        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: AuthException('Token已过期，请重新登录'),
          type: DioExceptionType.badResponse,
        ));
      } catch (e) {
        await _secureStorage.clearTokens();
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: AuthException('认证失败，请重新登录'),
          type: DioExceptionType.badResponse,
        ));
      } finally {
        _isRefreshing = false;
        // 清空待处理队列
        _pendingRequests.clear();
      }
    } else {
      handler.next(err);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
