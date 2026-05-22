import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/core/widgets/product_card.dart';
import 'package:CoffeeBreak/data/product_service.dart';
import 'package:CoffeeBreak/presentation/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vize/vize.dart';

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
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppHeader(txt: 'Меню'),
      body: Column(
        children: [
          // выбор точки.
          fhs(5),
          Padding(
            padding: ps(h: 20),
            child: Container(
              padding: po(l: 15, r: 8),
              height: 55,
              decoration: BoxDecoration(
                color: AppColor.gray.withOpacity(0.3),
                borderRadius: .all(Radius.circular(15.r)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    children: [
                      Text(
                        'ул. Чкалова, д. 32',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: .w400,
                          color: Colors.black,
                          height: 1.34,
                        ),
                      ),
                      Text(
                        'Сургут',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: .w500,
                          color: Colors.grey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit, color: AppColor.navbar,)
                  ),
                ],
              ),
            ),
          ),
          fhs(20),

          // каталог кофе
          Align(
            alignment: .bottomCenter,
            child: Container(
              padding: pa(20),
              height: h(100),
              width: w(100),
              decoration: BoxDecoration(
                color: AppColor.navbar,
                borderRadius: .only(
                  topLeft: .circular(25.r),
                  topRight: .circular(25.r),
                ),
              ),
              child: FutureBuilder(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final products = snapshot.data!;
                  return GridView.builder(
                    padding: po(b: 240),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
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
        ],
      ),
    );
  }
}
