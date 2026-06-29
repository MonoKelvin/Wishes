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
    apiDataSource: ref.watch(platformApiProvider),
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
    AsyncNotifierProvider<ProjectListNotifier, List<Project>>(() {
  return ProjectListNotifier();
});

class ProjectListNotifier extends AsyncNotifier<List<Project>> {
  @override
  Future<List<Project>> build() async {
    final getProjectsUseCase = ref.read(getProjectsUseCaseProvider);
    return await getProjectsUseCase();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final getProjectsUseCase = ref.read(getProjectsUseCaseProvider);
      final projects = await getProjectsUseCase();
      state = AsyncValue.data(projects);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Sync State
final syncStateProvider =
    NotifierProvider<SyncNotifier, SyncState>(() {
  return SyncNotifier();
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

class SyncNotifier extends Notifier<SyncState> {
  @override
  SyncState build() {
    _loadSyncState();
    return const SyncState(isSyncing: false, syncedCount: 0);
  }

  Future<void> _loadSyncState() async {
    try {
      final syncRepository = ref.read(syncRepositoryProvider);
      final lastSyncTime = await syncRepository.getLastSyncTime();
      final syncedCount = await syncRepository.getSyncedCount();
      state = SyncState(
        isSyncing: false,
        lastSyncTime: lastSyncTime,
        syncedCount: syncedCount,
      );
    } catch (e) {
      // 忽略错误
    }
  }

  Future<void> syncProducts() async {
    state = const SyncState(isSyncing: true, syncedCount: 0);
    try {
      final syncUseCase = ref.read(syncProductsUseCaseProvider);
      final result = await syncUseCase();
      state = SyncState(
        isSyncing: false,
        lastSyncTime: result.syncTime,
        syncedCount: result.syncedCount,
      );

      ref.read(projectListProvider.notifier).refresh();
    } catch (e) {
      state = const SyncState(isSyncing: false, syncedCount: 0);
    }
  }
}
