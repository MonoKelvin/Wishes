import '../../../core/storage/local_storage.dart';
import '../../../core/error/exceptions.dart';
import 'database_models.dart';

class LocalDataSource {
  final LocalStorage _storage;

  LocalDataSource(this._storage);

  // 项目操作
  Future<void> saveProject(LocalProjectModel project) async {
    try {
      await _storage.saveProject(project.id, project.toJson());
    } catch (e) {
      throw CacheException('保存项目失败: $e');
    }
  }

  LocalProjectModel? getProject(String id) {
    try {
      final data = _storage.getProject(id);
      if (data != null) {
        return LocalProjectModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw CacheException('获取项目失败: $e');
    }
  }

  List<LocalProjectModel> getAllProjects() {
    try {
      final data = _storage.getAllProjects();
      return data.map((e) => LocalProjectModel.fromJson(e)).toList();
    } catch (e) {
      throw CacheException('获取项目列表失败: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _storage.deleteProject(id);
    } catch (e) {
      throw CacheException('删除项目失败: $e');
    }
  }

  // 商品操作
  Future<void> saveProduct(LocalProductModel product) async {
    try {
      await _storage.saveProduct(product.id, product.toJson());
    } catch (e) {
      throw CacheException('保存商品失败: $e');
    }
  }

  LocalProductModel? getProduct(String id) {
    try {
      final data = _storage.getProduct(id);
      if (data != null) {
        return LocalProductModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw CacheException('获取商品失败: $e');
    }
  }

  List<LocalProductModel> getAllProducts() {
    try {
      final data = _storage.getAllProducts();
      return data.map((e) => LocalProductModel.fromJson(e)).toList();
    } catch (e) {
      throw CacheException('获取商品列表失败: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _storage.deleteProduct(id);
    } catch (e) {
      throw CacheException('删除商品失败: $e');
    }
  }

  // 分类操作
  Future<void> saveCategory(LocalCategoryModel category) async {
    try {
      await _storage.saveCategory(category.id, category.toJson());
    } catch (e) {
      throw CacheException('保存分类失败: $e');
    }
  }

  List<LocalCategoryModel> getCategoriesByProject(String projectId) {
    try {
      final data = _storage.getCategoriesByProject(projectId);
      return data.map((e) => LocalCategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw CacheException('获取分类列表失败: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _storage.deleteCategory(id);
    } catch (e) {
      throw CacheException('删除分类失败: $e');
    }
  }

  // 同步状态
  Future<void> saveLastSyncTime(DateTime time) async {
    try {
      await _storage.saveLastSyncTime(time);
    } catch (e) {
      throw CacheException('保存同步时间失败: $e');
    }
  }

  DateTime? getLastSyncTime() {
    try {
      return _storage.getLastSyncTime();
    } catch (e) {
      throw CacheException('获取同步时间失败: $e');
    }
  }

  Future<void> saveSyncedCount(int count) async {
    try {
      await _storage.saveSyncedCount(count);
    } catch (e) {
      throw CacheException('保存同步数量失败: $e');
    }
  }

  int getSyncedCount() {
    try {
      return _storage.getSyncedCount();
    } catch (e) {
      throw CacheException('获取同步数量失败: $e');
    }
  }
}
