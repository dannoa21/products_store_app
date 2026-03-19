// lib/features/product/data/repositories/product_remote_repository.dart

import 'dart:convert';
import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:products_store_app/core/network/network_base_service.dart';
import 'package:products_store_app/features/product/domain/value_objects/product_detail.dart';
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

  @override
  Future<Either<ProductFailure, ProductDetail>> getProductById({
    required int id,
  }) async {
    try {
      final url = '$_baseUrl/products/$id';
      final responseData = await networkService.get(url: url, parameters: {});

      final data = responseData is String
          ? jsonDecode(responseData)
          : responseData as Map<String, dynamic>;

      final productDetail = ProductDetail(
        id: data['id'],
        title: data['title'] ?? "Unknown Product",
        description: data['description'] ?? "",
        category: data['category'] ?? "Uncategorized",
        price: data['price'] == null ? 0.0 : (data['price'] as num).toDouble(),
        discountPercentage: data["discountPercentage"] == null
            ? 0.0
            : (data['discountPercentage'] as num).toDouble(),
        rating: data['rating'] == null
            ? 0.0
            : (data['rating'] as num).toDouble(),
        stock: data['stock'] ?? 0,
        brand: data['brand'] ?? "",
        sku: data['sku'] ?? "",
        availabilityStatus: data['availabilityStatus'] ?? "",
        warrantyInformation:
            data['warrantyInformation'] ?? "No warranty information",
        shippingInformation: data['shippingInformation'] ?? "No shipping info",
        images: List<String>.from(data['images'] ?? []),
      );

      return Right(productDetail);
    } catch (e) {
      return Left(ProductFailure('Error fetching product detail: $e'));
    }
  }
}
