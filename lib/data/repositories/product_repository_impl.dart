import '../../core/error/exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/platform_api.dart';
import '../mappers/product_mapper.dart';

class ProductRepositoryImpl implements ProductRepository {
  final LocalDataSource _localDataSource;
  final PlatformApiDataSource _apiDataSource;

  ProductRepositoryImpl({
    required LocalDataSource localDataSource,
    required PlatformApiDataSource apiDataSource,
  })  : _localDataSource = localDataSource,
        _apiDataSource = apiDataSource;

  @override
  Future<List<Product>> getProducts() async {
    try {
      final localProducts = _localDataSource.getAllProducts();
      return localProducts.map((e) => ProductMapper.toEntity(e)).toList();
    } catch (e) {
      throw CacheException('获取商品列表失败: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String keyword) async {
    try {
      final allProducts = await getProducts();
      if (keyword.isEmpty) return allProducts;

      return allProducts.where((product) {
        return product.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    } catch (e) {
      throw CacheException('搜索商品失败: $e');
    }
  }

  @override
  Future<List<Product>> filterProducts({
    double? minPrice,
    double? maxPrice,
    bool? isPurchased,
  }) async {
    try {
      final allProducts = await getProducts();

      return allProducts.where((product) {
        if (minPrice != null && product.price < minPrice) return false;
        if (maxPrice != null && product.price > maxPrice) return false;
        return true;
      }).toList();
    } catch (e) {
      throw CacheException('筛选商品失败: $e');
    }
  }

  @override
  Future<Product> getProductDetail(String id) async {
    try {
      final localProduct = _localDataSource.getProduct(id);
      if (localProduct == null) {
        throw CacheException('商品不存在');
      }
      return ProductMapper.toEntity(localProduct);
    } catch (e) {
      throw CacheException('获取商品详情失败: $e');
    }
  }

  @override
  Future<void> addProductToProject(String productId, String projectId) async {
    try {
      final localProduct = _localDataSource.getProduct(productId);
      if (localProduct == null) {
        throw CacheException('商品不存在');
      }

      final product = ProductMapper.toEntity(localProduct);
      if (!product.projectIds.contains(projectId)) {
        final updatedProduct = product.copyWith(
          projectIds: [...product.projectIds, projectId],
        );
        final updatedLocalProduct = ProductMapper.toLocal(updatedProduct);
        await _localDataSource.saveProduct(updatedLocalProduct);
      }
    } catch (e) {
      throw CacheException('添加商品到项目失败: $e');
    }
  }

  @override
  Future<void> removeProductFromProject(
      String productId, String projectId) async {
    try {
      final localProduct = _localDataSource.getProduct(productId);
      if (localProduct == null) {
        throw CacheException('商品不存在');
      }

      final product = ProductMapper.toEntity(localProduct);
      final updatedProjectIds =
          product.projectIds.where((id) => id != projectId).toList();
      final updatedProduct = product.copyWith(projectIds: updatedProjectIds);
      final updatedLocalProduct = ProductMapper.toLocal(updatedProduct);
      await _localDataSource.saveProduct(updatedLocalProduct);
    } catch (e) {
      throw CacheException('从项目移除商品失败: $e');
    }
  }

  @override
  Future<void> moveProductToCategory(
      String productId, String categoryId) async {
    try {
      final localProduct = _localDataSource.getProduct(productId);
      if (localProduct == null) {
        throw CacheException('商品不存在');
      }

      final product = ProductMapper.toEntity(localProduct);
      final updatedProduct = product.copyWith(categoryId: categoryId);
      final updatedLocalProduct = ProductMapper.toLocal(updatedProduct);
      await _localDataSource.saveProduct(updatedLocalProduct);
    } catch (e) {
      throw CacheException('移动商品到分类失败: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByProject(String projectId) async {
    try {
      final allProducts = await getProducts();
      return allProducts.where((product) {
        return product.projectIds.contains(projectId);
      }).toList();
    } catch (e) {
      throw CacheException('获取项目商品列表失败: $e');
    }
  }

  @override
  Future<List<Product>> searchRemoteProducts(String keyword,
      {int page = 1, int pageSize = 20}) async {
    try {
      return await _apiDataSource.searchByKeyword(keyword,
          page: page, pageSize: pageSize);
    } catch (e) {
      throw ServerException(500, '搜索商品失败: $e');
    }
  }

  @override
  Future<List<Product>> getRemoteRecommendations({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _apiDataSource.getRecommendations(
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw ServerException(500, '获取推荐商品失败: $e');
    }
  }

  @override
  Future<Product?> convertLink(String link) async {
    try {
      return await _apiDataSource.getProductByLink(link);
    } catch (e) {
      throw ServerException(500, '链接转换失败: $e');
    }
  }

  @override
  Future<Product?> getRemoteProductDetail(String itemId) async {
    try {
      return await _apiDataSource.getProductDetail(itemId);
    } catch (e) {
      throw ServerException(500, '获取商品详情失败: $e');
    }
  }

  @override
  Future<void> saveProduct(Product product) async {
    try {
      final localProduct = ProductMapper.toLocal(product);
      await _localDataSource.saveProduct(localProduct);
    } catch (e) {
      throw CacheException('保存商品失败: $e');
    }
  }
}
