import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

//  верхняя штучка (appbar)
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String txt;
  final bool back;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.txt,
    this.back = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: po(r: 25),
      backgroundColor: AppColor.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(txt, style: TxtStyle.m18),
      leading: back
          ? GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: po(l: 25, r: 5),
          child: SvgPicture.asset('assets/icons/back.svg'),
        ),
      )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

//  основное управление (bottombar)
class AppBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottom({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    ('assets/icons/menu.svg', 'Меню'),
    ('assets/icons/profile.svg', 'Профиль'),
    ('assets/icons/buy.svg', 'Корзина'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: po(l: 25, r: 25, b: 23),
      child: Container(
        height: 65.fh,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: .circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: ps(h: 30),
          child: Row(
            children: _items.indexed.map((e) {
              final (index, (icon, txt)) = e;
              return _NavItem(
                icon: icon,
                txt: txt,
                isActive: currentIndex == index,
                onTap: () => onTap(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

//  элемент на AppBottom
class _NavItem extends StatelessWidget {
  final String icon;
  final String txt;
  final VoidCallback onTap;
  final bool isActive;

  const _NavItem({
    super.key,
    required this.icon,
    required this.txt,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColor.main : AppColor.text;

    return Expanded(
      child: GestureDetector(
        behavior: .opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            SvgPicture.asset(
              icon,
              height: 28.fh,
              width: 28.fw,
              colorFilter: .mode(color, .srcIn),
            ),
            SizedBox(height: 4.fh),
            Text(
              txt,
              style: GoogleFonts.roboto(
                fontSize: 10.ts,
                fontWeight: .w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}