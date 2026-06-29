import '../../domain/entities/product.dart';
import '../datasources/local/database_models.dart';
import '../datasources/remote/pdd_models.dart';

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
    );
  }

  // 拼多多商品转实体
  static Product fromPddGoods(PddGoodsItem pddGoods) {
    return Product(
      id: pddGoods.goodsId,
      name: pddGoods.goodsName,
      thumbnailUrl: pddGoods.goodsThumbnailUrl,
      imageUrls: [
        pddGoods.goodsImageUrl,
        ...pddGoods.goodsGalleryUrls,
      ],
      price: pddGoods.minGroupPrice,
      originalPrice: null,
      platform: 'pdd',
      projectIds: [],
      categoryId: null,
      syncedAt: DateTime.now(),
    );
  }

  // 拼多多商品详情转实体
  static Product fromPddGoodsDetail(PddGoodsDetail pddDetail) {
    return Product(
      id: pddDetail.goodsId,
      name: pddDetail.goodsName,
      thumbnailUrl: pddDetail.goodsThumbnailUrl,
      imageUrls: [
        pddDetail.goodsImageUrl,
        ...pddDetail.goodsGalleryUrls,
      ],
      price: pddDetail.minGroupPrice,
      originalPrice: pddDetail.minNormalPrice,
      platform: 'pdd',
      projectIds: [],
      categoryId: null,
      syncedAt: DateTime.now(),
    );
  }
}
