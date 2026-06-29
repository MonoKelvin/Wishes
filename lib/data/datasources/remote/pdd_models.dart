// OAuth Token 响应
class PddTokenResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String? tokenType;

  const PddTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.tokenType,
  });

  factory PddTokenResponse.fromJson(Map<String, dynamic> json) {
    final data = json['pop_auth_token_response'] ?? json;
    return PddTokenResponse(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      expiresIn: data['expires_in'] as int,
      tokenType: data['token_type'] as String?,
    );
  }
}

class PddGoodsSearchResponse {
  final int total;
  final List<PddGoodsItem> goodsList;

  const PddGoodsSearchResponse({
    required this.total,
    required this.goodsList,
  });

  factory PddGoodsSearchResponse.fromJson(Map<String, dynamic> json) {
    final response = json['goods_search_response'] as Map<String, dynamic>;
    return PddGoodsSearchResponse(
      total: response['total'] as int,
      goodsList: (response['goods_list'] as List)
          .map((e) => PddGoodsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PddGoodsItem {
  final String goodsId;
  final String goodsName;
  final double minGroupPrice;
  final int sales;
  final String mallName;
  final String goodsThumbnailUrl;
  final String goodsImageUrl;
  final List<String> goodsGalleryUrls;

  const PddGoodsItem({
    required this.goodsId,
    required this.goodsName,
    required this.minGroupPrice,
    required this.sales,
    required this.mallName,
    required this.goodsThumbnailUrl,
    required this.goodsImageUrl,
    required this.goodsGalleryUrls,
  });

  factory PddGoodsItem.fromJson(Map<String, dynamic> json) {
    return PddGoodsItem(
      goodsId: json['goods_id'] as String,
      goodsName: json['goods_name'] as String,
      minGroupPrice: (json['min_group_price'] as num).toDouble() / 100, // 转换为元
      sales: json['sales'] as int,
      mallName: json['mall_name'] as String,
      goodsThumbnailUrl: json['goods_thumbnail_url'] as String,
      goodsImageUrl: json['goods_image_url'] as String,
      goodsGalleryUrls: (json['goods_gallery_urls'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class PddGoodsDetailResponse {
  final PddGoodsDetail goodsDetail;

  const PddGoodsDetailResponse({
    required this.goodsDetail,
  });

  factory PddGoodsDetailResponse.fromJson(Map<String, dynamic> json) {
    final response = json['goods_detail_response'] as Map<String, dynamic>;
    return PddGoodsDetailResponse(
      goodsDetail: PddGoodsDetail.fromJson(
          response['goods_detail'] as Map<String, dynamic>),
    );
  }
}

class PddGoodsDetail {
  final String goodsId;
  final String goodsName;
  final double minGroupPrice;
  final double minNormalPrice;
  final int sales;
  final String mallName;
  final String goodsThumbnailUrl;
  final String goodsImageUrl;
  final List<String> goodsGalleryUrls;
  final String goodsDesc;

  const PddGoodsDetail({
    required this.goodsId,
    required this.goodsName,
    required this.minGroupPrice,
    required this.minNormalPrice,
    required this.sales,
    required this.mallName,
    required this.goodsThumbnailUrl,
    required this.goodsImageUrl,
    required this.goodsGalleryUrls,
    required this.goodsDesc,
  });

  factory PddGoodsDetail.fromJson(Map<String, dynamic> json) {
    return PddGoodsDetail(
      goodsId: json['goods_id'] as String,
      goodsName: json['goods_name'] as String,
      minGroupPrice: (json['min_group_price'] as num).toDouble() / 100,
      minNormalPrice: (json['min_normal_price'] as num).toDouble() / 100,
      sales: json['sales'] as int,
      mallName: json['mall_name'] as String,
      goodsThumbnailUrl: json['goods_thumbnail_url'] as String,
      goodsImageUrl: json['goods_image_url'] as String,
      goodsGalleryUrls: (json['goods_gallery_urls'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      goodsDesc: json['goods_desc'] as String? ?? '',
    );
  }
}
