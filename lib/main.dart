import 'package:CoffeeBreak/core/constant/supabase_config.dart';
import 'package:CoffeeBreak/presentation/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();

  await Supabase.initialize(
    url: SupabaseCFG.url,
    anonKey: SupabaseCFG.anonKey,
    authOptions: FlutterAuthClientOptions(),
  );
  binding.allowFirstFrame();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Vize.init(context, figmaHeight: 812, figmaWidth: 375);    // init vize
    return MaterialApp(
      debugShowCheckedModeBanner: false,                      // hide debug
      title: 'Coffee Break',
      home: AuthGate(),
    );
  }
}
