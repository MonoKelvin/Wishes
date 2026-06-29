class Product {
  final String id;
  final String name;
  final String thumbnailUrl;
  final List<String> imageUrls;
  final double price;
  final double? originalPrice;
  final String platform;
  final List<String> projectIds;
  final String? categoryId;
  final DateTime syncedAt;
  final String? affiliateUrl;
  final String? couponUrl;
  final String? tkl;
  final double? commissionRate;
  final String? shopName;
  final int? salesCount;
  final String? couponInfo;

  const Product({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.imageUrls,
    required this.price,
    this.originalPrice,
    required this.platform,
    required this.projectIds,
    this.categoryId,
    required this.syncedAt,
    this.affiliateUrl,
    this.couponUrl,
    this.tkl,
    this.commissionRate,
    this.shopName,
    this.salesCount,
    this.couponInfo,
  });

  Product copyWith({
    String? id,
    String? name,
    String? thumbnailUrl,
    List<String>? imageUrls,
    double? price,
    double? originalPrice,
    String? platform,
    List<String>? projectIds,
    String? categoryId,
    DateTime? syncedAt,
    String? affiliateUrl,
    String? couponUrl,
    String? tkl,
    double? commissionRate,
    String? shopName,
    int? salesCount,
    String? couponInfo,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      platform: platform ?? this.platform,
      projectIds: projectIds ?? this.projectIds,
      categoryId: categoryId ?? this.categoryId,
      syncedAt: syncedAt ?? this.syncedAt,
      affiliateUrl: affiliateUrl ?? this.affiliateUrl,
      couponUrl: couponUrl ?? this.couponUrl,
      tkl: tkl ?? this.tkl,
      commissionRate: commissionRate ?? this.commissionRate,
      shopName: shopName ?? this.shopName,
      salesCount: salesCount ?? this.salesCount,
      couponInfo: couponInfo ?? this.couponInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnailUrl': thumbnailUrl,
      'imageUrls': imageUrls,
      'price': price,
      'originalPrice': originalPrice,
      'platform': platform,
      'projectIds': projectIds,
      'categoryId': categoryId,
      'syncedAt': syncedAt.toIso8601String(),
      'affiliateUrl': affiliateUrl,
      'couponUrl': couponUrl,
      'tkl': tkl,
      'commissionRate': commissionRate,
      'shopName': shopName,
      'salesCount': salesCount,
      'couponInfo': couponInfo,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      platform: json['platform'] as String,
      projectIds: List<String>.from(json['projectIds'] as List),
      categoryId: json['categoryId'] as String?,
      syncedAt: DateTime.parse(json['syncedAt'] as String),
      affiliateUrl: json['affiliateUrl'] as String?,
      couponUrl: json['couponUrl'] as String?,
      tkl: json['tkl'] as String?,
      commissionRate: json['commissionRate'] != null
          ? (json['commissionRate'] as num).toDouble()
          : null,
      shopName: json['shopName'] as String?,
      salesCount: json['salesCount'] as int?,
      couponInfo: json['couponInfo'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
