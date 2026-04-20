import 'package:flutter_test/flutter_test.dart';
import 'package:CoffeeBreak/domain/models/product.dart';
import 'package:CoffeeBreak/domain/models/cart_item.dart';

void main() {
  group('CartItem', () {
    final product = Product(
      id: 1, name: 'Эспрессо', imagePath: '', description: '',
      prices: [ProductPrice(sizeName: 'S', price: 100)],
    );

    test('totalPrice корректно рассчитывается', () {
      final item = CartItem(
        id: 1, quantity: 3, sizeName: 'S',
        syrup: 'Без сиропа', additivesIds: [], product: product,
      );
      expect(item.totalPrice, equals(300));
    });

    test('unitPrice возвращает цену для выбранного размера', () {
      final item = CartItem(
        id: 1, quantity: 1, sizeName: 'S',
        syrup: 'Без сиропа', additivesIds: [], product: product,
      );
      expect(item.unitPrice, equals(100.0));
    });

    test('CartItem.fromJson применяет дефолтные значения', () {
      final json = {
        'id': 10,
        'product': {
          'id': 1, 'name': 'Кофе', 'image_path': '',
          'description': '', 'product_prices': [],
        },
      };
      final item = CartItem.fromJson(json);
      expect(item.quantity, equals(1));
      expect(item.syrup, equals('Без сиропа'));
      expect(item.additivesIds, isEmpty);
    });
  });
}