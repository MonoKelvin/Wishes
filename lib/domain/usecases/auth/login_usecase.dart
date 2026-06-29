import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// 获取授权URL
  String getAuthorizationUrl() {
    return _repository.getAuthorizationUrl();
  }

  /// 用授权码完成登录
  Future<User> call(String authorizationCode) async {
    return await _repository.loginWithCode(authorizationCode);
  }
}
