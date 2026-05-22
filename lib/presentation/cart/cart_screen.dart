import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/core/widgets/app_button.dart';
import 'package:CoffeeBreak/core/widgets/product_card.dart';
import 'package:CoffeeBreak/data/cart_service.dart';
import 'package:CoffeeBreak/data/order_service.dart';
import 'package:CoffeeBreak/domain/models/cart_item.dart';
import 'package:CoffeeBreak/presentation/order/order_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cartService = CartService();
  List<CartItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await _cartService.getCart();
    if (mounted) {
      setState(() {
      _items = items;
      _isLoading = false;
    });
    }
  }

  int _calculateTotal() {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> _deleteItem(int id) async {
    try {
      final updated = await _cartService.deleteItem(id);
      setState(() => _items = updated);
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
    final updated = await _cartService.updateQuantity(id, count);
    setState(() => _items = updated);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppHeader(txt: 'Корзина'),
      backgroundColor: AppColor.white,
      body: _items.isEmpty
          ? Center(child: Text('Корзина пуста'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: po(b: 10, l: 25, r: 25, t: 5),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ShoppingCard(
                  item: item,
                  onQuantityChanged: (count) =>
                      _updateQuantity(item.id, count),
                  delete: () => _deleteItem(item.id),
                );
              },
            ),
          ),
          Padding(
            padding: pa(20),
            child: AppButton(
              text: 'Оформить заказ',
              onTap: () async {
                if (_items.isEmpty) return;
                final total = _calculateTotal();
                try {
                  await OrderService().placeOrder(_items);
                  if (!mounted) return;
                  setState(() => _items = []);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OrderSuccessScreen(total: total),
                    ),
                  );
                } catch (e) {
                  debugPrint('Ошибка оформления: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                          Text('Ошибка при оформлении заказа')),
                    );
                  }
                }
              },
              price: '${_calculateTotal()}',
            ),
          ),
          fhs(85),
        ],
      ),
    );
  }
}