import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

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
      actionsPadding: .only(right: 25),
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
          padding: .only(left: 25, right: 5),
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
      padding: .only(left: 25, right: 25, bottom: 15),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: .circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: .symmetric(horizontal: 30),
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
              height: 28,
              width: 28,
              colorFilter: .mode(color, .srcIn),
            ),
            SizedBox(height: 4),
            Text(
              txt,
              style: GoogleFonts.roboto(
                fontSize: 10,
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