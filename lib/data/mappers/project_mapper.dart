import '../../domain/entities/project.dart';
import '../../domain/entities/category.dart';
import '../datasources/local/database_models.dart';

class ProjectMapper {
  // 本地模型转实体
  static Project toEntity(LocalProjectModel local) {
    return Project(
      id: local.id,
      name: local.name,
      scene: local.scene,
      tags: local.tags,
      categories: [], // 分类需要单独查询
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
      isPinned: local.isPinned,
      isCompleted: local.isCompleted,
      productCount: local.productCount,
      totalPrice: local.totalPrice,
    );
  }

  // 实体转本地模型
  static LocalProjectModel toLocal(Project entity) {
    return LocalProjectModel(
      id: entity.id,
      name: entity.name,
      scene: entity.scene,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isPinned: entity.isPinned,
      isCompleted: entity.isCompleted,
      productCount: entity.productCount,
      totalPrice: entity.totalPrice,
    );
  }

  // 分类本地模型转实体
  static Category categoryToEntity(LocalCategoryModel local) {
    return Category(
      id: local.id,
      name: local.name,
      projectId: local.projectId,
      sortOrder: local.sortOrder,
      createdAt: local.createdAt,
    );
  }

  // 分类实体转本地模型
  static LocalCategoryModel categoryToLocal(Category entity) {
    return LocalCategoryModel(
      id: entity.id,
      name: entity.name,
      projectId: entity.projectId,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
    );
  }
}
