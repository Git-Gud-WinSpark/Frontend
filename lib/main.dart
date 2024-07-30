import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/login_provider.dart';
import 'package:frontend/provider/preference_provider.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/start_screen.dart';
import 'package:frontend/screens/success.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(ProviderScope(child: new MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preferenceSet = ref.watch(preferenceProvider).isNotEmpty;
    print(preferenceSet);
    bool isLogin = ref.watch(loginProvider);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF8476)),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: isLogin
            ? preferenceSet
                ? ChatScreen()
                : const Success()
            : const Startscreen(),
      ),
    );
  }
}
