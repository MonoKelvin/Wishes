import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/repositories/sync_repository.dart';
import '../../../domain/usecases/project/get_projects_usecase.dart';
import '../../../domain/usecases/sync/sync_products_usecase.dart';
import '../../../data/repositories/project_repository_impl.dart';
import '../../../data/repositories/sync_repository_impl.dart';
import '../../../data/datasources/local/local_datasource.dart';

// Repository Providers
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepositoryImpl(
    localDataSource: LocalDataSource(ref.watch(localStorageProvider)),
  );
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepositoryImpl(
    apiDataSource: ref.watch(pddApiDataSourceProvider),
    localDataSource: LocalDataSource(ref.watch(localStorageProvider)),
  );
});

// UseCase Providers
final getProjectsUseCaseProvider = Provider<GetProjectsUseCase>((ref) {
  return GetProjectsUseCase(ref.watch(projectRepositoryProvider));
});

final syncProductsUseCaseProvider = Provider<SyncProductsUseCase>((ref) {
  return SyncProductsUseCase(ref.watch(syncRepositoryProvider));
});

// Project List State
final projectListProvider =
    StateNotifierProvider<ProjectListNotifier, AsyncValue<List<Project>>>((ref) {
  return ProjectListNotifier(ref);
});

class ProjectListNotifier extends StateNotifier<AsyncValue<List<Project>>> {
  final Ref _ref;

  ProjectListNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    state = const AsyncValue.loading();
    try {
      final getProjectsUseCase = _ref.read(getProjectsUseCaseProvider);
      final projects = await getProjectsUseCase();
      state = AsyncValue.data(projects);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadProjects();
  }
}

// Sync State
final syncStateProvider =
    StateNotifierProvider<SyncNotifier, AsyncValue<SyncState>>((ref) {
  return SyncNotifier(ref);
});

class SyncState {
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final int syncedCount;

  const SyncState({
    required this.isSyncing,
    this.lastSyncTime,
    required this.syncedCount,
  });
}

class SyncNotifier extends StateNotifier<AsyncValue<SyncState>> {
  final Ref _ref;

  SyncNotifier(this._ref) : super(const AsyncValue.data(SyncState(isSyncing: false, syncedCount: 0))) {
    _loadSyncState();
  }

  Future<void> _loadSyncState() async {
    try {
      final syncRepository = _ref.read(syncRepositoryProvider);
      final lastSyncTime = await syncRepository.getLastSyncTime();
      final syncedCount = await syncRepository.getSyncedCount();
      state = AsyncValue.data(SyncState(
        isSyncing: false,
        lastSyncTime: lastSyncTime,
        syncedCount: syncedCount,
      ));
    } catch (e) {
      // 忽略错误
    }
  }

  Future<void> syncProducts() async {
    state = const AsyncValue.data(SyncState(isSyncing: true, syncedCount: 0));
    try {
      final syncUseCase = _ref.read(syncProductsUseCaseProvider);
      final result = await syncUseCase();
      state = AsyncValue.data(SyncState(
        isSyncing: false,
        lastSyncTime: result.syncTime,
        syncedCount: result.syncedCount,
      ));

      // 刷新项目列表
      _ref.read(projectListProvider.notifier).refresh();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
