import '../../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository _repository;

  RefreshTokenUseCase(this._repository);

  Future<String> call() async {
    return await _repository.refreshToken();
  }
}
