import 'package:flutter_test/flutter_test.dart';
import 'package:CoffeeBreak/domain/models/product.dart';
import 'package:CoffeeBreak/domain/models/cart_item.dart';

void main() {
  group('OrderService', () {
    final product = Product(
      id: 1, name: 'Капучино', imagePath: '', description: '',
      prices: [ProductPrice(sizeName: 'M', price: 200)],
    ); // Product

    test('calculateTotal возвращает корректную сумму', () {
      final items = [
        CartItem(id: 1, quantity: 2, sizeName: 'M',
            syrup: '', additivesIds: [], product: product),
        CartItem(id: 2, quantity: 1, sizeName: 'M',
            syrup: '', additivesIds: [], product: product),
      ];
      int total = items.fold(0, (sum, item) => sum + item.totalPrice);
      expect(total, equals(600));
    });

    test('calculateTotal для пустой корзины возвращает 0', () {
      int total = <CartItem>[].fold(0, (sum, item) => sum + item.totalPrice);
      expect(total, equals(0));
    });
  });
}