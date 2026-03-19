// lib/features/product/data/repositories/product_remote_repository.dart

import 'dart:convert';
import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:products_store_app/core/network/network_base_service.dart';
import '../../domain/value_objects/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRemoteRepository implements ProductRepository {
  final NetworkBaseService networkService;

  // Example base URL
  static const String _baseUrl = 'https://dummyjson.com';

  ProductRemoteRepository({required this.networkService});

  int _temp = 0;

  @override
  Future<Either<ProductFailure, List<Product>>> getProducts({
    required int skip,
    required int limit,
    String? query,
    String? category,
  }) async {
    try {
      String url = '$_baseUrl/products?limit=$limit&skip=$skip';

      // Apply search query
      if (query != null && query.isNotEmpty) {
        url = '$_baseUrl/products/search?q=$query';
      }

      // Apply category filter
      if (category != null && category.isNotEmpty) {
        url = '$_baseUrl/products/category/$category';
      }

      // Use the network service
      final responseData = await networkService.get(url: url, parameters: {});

      // Decode JSON
      final data = responseData is String
          ? jsonDecode(responseData)
          : responseData;

      // For search/category endpoints, items might be inside "products"
      final List productsJson = data['products'] ?? data;

      final products = productsJson.map<Product>((e) {
        return Product(
          id: e['id'],
          title: e['title'],
          price: (e['price'] as num).toDouble(),
          thumbnail: e['thumbnail'] ?? '',
        );
      }).toList();

      return Right(products);
    } catch (e, s) {
      if (!kDebugMode) {
        // Log error in production via some logging service
      }
      return Left(ProductFailure('Error fetching products: $e'));
    }
  }
}
