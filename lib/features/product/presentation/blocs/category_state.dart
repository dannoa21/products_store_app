part of 'category_cubit.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final Category? selected;
  CategoryLoaded({required this.categories, this.selected});
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError({required this.message});
}
