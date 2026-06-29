import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/providers/home_providers.dart';

// Sync Progress State
final syncProgressProvider = NotifierProvider<SyncProgressNotifier, SyncProgressState>(() {
  return SyncProgressNotifier();
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

class SyncProgressNotifier extends Notifier<SyncProgressState> {
  @override
  SyncProgressState build() {
    return const SyncProgressState(
      isSyncing: false,
      progress: 0,
      syncedCount: 0,
      totalCount: 0,
    );
  }

  Future<void> startSync() async {
    state = state.copyWith(
      isSyncing: true,
      progress: 0,
      syncedCount: 0,
      totalCount: 0,
      errorMessage: null,
    );

    try {
      final syncUseCase = ref.read(syncProductsUseCaseProvider);
      final result = await syncUseCase();

      if (result.isSuccess) {
        state = state.copyWith(
          isSyncing: false,
          progress: 1.0,
          syncedCount: result.syncedCount,
          totalCount: result.syncedCount,
        );

        // 刷新项目列表
        ref.read(projectListProvider.notifier).refresh();
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
