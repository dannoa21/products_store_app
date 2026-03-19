import 'package:dartz/dartz.dart';
import '../repositories/product_repository.dart';
import '../value_objects/product.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<ProductFailure, List<Product>>> call({
    required int skip,
    required int limit,
    String? query,
    String? category,
  }) {
    return repository.getProducts(
      skip: skip,
      limit: limit,
      query: query,
      category: category,
    );
  }
}
