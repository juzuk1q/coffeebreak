import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_button.dart';
import 'package:CoffeeBreak/data/auth_service.dart';
import 'package:CoffeeBreak/presentation/auth/login_screen.dart';
import 'package:CoffeeBreak/presentation/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwrdController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isSecure1 = true;
  bool _isSecure2 = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pwrdController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _reg() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.reg(
        _emailController.text.trim(),
        _pwrdController.text,
        _nameController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OTPScreen(email: _emailController.text.trim()),
        ),
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
        borderRadius: .circular(15.r),
      ),
      hintText: hint,
      hintStyle: GoogleFonts.roboto(
        fontSize: 16.ts,
        fontWeight: FontWeight.w400,
        color: AppColor.description,
      ),
    );
  }

  Widget _eyeIcon(bool isSecure, VoidCallback onTap) {
    return Padding(
      padding: po(t: 15, r: 20, b: 15),
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          isSecure ? 'assets/icons/visible.svg' : 'assets/icons/hidden.svg',
          width: 30.fw,
          height: 20.fh,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: .all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              hs(1),
              Text('Ваш кофе\nначинается здесь', style: TxtStyle.reg30),
              hs(3),

              // Имя
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Имя'),
                validator: (v) => (v == null || v.isEmpty) ? 'Введите ваше имя' : null,
              ),
              fhs(20),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: .emailAddress,
                decoration: _inputDecoration('user@email.com'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Введите email';
                  if (!v.contains('@')) return 'Некорректный email';
                  return null;
                },
              ),
              fhs(20),

              // Пароль
              TextFormField(
                controller: _pwrdController,
                obscureText: _isSecure1,
                obscuringCharacter: '*',
                autovalidateMode: .onUserInteraction,
                decoration: _inputDecoration('Пароль').copyWith(
                  suffixIcon: _eyeIcon(_isSecure1, () => setState(() => _isSecure1 = !_isSecure1)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Введите пароль';
                  if (v.length < 8) return 'Минимум 8 символов';
                  return null;
                },
              ),
              fhs(20),

              // Подтверждение пароля
              TextFormField(
                controller: _confirmController,
                obscureText: _isSecure2,
                obscuringCharacter: '*',
                autovalidateMode: .onUserInteraction,
                decoration: _inputDecoration('Подтверждение пароля').copyWith(
                  suffixIcon: _eyeIcon(_isSecure2, () => setState(() => _isSecure2 = !_isSecure2)),
                ),
                validator: (v) => v != _pwrdController.text ? 'Пароли не совпадают' : null,
              ),

              fhs(200),

              AppButton(
                text: 'Зарегистрироваться',
                onTap: _isLoading ? () {} : _reg,
              ),
              fhs(20),

              Row(
                mainAxisAlignment: .center,
                children: [
                  Text('Есть аккаунт? '),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    ),
                    child: Text('Войти', style: TxtStyle.m14(color: AppColor.main)),
                  ),
                ],
              ),
              hs(1),
            ],
          ),
        ),
      ),
    );
  }
}