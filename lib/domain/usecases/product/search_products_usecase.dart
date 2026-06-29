import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<List<Product>> call(String keyword) async {
    return await _repository.searchProducts(keyword);
  }
}
