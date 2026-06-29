import '../../core/error/exceptions.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/platform_api.dart';
import '../mappers/product_mapper.dart';

class SyncRepositoryImpl implements SyncRepository {
  final PlatformApiDataSource _apiDataSource;
  final LocalDataSource _localDataSource;

  SyncRepositoryImpl({
    required PlatformApiDataSource apiDataSource,
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
        final products = await _apiDataSource.getRecommendations(
          page: page,
          pageSize: 50,
        );

        if (products.isEmpty) {
          hasMore = false;
          break;
        }

        for (final product in products) {
          final localProduct = ProductMapper.toLocal(product);
          await _localDataSource.saveProduct(localProduct);
          syncedCount++;
        }

        if (products.length < 50) {
          hasMore = false;
        } else {
          page++;
        }
      }

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
