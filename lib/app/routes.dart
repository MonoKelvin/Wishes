import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/product.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/project/presentation/screens/create_project_screen.dart';
import '../features/project/presentation/screens/project_detail_screen.dart';
import '../features/product/presentation/screens/product_detail_screen.dart';
import '../features/product/presentation/screens/remote_product_detail_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
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
          GoRoute(
            path: 'product/remote',
            name: 'remoteProductDetail',
            builder: (context, state) {
              final product = state.extra as Product;
              return RemoteProductDetailScreen(product: product);
            },
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
