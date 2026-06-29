import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/refresh_token_usecase.dart';
import '../../../data/repositories/auth_repository_impl.dart';

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    apiDataSource: ref.watch(pddApiDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

// UseCase Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  return RefreshTokenUseCase(ref.watch(authRepositoryProvider));
});

// Auth State
final authStateProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // 启动时检查已保存的登录状态
    final authRepository = ref.read(authRepositoryProvider);
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      return await authRepository.getCurrentUser();
    }
    return null;
  }

  /// 获取授权URL
  String getAuthorizationUrl() {
    final loginUseCase = ref.read(loginUseCaseProvider);
    return loginUseCase.getAuthorizationUrl();
  }

  /// 用授权码登录
  Future<void> loginWithCode(String authorizationCode) async {
    state = const AsyncValue.loading();
    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final user = await loginUseCase(authorizationCode);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
