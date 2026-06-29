import '../../repositories/sync_repository.dart';

class SyncProductsUseCase {
  final SyncRepository _repository;

  SyncProductsUseCase(this._repository);

  Future<SyncResult> call() async {
    return await _repository.syncProducts();
  }
}
