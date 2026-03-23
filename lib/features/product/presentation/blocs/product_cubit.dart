import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_store_app/features/product/domain/repositories/product_repository.dart';
import 'package:products_store_app/features/product/domain/value_objects/product.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit({required ProductRepository repository})
    : _repository = repository,
      super(const ProductInitial());

  final int _limit = 20;
  bool _isFetching = false;

  String? _currentQuery;
  String? _currentCategory;

  /// Initial fetch / refresh
  Future<void> fetchProducts({String? query, String? category}) async {
    print("fetch called");
    if (_isFetching) return;

    _currentQuery = query;
    _currentCategory = category;

    emit(const ProductLoading(products: [], hasMore: true));

    _isFetching = true;

    final Either<ProductFailure, List<Product>> result = await _repository
        .getProducts(
          skip: 0,
          limit: _limit,
          query: _currentQuery,
          category: _currentCategory,
        );

    _isFetching = false;

    result.fold(
      (failure) => emit(
        ProductError(
          message: failure.message,
          products: const [],
          hasMore: true,
        ),
      ),
      (products) {
        emit(
          ProductLoaded(products: products, hasMore: products.length == _limit),
        );
      },
    );
  }

  /// Pagination (infinite scroll)
  Future<void> fetchMoreProducts() async {
    if (_isFetching) return;
    if (!state.hasMore) return;

    final currentState = state;

    emit(
      ProductLoadingMore(
        products: currentState.products,
        hasMore: currentState.hasMore,
      ),
    );

    _isFetching = true;

    final result = await _repository.getProducts(
      skip: currentState.products.length,
      limit: _limit,
      query: _currentQuery,
      category: _currentCategory,
    );

    _isFetching = false;

    result.fold(
      (failure) => emit(
        ProductError(
          message: failure.message,
          products: currentState.products, // ✅ keep old data
          hasMore: currentState.hasMore,
        ),
      ),
      (newProducts) {
        final allProducts = [...currentState.products, ...newProducts];

        emit(
          ProductLoaded(
            products: allProducts,
            hasMore: newProducts.length == _limit,
          ),
        );
      },
    );
  }
}
