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
  int _currentIndex = 0;             // 0 - home, 1 - profile, 2 - cart

  final List<Widget> _pages = [
    HomeScreen(),
    ProfileScreen(),
    CartScreen(),
  ];                                 // pages

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }                                  // on tap func

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,    // bg: white
      extendBody: true,                   // extend bottom bar
      body: _pages[_currentIndex],        // current page
      bottomNavigationBar: AppBottom(     // bottom bar
        currentIndex: _currentIndex,      // current index
        onTap: _onItemTapped,             // on tap func
      ),
    );
  }
}