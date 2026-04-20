import 'package:flutter_test/flutter_test.dart';
import 'package:CoffeeBreak/domain/models/product.dart';

void main() {
  group('Product', () {
    final product = Product(
      id: 1,
      name: 'Капучино',
      imagePath: 'img.png',
      description: 'Кофейный напиток',
      prices: [
        ProductPrice(sizeName: 'S', price: 150),
        ProductPrice(sizeName: 'M', price: 200),
        ProductPrice(sizeName: 'L', price: 250),
      ],
    );

    test('priceForSize возвращает корректную цену', () {
      expect(product.priceForSize('M'), equals(200.0));
    });

    test('priceForSize возвращает первую цену при неизвестном размере', () {
      expect(product.priceForSize('XL'), equals(150.0));
    });

    test('minPrice возвращает минимальную цену', () {
      expect(product.minPrice, equals('от 150₽'));
    });

    test('minPrice при пустом списке цен возвращает "0₽"', () {
      final emptyProduct = Product(
        id: 2,
        name: '',
        imagePath: '',
        description: '',
        prices: [],
      );
      expect(emptyProduct.minPrice, equals('0'));
    });

    test('Product.fromJson корректно создаёт объект', () {
      final json = {
        'id': 5,
        'name': 'Латте',
        'image_path': 'latte.png',
        'description': 'Молочный кофе',
        'product_prices': [
          {'size_name': 'S', 'price': '120'},
          {'size_name': 'M', 'price': '170'},
        ],
      };

      final p = Product.fromJson(json);
      expect(p.id, equals(5));
      expect(p.name, equals('Латте'));
      expect(p.prices.length, equals(2));
      expect(p.prices.first.price, equals(120.0));
    });
  });
}