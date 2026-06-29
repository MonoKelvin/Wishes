class SyncResult {
  final int syncedCount;
  final DateTime syncTime;
  final bool isSuccess;
  final String? errorMessage;

  const SyncResult({
    required this.syncedCount,
    required this.syncTime,
    required this.isSuccess,
    this.errorMessage,
  });
}

abstract class SyncRepository {
  Future<SyncResult> syncProducts();
  Future<DateTime?> getLastSyncTime();
  Future<int> getSyncedCount();
}
