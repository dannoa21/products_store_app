import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:products_store_app/core/network/network_base_service.dart';
import 'package:products_store_app/features/product/domain/value_objects/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRemoteRepository implements CategoryRepository {
  final NetworkBaseService networkService;

  // Example base URL
  static const String _baseUrl = 'https://dummyjson.com';

  CategoryRemoteRepository({required this.networkService});

  @override
  Future<List<Category>> getCategories() async {
    try {
      final url = '$_baseUrl/products/categories';

      // Use the network service
      final responseData = await networkService.get(url: url, parameters: {});

      // Decode JSON
      final data = responseData is String
          ? jsonDecode(responseData)
          : responseData;

      // Ensure it's a List
      if (data is! List) {
        throw CategoryFailure('Unexpected response format');
      }

      // Expecting a list of category strings
      // final List<Category> categories = List<Category>.from(data);
      final List<Category> categories = data.map((item) {
        debugPrint("item is ${item.toString()}");
        return Category.fromJson(item as Map<String, dynamic>);
      }).toList();

      return categories;
    } catch (e) {
      if (!kDebugMode) {
        // Log error in production via a logging service
      }
      throw CategoryFailure('Error fetching categories: $e');
    }
  }
}
