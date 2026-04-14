import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/core/widgets/app_button.dart';
import 'package:CoffeeBreak/core/widgets/app_slider.dart';
import 'package:CoffeeBreak/core/widgets/quantity_selector.dart';
import 'package:CoffeeBreak/data/order_service.dart';
import 'package:CoffeeBreak/domain/models/product.dart';
import 'package:CoffeeBreak/presentation/order/additives_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderScreen extends StatefulWidget {
  final Product product;
  final bool isEditing;
  final Map? cartItem;

  const OrderScreen({
    super.key,
    required this.product,
    this.isEditing = false,
    this.cartItem,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _orderService = OrderService();

  List<int> _selectedAdditivesIds = [];
  bool _isFav = false;
  int _quantity = 1;
  String _selectedSyrup = 'Без сиропа';
  int _selectedIndex = 0;

  static const _syrupOptions = ['Без сиропа', 'Амаретто', 'Кокос', 'Ваниль', 'Карамель']; // todo: сказать что в бд сиропы находятся по столбцу {"category":"syrup"}

  // берём прямо из модели — никакого запроса к БД
  List<String> get _sizeNames => widget.product.prices.map((p) => p.sizeName).toList();
  double get _currentPrice => widget.product.prices[_selectedIndex].price;
  int get _totalPrice => (_currentPrice * _quantity).toInt();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.cartItem != null) {
      _selectedSyrup = widget.cartItem!['syrup']?.toString() ?? 'Без сиропа';
      _selectedAdditivesIds = List<int>.from(widget.cartItem!['additives_ids'] ?? []);
      _quantity = widget.cartItem!['quantity'] ?? 1;

      final savedSize = widget.cartItem!['size_name']?.toString();
      final idx = _sizeNames.indexOf(savedSize ?? '');
      _selectedIndex = idx != -1 ? idx : 0;
    }
  }

  Future<void> _saveOrder() async {
    if (_sizeNames.isEmpty) return;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final data = {
        'product_id': widget.product.id,
        'quantity': _quantity,
        'size_name': _sizeNames[_selectedIndex],
        'syrup': _selectedSyrup,
        'additives_ids': _selectedAdditivesIds,
        'user_id': user.id,
      };

      if (widget.isEditing && widget.cartItem != null) {
        await _orderService.updateCartItem(widget.cartItem!['id'], data);
      } else {
        await _orderService.addToCart(data);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint('Ошибка сохранения: $e');
    }
  }

  Future<void> _showSyrupPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Какой вкус сиропа вы предпочитаете?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ..._syrupOptions.map((option) {
              final isSelected = option == _selectedSyrup;
              return ListTile(
                title: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? AppColor.main : AppColor.text,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                onTap: () => Navigator.pop(context, option),
              );
            }),
            const Divider(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (result != null) setState(() => _selectedSyrup = result);
  }

  @override
  Widget build(BuildContext context) {
    // если цен нет вообще — показываем загрузку
    if (widget.product.prices.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppHeader(
        txt: 'Заказ',
        back: true,
        actions: [
          GestureDetector(
            onTap: () => setState(() => _isFav = !_isFav),
            child: SvgPicture.asset(
              _isFav ? 'assets/icons/heart.svg' : 'assets/icons/heartNO.svg',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 148,
              decoration: BoxDecoration(
                color: AppColor.card,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(child: Image.network(widget.product.imagePath)),
            ),
            const SizedBox(height: 15),
            Text(widget.product.name, style: TxtStyle.m18),
            const SizedBox(height: 15),
            Text(widget.product.description, textAlign: TextAlign.center),
            const SizedBox(height: 40),

            AppSlider(
              size: _sizeNames,
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
            const SizedBox(height: 15),
            const Divider(),

            AppButton2(
              txt: 'Сироп: $_selectedSyrup',
              onTap: _showSyrupPicker,
            ),
            const Divider(),

            AppButton2(
              txt: 'Добавки',
              onTap: () async {
                final result = await Navigator.push<List<int>>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdditivesScreen(
                      initialSelected: _selectedAdditivesIds,
                    ),
                  ),
                );
                if (result != null) setState(() => _selectedAdditivesIds = result);
              },
            ),
            const Divider(),
            const Spacer(),

            Row(
              children: [
                QuantitySelector(
                  count: _quantity,
                  onChanged: (count) => setState(() => _quantity = count),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: AppButton(
                    text: widget.isEditing ? 'Сохранить' : 'Добавить',
                    onTap: _saveOrder,
                    price: '$_totalPrice',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}