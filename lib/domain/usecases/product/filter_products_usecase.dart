import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class FilterProductsUseCase {
  final ProductRepository _repository;

  FilterProductsUseCase(this._repository);

  Future<List<Product>> call({
    double? minPrice,
    double? maxPrice,
    bool? isPurchased,
  }) async {
    return await _repository.filterProducts(
      minPrice: minPrice,
      maxPrice: maxPrice,
      isPurchased: isPurchased,
    );
  }
}
