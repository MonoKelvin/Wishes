import '../../domain/entities/product.dart';
import '../datasources/local/database_models.dart';

class ProductMapper {
  // 本地模型转实体
  static Product toEntity(LocalProductModel local) {
    return Product(
      id: local.id,
      name: local.name,
      thumbnailUrl: local.thumbnailUrl,
      imageUrls: local.imageUrls,
      price: local.price,
      originalPrice: local.originalPrice,
      platform: local.platform,
      projectIds: local.projectIds,
      categoryId: local.categoryId,
      syncedAt: local.syncedAt,
      affiliateUrl: local.affiliateUrl,
      couponUrl: local.couponUrl,
      tkl: local.tkl,
      commissionRate: local.commissionRate,
      shopName: local.shopName,
      salesCount: local.salesCount,
      couponInfo: local.couponInfo,
    );
  }

  // 实体转本地模型
  static LocalProductModel toLocal(Product entity) {
    return LocalProductModel(
      id: entity.id,
      name: entity.name,
      thumbnailUrl: entity.thumbnailUrl,
      imageUrls: entity.imageUrls,
      price: entity.price,
      originalPrice: entity.originalPrice,
      platform: entity.platform,
      projectIds: entity.projectIds,
      categoryId: entity.categoryId,
      syncedAt: entity.syncedAt,
      affiliateUrl: entity.affiliateUrl,
      couponUrl: entity.couponUrl,
      tkl: entity.tkl,
      commissionRate: entity.commissionRate,
      shopName: entity.shopName,
      salesCount: entity.salesCount,
      couponInfo: entity.couponInfo,
    );
  }
}
