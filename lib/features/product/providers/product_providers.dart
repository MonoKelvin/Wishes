import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';
import '../../project/providers/project_providers.dart';

// Product Detail State
final productDetailProvider = FutureProvider.autoDispose.family<Product, String>((ref, productId) async {
  final productRepository = ref.read(productRepositoryProvider);
  return await productRepository.getProductDetail(productId);
});
