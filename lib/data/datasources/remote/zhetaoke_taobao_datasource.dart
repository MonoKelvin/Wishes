import 'package:dio/dio.dart';

import '../../../core/config/api_config.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/product.dart';
import 'platform_api.dart';
import 'zhetaoke_models.dart';

class ZhetaokeTaobaoDataSource implements PlatformApiDataSource {
  final Dio _dio;

  ZhetaokeTaobaoDataSource({required Dio dio}) : _dio = dio;

  Map<String, dynamic> _buildParams(Map<String, dynamic> extra) {
    return {
      'appkey': ApiConfig.zhetaokeAppkey,
      ...extra,
    };
  }

  @override
  Future<List<Product>> searchByKeyword(String keyword,
      {int page = 1, int pageSize = 20}) async {
    try {
      final params = _buildParams({
        'keyword': keyword,
        'page_no': page,
        'page_size': pageSize,
      });

      final response = await _dio.get(
        '${ApiConfig.zhetaokeBaseUrl}/${ApiConstants.itemSearch}',
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final searchResponse = ZhetaokeSearchResponse.fromJson(data);
          if (searchResponse.isSuccess && searchResponse.result != null) {
            return searchResponse.result!.items
                .map(_convertSearchItemToProduct)
                .toList();
          }
        }
      }
      return [];
    } on DioException catch (e) {
      throw NetworkException(e.message ?? '网络错误');
    }
  }

  @override
  Future<List<Product>> getRecommendations({
    int page = 1,
    int pageSize = 20,
  }) async {
    // 不使用PID的API暂不支持推荐功能
    return [];
  }

  @override
  Future<Product?> getProductByLink(String link) async {
    try {
      final params = _buildParams({
        'tkl': Uri.encodeComponent(link),
      });

      final response = await _dio.get(
        '${ApiConfig.zhetaokeBaseUrl}/${ApiConstants.batchConvert}',
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final convertResponse = ZhetaokeConvertResponse.fromJson(data);
          if (convertResponse.isSuccess &&
              convertResponse.content != null &&
              convertResponse.content!.isNotEmpty) {
            return _convertItemToProduct(convertResponse.content!.first);
          }
        }
      }
      return null;
    } on DioException catch (e) {
      throw NetworkException(e.message ?? '网络错误');
    }
  }

  @override
  Future<Product?> getProductDetail(String itemId) async {
    // 通过批量转链API获取商品详情
    // 需要先构造一个商品链接
    try {
      final params = _buildParams({
        'tkl': Uri.encodeComponent('https://item.taobao.com/item.htm?id=$itemId'),
      });

      final response = await _dio.get(
        '${ApiConfig.zhetaokeBaseUrl}/${ApiConstants.batchConvert}',
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final convertResponse = ZhetaokeConvertResponse.fromJson(data);
          if (convertResponse.isSuccess &&
              convertResponse.content != null &&
              convertResponse.content!.isNotEmpty) {
            return _convertItemToProduct(convertResponse.content!.first);
          }
        }
      }
      return null;
    } on DioException catch (e) {
      throw NetworkException(e.message ?? '网络错误');
    }
  }

  Product _convertSearchItemToProduct(ZhetaokeSearchItem item) {
    final imageUrls = <String>[];
    if (item.pictUrl != null && item.pictUrl!.isNotEmpty) {
      imageUrls.add(item.pictUrl!);
    }
    if (item.smallImages != null && item.smallImages!.isNotEmpty) {
      imageUrls
          .addAll(item.smallImages!.split('|').where((s) => s.isNotEmpty));
    }

    final price = double.tryParse(item.zkFinalPrice ?? '0') ?? 0;
    final originalPrice = double.tryParse(item.reservePrice ?? '0');

    return Product(
      id: item.numIid ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: item.title ?? '未知商品',
      thumbnailUrl: item.pictUrl ?? '',
      imageUrls: imageUrls,
      price: price,
      originalPrice:
          originalPrice != null && originalPrice > price ? originalPrice : null,
      platform: 'taobao',
      projectIds: [],
      syncedAt: DateTime.now(),
      affiliateUrl: item.clickUrl ?? item.shortUrl,
      couponUrl: item.couponShareUrl,
      commissionRate: double.tryParse(item.commissionRate ?? '0'),
      shopName: item.shopTitle,
      salesCount: item.volume,
      couponInfo: item.couponInfo,
    );
  }

  Product _convertItemToProduct(ZhetaokeConvertItem item) {
    final imageUrls = <String>[];
    if (item.pictUrl != null && item.pictUrl!.isNotEmpty) {
      imageUrls.add(item.pictUrl!);
    }
    if (item.smallImages != null && item.smallImages!.isNotEmpty) {
      imageUrls
          .addAll(item.smallImages!.split('|').where((s) => s.isNotEmpty));
    }

    final price =
        double.tryParse(item.quanhouJiage ?? item.size ?? '0') ?? 0;
    final originalPrice = double.tryParse(item.size ?? '0');

    return Product(
      id: item.taoId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: item.taoTitle ?? item.title ?? '未知商品',
      thumbnailUrl: item.pictUrl ?? '',
      imageUrls: imageUrls,
      price: price,
      originalPrice:
          originalPrice != null && originalPrice > price ? originalPrice : null,
      platform: 'taobao',
      projectIds: [],
      syncedAt: DateTime.now(),
      affiliateUrl: item.itemUrl ?? item.shorturl,
      couponUrl: item.couponClickUrl,
      tkl: item.tkl,
      commissionRate: double.tryParse(item.tkrate3 ?? '0'),
      shopName: item.shopTitle,
      salesCount: int.tryParse(item.volume ?? '0'),
      couponInfo: item.couponInfo,
    );
  }
}
