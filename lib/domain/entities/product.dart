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
