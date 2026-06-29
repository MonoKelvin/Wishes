import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/local/local_datasource.dart';
import '../../project/providers/project_providers.dart';

// Product Detail State
final productDetailProvider = StateNotifierProvider.family<
    ProductDetailNotifier, AsyncValue<Product>, String>((ref, productId) {
  return ProductDetailNotifier(ref, productId);
});

class ProductDetailNotifier extends StateNotifier<AsyncValue<Product>> {
  final Ref _ref;
  final String _productId;

  ProductDetailNotifier(this._ref, this._productId)
      : super(const AsyncValue.loading()) {
    loadProduct();
  }

  Future<void> loadProduct() async {
    state = const AsyncValue.loading();
    try {
      final productRepository = _ref.read(productRepositoryProvider);
      final product = await productRepository.getProductDetail(_productId);
      state = AsyncValue.data(product);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
