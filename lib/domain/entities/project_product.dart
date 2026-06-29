class ProjectProduct {
  final String projectId;
  final String productId;
  final String? categoryId;
  final bool isPurchased;
  final DateTime addedAt;

  const ProjectProduct({
    required this.projectId,
    required this.productId,
    this.categoryId,
    required this.isPurchased,
    required this.addedAt,
  });

  ProjectProduct copyWith({
    String? projectId,
    String? productId,
    String? categoryId,
    bool? isPurchased,
    DateTime? addedAt,
  }) {
    return ProjectProduct(
      projectId: projectId ?? this.projectId,
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      isPurchased: isPurchased ?? this.isPurchased,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'productId': productId,
      'categoryId': categoryId,
      'isPurchased': isPurchased,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory ProjectProduct.fromJson(Map<String, dynamic> json) {
    return ProjectProduct(
      projectId: json['projectId'] as String,
      productId: json['productId'] as String,
      categoryId: json['categoryId'] as String?,
      isPurchased: json['isPurchased'] as bool,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectProduct &&
        other.projectId == projectId &&
        other.productId == productId;
  }

  @override
  int get hashCode => projectId.hashCode ^ productId.hashCode;
}
