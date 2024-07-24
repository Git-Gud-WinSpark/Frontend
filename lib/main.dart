import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/login_provider.dart';
import 'package:frontend/screens/start_screen.dart';
import 'package:frontend/screens/success.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLogin = ref.watch(loginProvider);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF8476)),
        useMaterial3: true,
      ),
      home: isLogin ? const Success() : const Startscreen(),
    );
  }
}
