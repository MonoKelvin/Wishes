import '../../../domain/entities/product.dart';

/// 平台API数据源抽象接口
abstract class PlatformApiDataSource {
  /// 关键词搜索商品
  Future<List<Product>> searchByKeyword(String keyword,
      {int page = 1, int pageSize = 20});

  /// 获取推荐商品
  Future<List<Product>> getRecommendations({int page = 1, int pageSize = 20});

  /// 通过链接/口令获取商品信息（高佣转链）
  Future<Product?> getProductByLink(String link);

  /// 获取商品详情（通过商品ID）
  Future<Product?> getProductDetail(String itemId);
}
