import 'package:CoffeeBreak/domain/models/product.dart';
import 'additive.dart';

class CartItem {
  final int id;
  final int quantity;
  final String sizeName;
  final String syrup;
  final List<Additive> additives;
  final Product product;

  const CartItem({
    required this.id,
    required this.quantity,
    required this.sizeName,
    required this.syrup,
    required this.additives,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'] ?? 1,
      sizeName: json['size_name'] ?? '',
      syrup: json['syrup'] ?? 'Без сиропа',
      additives: (json['additives'] as List<dynamic>? ?? [])
          .map((e) => Additive.fromJson(e))
          .toList(),
      product: Product.fromJson(json['product'] ?? {}),
    );
  }

  double get unitPrice {
    final additivesPrice = additives.fold(
      0.0,
          (sum, additive) => sum + additive.price,
    );

    return product.priceForSize(sizeName) + additivesPrice;
  }
  int get totalPrice => (unitPrice * quantity).toInt();

  Map<String, dynamic> toJson() => {
    'id': id,
    'quantity': quantity,
    'size_name': sizeName,
    'syrup': syrup,
    'additives': additives.map((e) => {
      'id': e.id,
      'name': e.name,
      'image_path': e.imagePath,
      'price': e.price,
    }).toList(),
    'product': product.toJson(),
  };

  String? get sizeLabel {
    switch (sizeName.toUpperCase()) {
      case 'S':
        return 'Маленький';
      case 'M':
        return 'Средний';
      case 'L':
        return 'Большой';
      case 'XL':
        return 'Очень большой';
    }
  }
}