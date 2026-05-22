import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_button.dart';
import 'package:CoffeeBreak/presentation/main_screen.dart';
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final int total;

  const OrderSuccessScreen({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColor.green2,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColor.green1,
                size: 64,
              ),
            ),
            const SizedBox(height: 32),
            Text('Заказ оформлен!', style: TxtStyle.m18),
            const SizedBox(height: 12),
            Text(
              'Ваш заказ на сумму $total ₽ успешно принят.',
              style: TxtStyle.m14(color: AppColor.description),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            AppButton(
              text: 'Вернуться в меню',
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
                    (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
