import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/usecases/project/create_project_usecase.dart';
import '../../../domain/usecases/project/update_project_usecase.dart';
import '../../../domain/usecases/project/delete_project_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/search_products_usecase.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/local/local_datasource.dart';
import '../../home/providers/home_providers.dart';

// Product Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    localDataSource: LocalDataSource(ref.watch(localStorageProvider)),
    apiDataSource: ref.watch(platformApiProvider),
  );
});

// UseCase Providers
final createProjectUseCaseProvider = Provider<CreateProjectUseCase>((ref) {
  return CreateProjectUseCase(ref.watch(projectRepositoryProvider));
});

final updateProjectUseCaseProvider = Provider<UpdateProjectUseCase>((ref) {
  return UpdateProjectUseCase(ref.watch(projectRepositoryProvider));
});

final deleteProjectUseCaseProvider = Provider<DeleteProjectUseCase>((ref) {
  return DeleteProjectUseCase(ref.watch(projectRepositoryProvider));
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final searchProductsUseCaseProvider = Provider<SearchProductsUseCase>((ref) {
  return SearchProductsUseCase(ref.watch(productRepositoryProvider));
});

// Project Detail State
final projectDetailProvider =
    FutureProvider.autoDispose.family<Project, String>((ref, projectId) async {
  final projectRepository = ref.read(projectRepositoryProvider);
  return await projectRepository.getProject(projectId);
});

// Project Detail Actions
final projectDetailActionsProvider =
    Provider.autoDispose.family<ProjectDetailActions, String>(
        (ref, projectId) {
  return ProjectDetailActions(ref, projectId);
});

class ProjectDetailActions {
  final Ref _ref;
  final String _projectId;

  ProjectDetailActions(this._ref, this._projectId);

  Future<void> togglePin() async {
    try {
      final projectRepository = _ref.read(projectRepositoryProvider);
      await projectRepository.togglePin(_projectId);
      _ref.invalidate(projectDetailProvider(_projectId));
      _ref.read(projectListProvider.notifier).refresh();
    } catch (e) {
      // 错误处理
    }
  }

  Future<void> markComplete() async {
    try {
      final projectRepository = _ref.read(projectRepositoryProvider);
      await projectRepository.markComplete(_projectId);
      _ref.invalidate(projectDetailProvider(_projectId));
      _ref.read(projectListProvider.notifier).refresh();
    } catch (e) {
      // 错误处理
    }
  }

  Future<void> delete() async {
    try {
      final projectRepository = _ref.read(projectRepositoryProvider);
      await projectRepository.deleteProject(_projectId);
      _ref.read(projectListProvider.notifier).refresh();
    } catch (e) {
      // 错误处理
    }
  }
}

// Products in Project State
final projectProductsProvider = FutureProvider.autoDispose
    .family<List<Product>, String>((ref, projectId) async {
  final productRepository = ref.read(productRepositoryProvider);
  return await productRepository.getProductsByProject(projectId);
});

// All Products State (for product selector)
final allProductsProvider =
    AsyncNotifierProvider<AllProductsNotifier, List<Product>>(() {
  return AllProductsNotifier();
});

class AllProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final getProductsUseCase = ref.read(getProductsUseCaseProvider);
    return await getProductsUseCase();
  }

  Future<void> search(String keyword) async {
    state = const AsyncValue.loading();
    try {
      final searchUseCase = ref.read(searchProductsUseCaseProvider);
      final products = await searchUseCase(keyword);
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final getProductsUseCase = ref.read(getProductsUseCaseProvider);
      final products = await getProductsUseCase();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadRecommendations({int page = 1}) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(productRepositoryProvider);
      final products = await repo.getRemoteRecommendations(page: page);
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Remote Product Search (by link)
final remoteSearchProvider = FutureProvider.autoDispose
    .family<Product?, String>((ref, link) async {
  final repo = ref.read(productRepositoryProvider);
  return await repo.convertLink(link);
});

// Remote Keyword Search
final remoteKeywordSearchProvider = FutureProvider.autoDispose
    .family<List<Product>, Map<String, dynamic>>((ref, params) async {
  final repo = ref.read(productRepositoryProvider);
  return await repo.searchRemoteProducts(
    params['keyword'] as String,
    page: params['page'] as int? ?? 1,
    pageSize: params['pageSize'] as int? ?? 20,
  );
});

// Recommendations Provider
final recommendationsProvider = FutureProvider.autoDispose
    .family<List<Product>, int>((ref, page) async {
  final repo = ref.read(productRepositoryProvider);
  return await repo.getRemoteRecommendations(page: page);
});

// Selected Products State
final selectedProductsProvider =
    NotifierProvider<SelectedProductsNotifier, Set<String>>(() {
  return SelectedProductsNotifier();
});

class SelectedProductsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {};
  }

  void toggle(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state}..add(productId);
    }
  }

  void clear() {
    state = {};
  }

  void selectAll(List<String> productIds) {
    state = {...productIds};
  }
}
