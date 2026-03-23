import 'package:products_store_app/core/utils/data_sanitizer.dart';
import 'package:products_store_app/features/product/domain/value_objects/product_detail.dart';

abstract class ProductDetailMapper {
  static ProductDetail fromMap(
    Map<String, dynamic> map, {
    int fallbackId = -1,
  }) {
    final parsedId = DataSanitizer.readInt(map, 'id', fallback: fallbackId);
    final context = 'productDetail(id:$parsedId)';

    return ProductDetail(
      id: parsedId,
      title: DataSanitizer.readString(
        map,
        'title',
        fallback: 'Unknown product',
      ),
      description: DataSanitizer.readString(
        map,
        'description',
        fallback: 'No description',
      ),
      category: DataSanitizer.readString(
        map,
        'category',
        fallback: 'Uncategorized',
      ),
      price: DataSanitizer.readPrice(map, context: context),
      discountPercentage: DataSanitizer.readDouble(
        map,
        'discountPercentage',
        fallback: 0.0,
      ),
      rating: DataSanitizer.readDouble(map, 'rating', fallback: -1),
      stock: DataSanitizer.readInt(map, 'stock', fallback: -1),
      brand: DataSanitizer.readString(map, 'brand', fallback: 'Unknown brand'),
      sku: DataSanitizer.readString(map, 'sku', fallback: 'Unknown SKU'),
      availabilityStatus: DataSanitizer.readString(
        map,
        'availabilityStatus',
        fallback: 'Unknown availability',
      ),
      warrantyInformation: DataSanitizer.readString(
        map,
        'warrantyInformation',
        fallback: 'No warranty information',
      ),
      shippingInformation: DataSanitizer.readString(
        map,
        'shippingInformation',
        fallback: 'No shipping info',
      ),
      images: DataSanitizer.readImageList(map, key: 'images', context: context),
    );
  }

  static Map<String, dynamic> toMap(ProductDetail productDetail) {
    return {
      'id': productDetail.id,
      'title': productDetail.title,
      'description': productDetail.description,
      'category': productDetail.category,
      'price': productDetail.price,
      'discountPercentage': productDetail.discountPercentage,
      'rating': productDetail.rating,
      'stock': productDetail.stock,
      'brand': productDetail.brand,
      'sku': productDetail.sku,
      'availabilityStatus': productDetail.availabilityStatus,
      'warrantyInformation': productDetail.warrantyInformation,
      'shippingInformation': productDetail.shippingInformation,
      'images': productDetail.images,
    };
  }
}
