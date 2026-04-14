class Additive {
  final int id;
  final String name;
  final String imagePath;
  final double price;

  const Additive({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
  });

  factory Additive.fromJson(Map<String, dynamic> json) {
    return Additive(
      id: json['id'],
      name: json['name'] ?? '',
      imagePath: json['image_path'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
    );
  }

  String get priceLabel => '${price.toInt()}₽';
}