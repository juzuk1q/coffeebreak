import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/core/widgets/app_button.dart';
import 'package:CoffeeBreak/core/widgets/product_card.dart';
import 'package:CoffeeBreak/data/cart_service.dart';
import 'package:CoffeeBreak/domain/models/cart_item.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cartService = CartService();
  late Future<List<CartItem>> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = _cartService.getCart();
  }

  void _refresh() => setState(() => _cartFuture = _cartService.getCart());

  int _calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> _deleteItem(int id) async {
    try {
      await _cartService.deleteItem(id);
      _refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Товар удалён из корзины')),
        );
      }
    } catch (e) {
      debugPrint('Ошибка удаления: $e');
    }
  }

  Future<void> _updateQuantity(int id, int count) async {
    await _cartService.updateQuantity(id, count);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(txt: 'Корзина'),
      backgroundColor: AppColor.white,
      body: FutureBuilder<List<CartItem>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Корзина пуста'));
          }

          final total = _calculateTotal(items);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 10, left: 25, right: 25, top: 5,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ShoppingCard(
                      item: item,
                      onQuantityChanged: (count) => _updateQuantity(item.id, count),
                      delete: () => _deleteItem(item.id),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppButton(
                  text: 'Оформить заказ',
                  onTap: () {},
                  price: '$total',
                ),
              ),
              const SizedBox(height: 70),
            ],
          );
        },
      ),
    );
  }
}