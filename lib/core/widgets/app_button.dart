import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';

// основная зелёная кнопка
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final String? icon;
  final String? price;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.main,
          foregroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(30),
          ),
          padding: .symmetric(horizontal: 25),
        ),
        child: Row(
          children: [
            if (icon != null)
              SvgPicture.asset(
                icon!,
                width: 25,
                colorFilter: .mode(AppColor.white, .srcIn),
              ),
            Expanded(
              child: Text(
                text,
                style: TxtStyle.m16,
                textAlign: price != null ? .left : .center,
                softWrap: false,
              ),
            ),
            if (price != null)
              Text('${price!}₽', style: TxtStyle.sb16),
            if (icon != null)
              SizedBox(width: 25),
          ],
        ),
      ),
    );
  }
}

// кнопка на OrderScreen
class AppButton2 extends StatelessWidget {
  final String txt;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double spacing;

  const AppButton2({
    super.key,
    required this.txt,
    required this.onTap,
    this.backgroundColor = AppColor.white,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor: backgroundColor,
          foregroundColor: AppColor.text,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(15),
          ),
          padding: .symmetric(horizontal: spacing),
        ),
        child: Row(
          children: [
            Text(txt, style: TxtStyle.m14(color: AppColor.text)),
            Spacer(),
            SvgPicture.asset('assets/icons/arrowRight.svg', height: 18, width: 18),
          ],
        ),
      ),
    );
  }
}