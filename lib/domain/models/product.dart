class Product {
  final int id;
  final String name;
  final String imagePath;
  final String description;
  final List<ProductPrice> prices;

  const Product({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.prices,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      imagePath: json['image_path'] ?? '',
      description: json['description'] ?? '',
      prices: (json['product_prices'] as List? ?? [])
          .map((p) => ProductPrice.fromJson(p))
          .toList(),
    );
  }

  double priceForSize(String sizeName) {
    final match = prices.firstWhere(
          (p) => p.sizeName == sizeName,
      orElse: () => prices.isNotEmpty ? prices.first : ProductPrice(sizeName: 'S', price: 0),
    );
    return match.price;
  }

  String get minPrice {
    if (prices.isEmpty) return '0';
    final min = prices.map((p) => p.price).reduce((a, b) => a < b ? a : b);
    return 'от ${min.toInt()}₽';
  }
}

class ProductPrice {
  final String sizeName;
  final double price;

  const ProductPrice({
    required this.sizeName,
    required this.price,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(
      sizeName: json['size_name'] ?? 'S',
      price: double.tryParse(json['price'].toString()) ?? 0,
    );
  }
}