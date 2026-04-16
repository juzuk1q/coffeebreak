import 'package:CoffeeBreak/presentation/profile/profile_screen.dart';
import 'package:CoffeeBreak/presentation/cart/cart_screen.dart';
import 'package:CoffeeBreak/presentation/home/home_screen.dart';
import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: AppBottom(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}