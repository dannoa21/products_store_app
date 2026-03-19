class ProductDetail {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String sku;
  final String availabilityStatus;
  final String warrantyInformation;
  final String shippingInformation;
  final List<String> images;

  ProductDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.sku,
    required this.availabilityStatus,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.images,
  });
}
