import 'package:CoffeeBreak/core/widgets/quantity_selector.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

// основная карточка товара, отображается на основном экране
class ProductCard extends StatelessWidget {
  final String img;
  final String txt;
  final String cost;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.img,
    required this.txt,
    required this.cost,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: .all(7),
        height: 165,
        width: 154,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: .circular(15),
        ),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Padding(
              padding: .only(top: 15, left: 13, right: 13, bottom: 15),
              child: Image.network(img, height: 95),
            ),
            Text(txt, style: TxtStyle.m14(color: AppColor.text)),
            Spacer(),
            Row(
              mainAxisAlignment: .end,
              children: [
                Text(
                  cost,
                  style: GoogleFonts.poppins(
                    color: AppColor.text,
                    fontSize: 14,
                    fontWeight: .w500,
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

// карточка добавок, находится на экране деталей кофе
class AdditiveCard extends StatelessWidget {
  final String img;
  final String txt;
  final String cost;
  final VoidCallback onTap;
  final bool isSelected;

  const AdditiveCard({
    super.key,
    required this.img,
    required this.txt,
    required this.cost,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: .all(7),
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: .circular(15),
          border: .all(
            color: isSelected ? AppColor.main : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Padding(
              padding: .symmetric(horizontal: 20, vertical: 14),
              child: Container(
                height: 105,
                decoration: BoxDecoration(
                  borderRadius: .circular(20),
                  image: DecorationImage(image: NetworkImage(img)),
                ),
              ),
            ),
            Text(txt, style: TxtStyle.m14(color: AppColor.text)),
            SizedBox(height: 15),
            Text(cost, style: TxtStyle.m14(color: AppColor.text)),
          ],
        ),
      ),
    );
  }
}

// карточка кофе, находится в корзине
class ShoppingCard extends StatelessWidget {
  final Map item;
  final Function(int) onQuantityChanged;
  final VoidCallback delete;

  const ShoppingCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    final product = item['product'] as Map? ?? {};
    final List prices = product['product_prices'] as List? ?? [];
    final selectedSize = item['size_name'];

    final priceEntry = prices.firstWhere(
          (p) => p['size_name'] == selectedSize,
      orElse: () => {'price': 0},
    );

    final double basePrice = double.tryParse(priceEntry['price'].toString()) ?? 0;
    final int quantity = item['quantity'] ?? 1;
    final int totalPrice = (basePrice * quantity).toInt();

    return Padding(
      padding: .symmetric(vertical: 7),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SizedBox(width: 8),
            _DeleteAction(onTap: delete),
          ],
        ),
        child: Container(
          height: 105,
          padding: .all(12),
          decoration: BoxDecoration(
            color: AppColor.card,
            borderRadius: .circular(15),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: .circular(10),
                child: Image.network(
                  product['image_path'] ?? '',
                  width: 70,
                  height: 70,
                  fit: .cover,
                  errorBuilder: (_, __, ___) =>
                      Container(width: 70, height: 70, color: Colors.grey[300]),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(product['name'] ?? 'Кофе', style: TxtStyle.m14(color: AppColor.text)),
                    Text(
                      "${item['syrup'] ?? 'Без сиропа'}, ${item['size_name'] ?? ''}",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        QuantitySelector(
                          count: quantity,
                          onChanged: onQuantityChanged,
                        ),
                        Text("$totalPrice ₽", style: TxtStyle.m18),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// кнопка для удаления позиции.
class _DeleteAction extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteAction({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.red2,
            borderRadius: .circular(15),
          ),
          child: Icon(Icons.delete_outline, color: AppColor.red1),
        ),
      ),
    );
  }
}