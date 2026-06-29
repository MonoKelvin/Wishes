import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> searchProducts(String keyword);
  Future<List<Product>> filterProducts({
    double? minPrice,
    double? maxPrice,
    bool? isPurchased,
  });
  Future<Product> getProductDetail(String id);
  Future<void> addProductToProject(String productId, String projectId);
  Future<void> removeProductFromProject(String productId, String projectId);
  Future<void> moveProductToCategory(String productId, String categoryId);
  Future<List<Product>> getProductsByProject(String projectId);

  // 远程API方法
  Future<List<Product>> searchRemoteProducts(String keyword, {int page = 1, int pageSize = 20});
  Future<List<Product>> getRemoteRecommendations({int page = 1, int pageSize = 20});
  Future<Product?> convertLink(String link);
  Future<Product?> getRemoteProductDetail(String itemId);
  Future<void> saveProduct(Product product);
}
