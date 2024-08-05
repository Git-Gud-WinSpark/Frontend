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
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['GEMINI']!, enableDebugging: true);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool preferenceSet = ref.watch(preferenceProvider).isNotEmpty;
    bool isLogin = ref.watch(loginProvider);
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8476)),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 9, 13, 86),
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 5, 7, 44),
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
