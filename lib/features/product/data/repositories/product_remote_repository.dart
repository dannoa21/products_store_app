// lib/features/product/data/repositories/product_remote_repository.dart

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:products_store_app/core/network/network_base_service.dart';
import 'package:products_store_app/features/product/data/mappers/product_detail_mapper.dart';
import 'package:products_store_app/features/product/data/mappers/product_mapper.dart';
import 'package:products_store_app/features/product/domain/value_objects/product_detail.dart';
import '../../domain/value_objects/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRemoteRepository implements ProductRepository {
  final NetworkBaseService networkService;

  // Example base URL
  static const String _baseUrl = 'https://dummyjson.com';

  ProductRemoteRepository({required this.networkService});

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
      final List productsJson = (data is Map<String, dynamic>)
          ? (data['products'] is List ? data['products'] as List : const [])
          : (data is List ? data : const []);

      final products = productsJson
          .whereType<Map<String, dynamic>>()
          .map<Product>(ProductMapper.fromMap)
          .toList();

      return Right(products);
    } catch (e) {
      if (!kDebugMode) {
        // Log error in production via some logging service
      }
      return Left(ProductFailure('Error fetching products: $e'));
    }
  }

  @override
  Future<Either<ProductFailure, ProductDetail>> getProductById({
    required int id,
  }) async {
    try {
      final url = '$_baseUrl/products/$id';
      final responseData = await networkService.get(url: url, parameters: {});

      final decodedData = responseData is String
          ? jsonDecode(responseData)
          : responseData;
      final data = decodedData is Map<String, dynamic>
          ? decodedData
          : <String, dynamic>{};

      final productDetail = ProductDetailMapper.fromMap(data, fallbackId: id);

      return Right(productDetail);
    } catch (e) {
      return Left(ProductFailure('Error fetching product detail: $e'));
    }
  }
}
