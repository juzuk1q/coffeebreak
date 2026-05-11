import 'package:CoffeeBreak/presentation/auth/register_screen.dart';
import 'package:CoffeeBreak/presentation/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return MainScreen();
        }
        return RegisterScreen();
      },
    );
  }
}
