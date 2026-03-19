import 'package:products_store_app/features/product/domain/value_objects/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}

class CategoryFailure implements Exception {
  final String message;
  CategoryFailure(this.message);
}
