import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_button.dart';
import 'package:CoffeeBreak/data/profile_service.dart';
import 'package:CoffeeBreak/presentation/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

class OrderSuccessScreen extends StatefulWidget {
  final int total;

  const OrderSuccessScreen({
    super.key,
    required this.total,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  final _profileService = ProfileService();
  String _orderNumber = '';
  String _name = 'Пользователь';

  Future<void> _loadOrderNumber() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt('order_number') ?? 0;
    current++;
    await prefs.setInt('order_number', current);
    setState(() {
      _orderNumber = '#${current.toString().padLeft(3, '0')}';
    });
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.getProfile();

    if (profile != null && mounted) {
      setState(() {
        _name = profile['name'] ?? 'Пользователь';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadOrderNumber();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final readyTime = now.add(const Duration(minutes: 10));

    final formattedTime =
        '${readyTime.hour.toString().padLeft(2, '0')}:'
        '${readyTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: pa(28),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Spacer(),
            Container(
              width: 177,
              height: 177,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/success.png'))
              ),
            ),
            SizedBox(height: 8),

            Text(
              'Номер заказа $_orderNumber',
              style: TxtStyle.m18,
            ),

            SizedBox(height: 15),

            Text(
              '$_name, Ваш заказ успешно размещен.',
              style: TxtStyle.m14(color: AppColor.description),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12),

            Text(
              'Заказ будет готов сегодня\n'
                  'к $formattedTime по адресу\n'
                  'г. Сургут, ул. Пушкина, д. 10',
              style: TxtStyle.m14(),
              textAlign: TextAlign.center,
            ),

            Spacer(),

            AppButton(
              text: 'Вернуться в меню',
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => MainScreen(),
                ),
                    (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}