import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_store_app/features/product/domain/value_objects/category.dart';

import '../../domain/repositories/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository repository;

  CategoryCubit({required this.repository}) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await repository.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  void selectCategory(Category? category) {
    final current = state;
    if (current is CategoryLoaded) {
      emit(CategoryLoaded(categories: current.categories, selected: category));
    }
  }
}
