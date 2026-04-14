import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/data/auth_service.dart';
import 'package:CoffeeBreak/presentation/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  Future<void> _signOut() async { // todo: спросить почему это не находится в auth_service.dart. и про другие функции: можно ли их закинуть куда-то или нет.
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppHeader(
        txt: 'Профиль',
        actions: [
          GestureDetector(
            onTap: _signOut,
            child: SvgPicture.asset('assets/icons/exit.svg'),
          ),
        ],
      ),
      // todo: доделать профиль, а то ты ленивый какой-то..
    );
  }
}