import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_store_app/features/product/domain/repositories/product_repository.dart';
import 'package:products_store_app/features/product/presentation/blocs/product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository repository;

  ProductDetailCubit({required this.repository})
    : super(ProductDetailInitial());

  Future<void> fetchProductDetail(int id) async {
    emit(ProductDetailLoading());

    final result = await repository.getProductById(id: id);

    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }
}
