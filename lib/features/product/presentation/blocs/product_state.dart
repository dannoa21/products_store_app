part of 'product_cubit.dart';

abstract class ProductState {
  final List<Product> products;
  final bool hasMore;

  const ProductState({required this.products, required this.hasMore});
}

class ProductInitial extends ProductState {
  const ProductInitial() : super(products: const [], hasMore: true);
}

class ProductLoading extends ProductState {
  const ProductLoading({required super.products, required super.hasMore});
}

class ProductLoadingMore extends ProductState {
  const ProductLoadingMore({required super.products, required super.hasMore});
}

class ProductLoaded extends ProductState {
  const ProductLoaded({required super.products, required super.hasMore});
}

class ProductError extends ProductState {
  final String message;

  const ProductError({
    required this.message,
    required super.products,
    required super.hasMore,
  });
}
