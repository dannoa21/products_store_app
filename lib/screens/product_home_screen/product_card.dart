import 'package:flutter/material.dart';
import 'package:products_store_app/features/product/domain/value_objects/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValidImage = _isValidImageUrl(product.thumbnail);
    final hasValidPrice = product.price >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              /// Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: hasValidImage
                    ? Image.network(
                        product.thumbnail,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint(
                            'Product image failed to load for id ${product.id}: ${product.thumbnail}',
                          );
                          return _buildImagePlaceholder();
                        },
                      )
                    : _buildImagePlaceholder(),
              ),

              const SizedBox(width: 12),

              /// Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasValidPrice
                          ? '\$${product.price.toStringAsFixed(2)}'
                          : 'Price unavailable',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _isValidImageUrl(String value) {
    if (value.trim().isEmpty) return false;
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static Widget _buildImagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }
}
