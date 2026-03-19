import 'package:dartz/dartz.dart';
import '../value_objects/product.dart';

abstract class ProductRepository {
  Future<Either<ProductFailure, List<Product>>> getProducts({
    required int skip,
    required int limit,
    String? query,
    String? category,
  });
}

class ProductFailure {
  final String message;

  const ProductFailure(this.message);
}
