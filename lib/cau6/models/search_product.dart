class SearchProduct {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  final double ratingRate;

  const SearchProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    required this.ratingRate,
  });

  factory SearchProduct.fromJson(Map<String, dynamic> json) {
    return SearchProduct(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      image: json['image'] as String,
      ratingRate: (json['rating']['rate'] as num).toDouble(),
    );
  }
}