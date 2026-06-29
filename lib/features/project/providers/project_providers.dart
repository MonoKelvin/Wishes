import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/usecases/project/create_project_usecase.dart';
import '../../../domain/usecases/project/update_project_usecase.dart';
import '../../../domain/usecases/project/delete_project_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/search_products_usecase.dart';
import '../../../data/repositories/project_repository_impl.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/local/local_datasource.dart';
import '../../home/providers/home_providers.dart';

// Product Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    localDataSource: LocalDataSource(ref.watch(localStorageProvider)),
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
final projectDetailProvider = StateNotifierProvider.family<
    ProjectDetailNotifier, AsyncValue<Project>, String>((ref, projectId) {
  return ProjectDetailNotifier(ref, projectId);
});

class ProjectDetailNotifier extends StateNotifier<AsyncValue<Project>> {
  final Ref _ref;
  final String _projectId;

  ProjectDetailNotifier(this._ref, this._projectId)
      : super(const AsyncValue.loading()) {
    loadProject();
  }

  Future<void> loadProject() async {
    state = const AsyncValue.loading();
    try {
      final projectRepository = _ref.read(projectRepositoryProvider);
      final project = await projectRepository.getProject(_projectId);
      state = AsyncValue.data(project);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> togglePin() async {
    try {
      final projectRepository = _ref.read(projectRepositoryProvider);
      await projectRepository.togglePin(_projectId);
      await loadProject();
      _ref.read(projectListProvider.notifier).refresh();
    } catch (e) {
      // 错误处理
    }
  }

  Future<void> markComplete() async {
    try {
      final projectRepository = _ref.read(projectRepositoryProvider);
      await projectRepository.markComplete(_projectId);
      await loadProject();
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
final projectProductsProvider = StateNotifierProvider.family<
    ProjectProductsNotifier, AsyncValue<List<Product>>, String>((ref, projectId) {
  return ProjectProductsNotifier(ref, projectId);
});

class ProjectProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref _ref;
  final String _projectId;

  ProjectProductsNotifier(this._ref, this._projectId)
      : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final productRepository = _ref.read(productRepositoryProvider);
      final products = await productRepository.getProductsByProject(_projectId);
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> togglePurchase(String productId) async {
    // TODO: 实现已购/未购切换
    await loadProducts();
  }
}

// All Products State (for product selector)
final allProductsProvider =
    StateNotifierProvider<AllProductsNotifier, AsyncValue<List<Product>>>((ref) {
  return AllProductsNotifier(ref);
});

class AllProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref _ref;

  AllProductsNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final getProductsUseCase = _ref.read(getProductsUseCaseProvider);
      final products = await getProductsUseCase();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> search(String keyword) async {
    state = const AsyncValue.loading();
    try {
      final searchUseCase = _ref.read(searchProductsUseCaseProvider);
      final products = await searchUseCase(keyword);
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Selected Products State
final selectedProductsProvider =
    StateNotifierProvider<SelectedProductsNotifier, Set<String>>((ref) {
  return SelectedProductsNotifier();
});

class SelectedProductsNotifier extends StateNotifier<Set<String>> {
  SelectedProductsNotifier() : super({});

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
