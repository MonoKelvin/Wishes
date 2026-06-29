import '../../core/error/exceptions.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/pdd_api_datasource.dart';
import '../mappers/product_mapper.dart';

class SyncRepositoryImpl implements SyncRepository {
  final PddApiDataSource _apiDataSource;
  final LocalDataSource _localDataSource;

  SyncRepositoryImpl({
    required PddApiDataSource apiDataSource,
    required LocalDataSource localDataSource,
  })  : _apiDataSource = apiDataSource,
        _localDataSource = localDataSource;

  @override
  Future<SyncResult> syncProducts() async {
    try {
      int syncedCount = 0;
      int page = 1;
      bool hasMore = true;

      while (hasMore) {
        // 调用拼多多API获取商品列表
        final response = await _apiDataSource.searchGoods(
          keyword: '', // 空关键词获取所有商品
          page: page,
          pageSize: 50,
        );

        if (response.goodsList.isEmpty) {
          hasMore = false;
          break;
        }

        // 转换并保存商品
        for (final pddGoods in response.goodsList) {
          final product = ProductMapper.fromPddGoods(pddGoods);
          final localProduct = ProductMapper.toLocal(product);
          await _localDataSource.saveProduct(localProduct);
          syncedCount++;
        }

        // 检查是否还有更多数据
        if (response.goodsList.length < 50) {
          hasMore = false;
        } else {
          page++;
        }
      }

      // 更新同步状态
      final syncTime = DateTime.now();
      await _localDataSource.saveLastSyncTime(syncTime);
      await _localDataSource.saveSyncedCount(syncedCount);

      return SyncResult(
        syncedCount: syncedCount,
        syncTime: syncTime,
        isSuccess: true,
      );
    } catch (e) {
      return SyncResult(
        syncedCount: 0,
        syncTime: DateTime.now(),
        isSuccess: false,
        errorMessage: '同步失败: $e',
      );
    }
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    try {
      return _localDataSource.getLastSyncTime();
    } catch (e) {
      throw CacheException('获取同步时间失败: $e');
    }
  }

  @override
  Future<int> getSyncedCount() async {
    try {
      return _localDataSource.getSyncedCount();
    } catch (e) {
      throw CacheException('获取同步数量失败: $e');
    }
  }
}
