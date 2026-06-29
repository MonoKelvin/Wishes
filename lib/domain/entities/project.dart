import 'category.dart';

class Project {
  final String id;
  final String name;
  final String scene;
  final List<String> tags;
  final List<Category> categories;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isCompleted;
  final int productCount;
  final double totalPrice;

  const Project({
    required this.id,
    required this.name,
    required this.scene,
    required this.tags,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
    required this.isCompleted,
    required this.productCount,
    required this.totalPrice,
  });

  Project copyWith({
    String? id,
    String? name,
    String? scene,
    List<String>? tags,
    List<Category>? categories,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isCompleted,
    int? productCount,
    double? totalPrice,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      scene: scene ?? this.scene,
      tags: tags ?? this.tags,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isCompleted: isCompleted ?? this.isCompleted,
      productCount: productCount ?? this.productCount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scene': scene,
      'tags': tags,
      'categories': categories.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'isCompleted': isCompleted,
      'productCount': productCount,
      'totalPrice': totalPrice,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      scene: json['scene'] as String,
      tags: List<String>.from(json['tags'] as List),
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool,
      isCompleted: json['isCompleted'] as bool,
      productCount: json['productCount'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
