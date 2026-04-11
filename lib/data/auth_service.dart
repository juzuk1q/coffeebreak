import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // регистрация
  Future<AuthResponse> reg(String email, String password, String name) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    await _saveSession();
    return response;
  }

  // вход
  Future<AuthResponse> logIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    await _saveSession();
    return response;
  }

  // подтверждение OTP
  Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
  }) async {
    final response = await _client.auth.verifyOTP(
      type: OtpType.email,
      email: email,
      token: token,
    );
    await _saveSession();
    return response;
  }

  // выход
  Future<void> signOut() async {
    await _client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // сохранение сессии
  Future<void> _saveSession() async {
    final session = _client.auth.currentSession;
    if (session == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', session.user.id);
    await prefs.setString('user_email', session.user.email ?? '');
    await prefs.setString('access_token', session.accessToken);
    await prefs.setString('refresh_token', session.refreshToken ?? '');
  }

  // проверка авторизации
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') != null;
  }

  // получить email
  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
}