import 'package:CoffeeBreak/core/constant/supabase_config.dart';
import 'package:CoffeeBreak/presentation/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();                                   // w8ing for flutter to init

  await Supabase.initialize(
    url: SupabaseCFG.url,                                      // supabase cfg
    anonKey: SupabaseCFG.anonKey,                              // supabase cfg
    authOptions: FlutterAuthClientOptions(),                   // supabase cfg
  );
  binding.allowFirstFrame();                                   // allow flutter to init
  runApp(MyApp());                                             // run app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Vize.init(context, figmaHeight: 812, figmaWidth: 375);    // init vize
    return MaterialApp(
      debugShowCheckedModeBanner: false,                      // hide debug
      title: 'Coffee Break',                                  // idk where ts use
      home: AuthGate(),                                       // 1st screen
    );
  }
}
