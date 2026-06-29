import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../providers/auth_providers.dart';
import '../widgets/login_button.dart';
import 'oauth_webview_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // 监听认证状态变化
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          context.go('/');
        }
      });
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingXXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.primaryLightColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      boxShadow: AppTheme.mediumShadow,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // 应用名称
                  Text(
                    '心愿',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),

                  // 标语
                  Text(
                    '轻松管理你的购物心愿清单',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),

                  // 登录按钮
                  authState.when(
                    data: (user) => LoginButton(
                      onPressed: () => _startOAuth(context, ref),
                      isLoading: false,
                    ),
                    loading: () => const LoginButton(
                      onPressed: null,
                      isLoading: true,
                    ),
                    error: (error, stack) => Column(
                      children: [
                        LoginButton(
                          onPressed: () => _startOAuth(context, ref),
                          isLoading: false,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingM,
                            vertical: AppTheme.spacingS,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 16,
                                color: AppTheme.errorColor,
                              ),
                              const SizedBox(width: AppTheme.spacingXS),
                              Flexible(
                                child: Text(
                                  '登录失败，请重试',
                                  style: TextStyle(
                                    color: AppTheme.errorColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // 提示文字
                  Text(
                    '登录即表示同意《用户协议》和《隐私政策》',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startOAuth(BuildContext context, WidgetRef ref) async {
    final authNotifier = ref.read(authStateProvider.notifier);
    final authUrl = authNotifier.getAuthorizationUrl();

    // 打开WebView进行授权
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => OAuthWebViewScreen(authorizationUrl: authUrl),
      ),
    );

    // 如果获取到授权码，完成登录
    if (result != null && result.isNotEmpty) {
      await authNotifier.loginWithCode(result);
    }
  }
}
