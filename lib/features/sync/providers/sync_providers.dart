import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/repositories/sync_repository.dart';
import '../../../domain/usecases/sync/sync_products_usecase.dart';
import '../../../data/repositories/sync_repository_impl.dart';
import '../../../data/datasources/local/local_datasource.dart';
import '../../../data/datasources/remote/pdd_api_datasource.dart';
import '../../home/providers/home_providers.dart';

// Sync Progress State
final syncProgressProvider =
    StateNotifierProvider<SyncProgressNotifier, SyncProgressState>((ref) {
  return SyncProgressNotifier(ref);
});

class SyncProgressState {
  final bool isSyncing;
  final double progress;
  final int syncedCount;
  final int totalCount;
  final String? errorMessage;

  const SyncProgressState({
    required this.isSyncing,
    required this.progress,
    required this.syncedCount,
    required this.totalCount,
    this.errorMessage,
  });

  SyncProgressState copyWith({
    bool? isSyncing,
    double? progress,
    int? syncedCount,
    int? totalCount,
    String? errorMessage,
  }) {
    return SyncProgressState(
      isSyncing: isSyncing ?? this.isSyncing,
      progress: progress ?? this.progress,
      syncedCount: syncedCount ?? this.syncedCount,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SyncProgressNotifier extends StateNotifier<SyncProgressState> {
  final Ref _ref;

  SyncProgressNotifier(this._ref)
      : super(const SyncProgressState(
          isSyncing: false,
          progress: 0,
          syncedCount: 0,
          totalCount: 0,
        ));

  Future<void> startSync() async {
    state = state.copyWith(
      isSyncing: true,
      progress: 0,
      syncedCount: 0,
      totalCount: 0,
      errorMessage: null,
    );

    try {
      final syncUseCase = _ref.read(syncProductsUseCaseProvider);
      final result = await syncUseCase();

      if (result.isSuccess) {
        state = state.copyWith(
          isSyncing: false,
          progress: 1.0,
          syncedCount: result.syncedCount,
          totalCount: result.syncedCount,
        );

        // 刷新项目列表
        _ref.read(projectListProvider.notifier).refresh();
      } else {
        state = state.copyWith(
          isSyncing: false,
          errorMessage: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: '同步失败: $e',
      );
    }
  }

  void reset() {
    state = const SyncProgressState(
      isSyncing: false,
      progress: 0,
      syncedCount: 0,
      totalCount: 0,
    );
  }
}
