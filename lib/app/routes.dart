import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/providers/auth_providers.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/project/presentation/screens/create_project_screen.dart';
import '../features/project/presentation/screens/project_detail_screen.dart';
import '../features/product/presentation/screens/product_detail_screen.dart';

// 将Riverpod状态变化桥接为GoRouter可监听的Listenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.future).asStream(),
    ),
    redirect: (context, state) {
      final isLoggedIn = authState.asData?.value != null;
      final isLoginRoute = state.matchedLocation == '/login';

      // 未登录且不在登录页 -> 重定向到登录页
      if (!isLoggedIn && !isLoginRoute) return '/login';

      // 已登录且在登录页 -> 重定向到首页
      if (isLoggedIn && isLoginRoute) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'project/create',
            name: 'createProject',
            builder: (context, state) => const CreateProjectScreen(),
          ),
          GoRoute(
            path: 'project/:id',
            name: 'projectDetail',
            builder: (context, state) {
              final projectId = state.pathParameters['id']!;
              return ProjectDetailScreen(projectId: projectId);
            },
          ),
          GoRoute(
            path: 'product/:id',
            name: 'productDetail',
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductDetailScreen(productId: productId);
            },
          ),
        ],
      ),
    ],
  );
});
