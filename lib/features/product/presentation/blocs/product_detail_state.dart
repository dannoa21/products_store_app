import '../../domain/value_objects/product_detail.dart';

abstract class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductDetail product;
  const ProductDetailLoaded(this.product);
}

class ProductDetailError extends ProductDetailState {
  final String message;
  const ProductDetailError(this.message);
}
