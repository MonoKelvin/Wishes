import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class ConvertLinkUseCase {
  final ProductRepository _repository;

  ConvertLinkUseCase(this._repository);

  Future<Product?> call(String link) async {
    return await _repository.convertLink(link);
  }
}
