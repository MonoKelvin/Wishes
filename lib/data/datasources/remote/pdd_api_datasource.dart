import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../../core/constants/api_constants.dart';
import '../../../core/config/api_config.dart';
import '../../../core/error/exceptions.dart';
import 'pdd_models.dart';

class PddApiDataSource {
  final Dio _dio;
  final String _clientId;
  final String _clientSecret;

  PddApiDataSource({
    required Dio dio,
    required String clientId,
    required String clientSecret,
  })  : _dio = dio,
        _clientId = clientId,
        _clientSecret = clientSecret;

  // 生成签名
  String _generateSign(Map<String, dynamic> params) {
    // 1. 参数按key排序
    final sortedKeys = params.keys.toList()..sort();

    // 2. 拼接成 key1value1key2value2 格式
    final buffer = StringBuffer();
    for (final key in sortedKeys) {
      buffer.write(key);
      buffer.write(params[key]);
    }

    // 3. 加上secret前缀
    final signString = '$_clientSecret${buffer.toString()}$_clientSecret';

    // 4. MD5加密转大写
    final bytes = utf8.encode(signString);
    final digest = md5.convert(bytes);
    return digest.toString().toUpperCase();
  }

  // 构建请求参数
  Map<String, dynamic> _buildParams(String type, Map<String, dynamic> data) {
    final params = <String, dynamic>{
      ApiConstants.typeKey: type,
      ApiConstants.clientIdKey: _clientId,
      ApiConstants.timestampKey: DateTime.now().millisecondsSinceEpoch.toString(),
      ...data,
    };

    params[ApiConstants.signKey] = _generateSign(params);
    return params;
  }

  // 搜索商品
  Future<PddGoodsSearchResponse> searchGoods({
    required String keyword,
    int page = 1,
    int pageSize = 50,
    int sortType = 0,
    bool withCoupon = false,
  }) async {
    try {
      final params = _buildParams(ApiConstants.goodsSearch, {
        'keyword': keyword,
        'page': page,
        'page_size': pageSize,
        'sort_type': sortType,
        'with_coupon': withCoupon,
      });

      final response = await _dio.post(
        ApiConstants.pddBaseUrl,
        data: params,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('error_response')) {
          throw ServerException(
            data['error_response']['error_code'] ?? 500,
            data['error_response']['error_msg'] ?? 'Unknown error',
          );
        }
        return PddGoodsSearchResponse.fromJson(data);
      } else {
        throw ServerException(response.statusCode!, '请求失败');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? '网络错误');
    }
  }

  // 获取商品详情
  Future<PddGoodsDetailResponse> getGoodsDetail(String goodsId) async {
    try {
      final params = _buildParams(ApiConstants.goodsDetail, {
        'goods_id': goodsId,
      });

      final response = await _dio.post(
        ApiConstants.pddBaseUrl,
        data: params,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('error_response')) {
          throw ServerException(
            data['error_response']['error_code'] ?? 500,
            data['error_response']['error_msg'] ?? 'Unknown error',
          );
        }
        return PddGoodsDetailResponse.fromJson(data);
      } else {
        throw ServerException(response.statusCode!, '请求失败');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? '网络错误');
    }
  }

  // 用授权码换取access_token
  Future<PddTokenResponse> exchangeToken(String authorizationCode) async {
    try {
      final params = _buildParams(ApiConstants.tokenExchange, {
        ApiConstants.codeKey: authorizationCode,
        ApiConstants.redirectUriKey: ApiConfig.pddRedirectUri,
        ApiConstants.grantTypeKey: 'authorization_code',
      });

      final response = await _dio.post(
        ApiConstants.pddBaseUrl,
        data: params,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('error_response')) {
          throw ServerException(
            data['error_response']['error_code'] ?? 500,
            data['error_response']['error_msg'] ?? 'Unknown error',
          );
        }
        return PddTokenResponse.fromJson(data);
      } else {
        throw ServerException(response.statusCode!, '请求失败');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? '网络错误');
    }
  }

  // 刷新access_token
  Future<PddTokenResponse> refreshAccessToken(String refreshToken) async {
    try {
      final params = _buildParams(ApiConstants.tokenRefresh, {
        ApiConstants.refreshTokenKey: refreshToken,
        ApiConstants.grantTypeKey: 'refresh_token',
      });

      final response = await _dio.post(
        ApiConstants.pddBaseUrl,
        data: params,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('error_response')) {
          throw ServerException(
            data['error_response']['error_code'] ?? 500,
            data['error_response']['error_msg'] ?? 'Unknown error',
          );
        }
        return PddTokenResponse.fromJson(data);
      } else {
        throw ServerException(response.statusCode!, '请求失败');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? '网络错误');
    }
  }
}
