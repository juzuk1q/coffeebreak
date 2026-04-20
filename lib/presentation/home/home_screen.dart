import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/core/widgets/product_card.dart';
import 'package:CoffeeBreak/data/product_service.dart';
import 'package:CoffeeBreak/presentation/order/order_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.navbar,
      appBar: AppHeader(txt: 'Меню'),
      body: Align(
        alignment: .bottomCenter,
        child: Container(
          padding: .all(25),
          height: h * 0.83,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.navbar,
            borderRadius: .vertical(top: .circular(25)),
          ),
          child: FutureBuilder(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return ProductCard(
                    img: item.imagePath,
                    txt: item.name,
                    cost: item.minPrice,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderScreen(product: item),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
