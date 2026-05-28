class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double rating;
  final int reviews;
  final List<String> goals;
  final String category;
  final String brand;
  final bool inStock;
  final String? affiliateUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.goals,
    required this.category,
    required this.brand,
    this.inStock = true,
    this.affiliateUrl,
  });

  int get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).round();
  }
}
