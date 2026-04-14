import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_button.dart';
import 'package:CoffeeBreak/data/auth_service.dart';
import 'package:CoffeeBreak/presentation/auth/forgot_password_screen.dart';
import 'package:CoffeeBreak/presentation/auth/register_screen.dart';
import 'package:CoffeeBreak/presentation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _pwrdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _pwrdController.dispose();
    super.dispose();
  }

  Future<void> _log() async {
    setState(() => _isLoading = true);
    try {
      await _authService.logIn(
        _emailController.text.trim(),
        _pwrdController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: AppColor.gray.withOpacity(0.45),
      border: OutlineInputBorder(
        borderSide: .none,
        borderRadius: .circular(15),
      ),
      hintText: hint,
      hintStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColor.description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: .all(28),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: h * 0.1),
            Text('Ваш кофе\nскучал по вам', style: TxtStyle.reg30),
            SizedBox(height: h * 0.03),

            TextField( // email
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('user@email.com'),
            ),
            SizedBox(height: 20),

            TextField( // password
              controller: _pwrdController,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: _inputDecoration('Пароль'),
            ),
            SizedBox(height: 10),

            Align(
              alignment: .centerRight,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                ),
                child: Text(
                  'Забыли пароль?',
                  style: TxtStyle.m14(color: AppColor.description),
                ),
              ),
            ),

            Spacer(),

            AppButton(
              text: 'Войти',
              onTap: _isLoading ? () {} : _log,
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: .center,
              children: [
                const Text('Нет аккаунта? '),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  ),
                  child: Text(
                    'Зарегистрируйтесь',
                    style: TxtStyle.m14(color: AppColor.main),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.01),
          ],
        ),
      ),
    );
  }
}