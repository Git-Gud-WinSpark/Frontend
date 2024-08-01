import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
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
  // Gemini.init(
  //     apiKey: const String.fromEnvironment('apiKey'), enableDebugging: true);
  Gemini.init(
      apiKey: "AIzaSyCRLKnUUvE7TJKz6cwvyTpDQCLx9NBUuSM", enableDebugging: true);
  runApp(ProviderScope(child: new MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preferenceSet = ref.watch(preferenceProvider).isNotEmpty;
    print(preferenceSet);
    bool isLogin = ref.watch(loginProvider);
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF8476)),
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(255, 9, 13, 86),
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: Color.fromARGB(255, 5, 7, 44),
          useMaterial3: true,
        ),
        home: SafeArea(
          child: isLogin
              ? preferenceSet
                  ? ChatScreen()
                  : const Success()
              : const Startscreen(),
        ),
      ),
    );
  }
}
