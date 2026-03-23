part of 'index.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailLoaded) {
            final product = state.product;
            final validImages = product.images.where(_isValidImageUrl).toList();
            debugPrint(
              "images ${product.images.length} valids ${validImages.length}",
            );
            final hasValidPrice = product.price >= 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (validImages.isEmpty)
                    _buildLargeImagePlaceholder()
                  else
                    SizedBox(
                      height: 300, // height set for the image gallery
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: validImages.length,
                        itemBuilder: (context, index) {
                          final imageUrl = validImages[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ImageViewer(
                              imageUrl: imageUrl,
                              width: 60,
                              height: 60,
                              boxFit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(8),
                              placeholder: const ImagePlaceholder(),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    _defaultIfEmpty(product.title, 'Unknown product'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _defaultIfEmpty(product.brand, 'Unknown brand'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(_defaultIfEmpty(product.description, 'No description')),
                  const SizedBox(height: 8),
                  Text(
                    hasValidPrice
                        ? 'Price: \$${product.price.toStringAsFixed(2)}'
                        : 'Price unavailable',
                  ),
                  Text('Discount: ${product.discountPercentage}%'),
                  Text('Rating: ${product.rating}'),
                  Text('Stock: ${product.stock}'),
                  Text('Category: ${product.category}'),
                ],
              ),
            );
          } else if (state is ProductDetailError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
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

  static String _defaultIfEmpty(String value, String fallback) {
    if (value.trim().isEmpty) return fallback;
    return value;
  }

  static Widget _buildLargeImagePlaceholder() {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 48,
        color: Colors.grey,
      ),
    );
  }
}
