import 'package:CoffeeBreak/domain/models/product.dart';

class CartItem {
  final int id;
  final int quantity;
  final String sizeName;
  final String syrup;
  final List<int> additivesIds;
  final Product product;

  const CartItem({
    required this.id,
    required this.quantity,
    required this.sizeName,
    required this.syrup,
    required this.additivesIds,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'] ?? 1,
      sizeName: json['size_name'] ?? '',
      syrup: json['syrup'] ?? 'Без сиропа',
      additivesIds: List<int>.from(json['additives_ids'] ?? []),
      product: Product.fromJson(json['product'] ?? {}),
    );
  }

  double get unitPrice => product.priceForSize(sizeName);
  int get totalPrice => (unitPrice * quantity).toInt();
}