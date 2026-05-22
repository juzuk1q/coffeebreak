import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/core/widgets/product_card.dart';
import 'package:CoffeeBreak/data/favourites_service.dart';
import 'package:CoffeeBreak/domain/models/product.dart';
import 'package:CoffeeBreak/presentation/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _service = FavouritesService();
  List<Product> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _service.getFavourites();
    if (mounted)
      setState(() {
        _items = items;
      });
  }

  Future<void> _remove(int productId) async {
    await _service.remove(productId);
    setState(() => _items.removeWhere((e) => e.id == productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppHeader(txt: 'Избранное', back: true),
      body: _items.isEmpty
          ? Center(
              child: Text(
                'Нет избранных товаров',
                style: TxtStyle.m14(color: AppColor.description),
              ),
            )
          : Container(
              color: AppColor.white,
              child: GridView.builder(
                padding: pa(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.8,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ProductCard(
                    img: item.imagePath,
                    txt: item.name,
                    cost: '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderScreen(product: item),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
