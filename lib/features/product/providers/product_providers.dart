import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/local/local_datasource.dart';
import '../../project/providers/project_providers.dart';

// Product Detail State
final productDetailProvider = FutureProvider.autoDispose.family<Product, String>((ref, productId) async {
  final productRepository = ref.read(productRepositoryProvider);
  return await productRepository.getProductDetail(productId);
});
