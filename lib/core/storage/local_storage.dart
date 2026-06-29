import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

class LocalStorage {
  static const String _projectsBox = 'projects';
  static const String _productsBox = 'products';
  static const String _categoriesBox = 'categories';
  static const String _syncStateBox = 'sync_state';

  static Future<void> initialize() async {
    // 打开所有需要的盒子
    await Hive.openBox(_projectsBox);
    await Hive.openBox(_productsBox);
    await Hive.openBox(_categoriesBox);
    await Hive.openBox(_syncStateBox);
  }

  // 项目存储
  Box get _projects => Hive.box(_projectsBox);

  Future<void> saveProject(String id, Map<String, dynamic> data) async {
    await _projects.put(id, data);
  }

  Map<String, dynamic>? getProject(String id) {
    return _projects.get(id)?.cast<String, dynamic>();
  }

  List<Map<String, dynamic>> getAllProjects() {
    return _projects.values.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  Future<void> deleteProject(String id) async {
    await _projects.delete(id);
  }

  // 商品存储
  Box get _products => Hive.box(_productsBox);

  Future<void> saveProduct(String id, Map<String, dynamic> data) async {
    await _products.put(id, data);
  }

  Map<String, dynamic>? getProduct(String id) {
    return _products.get(id)?.cast<String, dynamic>();
  }

  List<Map<String, dynamic>> getAllProducts() {
    return _products.values.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  Future<void> deleteProduct(String id) async {
    await _products.delete(id);
  }

  // 分类存储
  Box get _categories => Hive.box(_categoriesBox);

  Future<void> saveCategory(String id, Map<String, dynamic> data) async {
    await _categories.put(id, data);
  }

  Map<String, dynamic>? getCategory(String id) {
    return _categories.get(id)?.cast<String, dynamic>();
  }

  List<Map<String, dynamic>> getCategoriesByProject(String projectId) {
    return _categories.values
        .where((e) => (e as Map)['projectId'] == projectId)
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  Future<void> deleteCategory(String id) async {
    await _categories.delete(id);
  }

  // 同步状态存储
  Box get _syncState => Hive.box(_syncStateBox);

  Future<void> saveLastSyncTime(DateTime time) async {
    await _syncState.put(AppConstants.lastSyncTimeKey, time.toIso8601String());
  }

  DateTime? getLastSyncTime() {
    final timeStr = _syncState.get(AppConstants.lastSyncTimeKey);
    if (timeStr != null) {
      return DateTime.tryParse(timeStr);
    }
    return null;
  }

  Future<void> saveSyncedCount(int count) async {
    await _syncState.put('synced_count', count);
  }

  int getSyncedCount() {
    return _syncState.get('synced_count', defaultValue: 0);
  }
}
