import 'package:dartz/dartz.dart';
import 'package:products_store_app/features/product/domain/value_objects/product_detail.dart';
import '../value_objects/product.dart';

abstract class ProductRepository {
  Future<Either<ProductFailure, List<Product>>> getProducts({
    required int skip,
    required int limit,
    String? query,
    String? category,
  });

  Future<Either<ProductFailure, ProductDetail>> getProductById({
    required int id,
  });
}

class ProductFailure {
  final String message;

  const ProductFailure(this.message);
}
