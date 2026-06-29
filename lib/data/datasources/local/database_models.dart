class LocalProjectModel {
  final String id;
  final String name;
  final String scene;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isCompleted;
  final int productCount;
  final double totalPrice;

  const LocalProjectModel({
    required this.id,
    required this.name,
    required this.scene,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
    required this.isCompleted,
    required this.productCount,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scene': scene,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'isCompleted': isCompleted,
      'productCount': productCount,
      'totalPrice': totalPrice,
    };
  }

  factory LocalProjectModel.fromJson(Map<String, dynamic> json) {
    return LocalProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      scene: json['scene'] as String,
      tags: List<String>.from(json['tags'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool,
      isCompleted: json['isCompleted'] as bool,
      productCount: json['productCount'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}

class LocalProductModel {
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

  const LocalProductModel({
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

  factory LocalProductModel.fromJson(Map<String, dynamic> json) {
    return LocalProductModel(
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
}

class LocalCategoryModel {
  final String id;
  final String name;
  final String projectId;
  final int sortOrder;
  final DateTime createdAt;

  const LocalCategoryModel({
    required this.id,
    required this.name,
    required this.projectId,
    required this.sortOrder,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'projectId': projectId,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LocalCategoryModel.fromJson(Map<String, dynamic> json) {
    return LocalCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      projectId: json['projectId'] as String,
      sortOrder: json['sortOrder'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class LocalProjectProductModel {
  final String projectId;
  final String productId;
  final String? categoryId;
  final bool isPurchased;
  final DateTime addedAt;

  const LocalProjectProductModel({
    required this.projectId,
    required this.productId,
    this.categoryId,
    required this.isPurchased,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'productId': productId,
      'categoryId': categoryId,
      'isPurchased': isPurchased,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory LocalProjectProductModel.fromJson(Map<String, dynamic> json) {
    return LocalProjectProductModel(
      projectId: json['projectId'] as String,
      productId: json['productId'] as String,
      categoryId: json['categoryId'] as String?,
      isPurchased: json['isPurchased'] as bool,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }
}
