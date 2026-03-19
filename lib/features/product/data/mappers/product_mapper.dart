import 'dart:convert';

import 'package:products_store_app/core/utils/data_sanitizer.dart';
import 'package:products_store_app/features/product/domain/value_objects/product.dart';

abstract class ProductMapper {
  static Product fromMap(Map<String, dynamic> map) {
    final id = DataSanitizer.readInt(map, 'id', fallback: 0);
    final context = 'product(id:$id)';

    return Product(
      id: id,
      title: DataSanitizer.readString(map, 'title', fallback: 'Unknown product'),
      price: DataSanitizer.readPrice(map, context: context),
      thumbnail: DataSanitizer.readImageUrl(
        map,
        key: 'thumbnail',
        context: context,
      ),
    );
  }

  static Map<String, dynamic> toMap(Product product) {
    return {
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'thumbnail': product.thumbnail,
    };
  }

  static Product fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);

  static String toJson(Product product) => json.encode(toMap(product));
}
