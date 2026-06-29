import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class GetRecommendationsUseCase {
  final ProductRepository _repository;

  GetRecommendationsUseCase(this._repository);

  Future<List<Product>> call({int page = 1, int pageSize = 20}) async {
    return await _repository.getRemoteRecommendations(
      page: page,
      pageSize: pageSize,
    );
  }
}
