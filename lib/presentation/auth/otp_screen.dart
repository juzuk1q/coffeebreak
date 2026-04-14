import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_button.dart';
import 'package:CoffeeBreak/data/auth_service.dart';
import 'package:CoffeeBreak/presentation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _authService = AuthService();
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  bool _showError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final otp = _pinController.text.trim();

    if (otp.length != 6) {
      setState(() => _showError = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.verifyOtp(
        email: widget.email,
        token: otp,
      );

      if (!mounted) return;

      if (response.session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      } else {
        setState(() => _showError = true);
      }
    } catch (e) {
      debugPrint('OTP error: $e');
      if (mounted) setState(() => _showError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    final pinTheme = PinTheme(
      width: 49,
      height: 57,
      textStyle: GoogleFonts.roboto(fontSize: 24, color: AppColor.text),
      decoration: BoxDecoration(
        color: AppColor.gray.withOpacity(0.45),
        borderRadius: .circular(15),
        border: .all(color: AppColor.gray.withOpacity(0.45)),
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: .all(28),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: h * 0.1),
            Text('Введите код\nподтверждения', style: TxtStyle.reg30),
            SizedBox(height: 15),
            Text(
              'Введите 6-ти значный код ниже',
              style: TxtStyle.m14(color: AppColor.description),
            ),
            SizedBox(height: h * 0.09),

            Center(
              child: Column(
                children: [
                  Pinput(
                    length: 6,
                    controller: _pinController,
                    focusNode: _focusNode,
                    defaultPinTheme: pinTheme,
                    focusedPinTheme: pinTheme.copyWith(
                      height: 60,
                      width: 70,
                      decoration: pinTheme.decoration!.copyWith(
                        border: .all(color: AppColor.main),
                      ),
                    ),
                    errorPinTheme: pinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: AppColor.red2,
                        borderRadius: .circular(15),
                        border: .all(color: AppColor.red1),
                      ),
                    ),
                    onCompleted: (_) => _verify(),
                  ),
                  if (_showError) ...[
                    SizedBox(height: 10),
                    Text(
                      'Неверный код, попробуйте снова',
                      style: TxtStyle.m14(color: AppColor.red1),
                    ),
                  ],
                ],
              ),
            ),

            Spacer(),
            AppButton(
              text: 'Подтвердить',
              onTap: _isLoading ? () {} : _verify,
            ),
            SizedBox(height: h * 0.01),
          ],
        ),
      ),
    );
  }
}