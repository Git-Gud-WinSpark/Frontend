import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/preference_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/screens/preferences.dart';
import 'package:frontend/services/sendPreferences.dart';
import 'package:frontend/widgets/skills.dart';
import 'package:frontend/dummydata/skills.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Success extends ConsumerStatefulWidget {
  const Success({super.key});

  @override
  ConsumerState<Success> createState() => _SuccessState();
}

class _SuccessState extends ConsumerState<Success> {
  @override
  Widget build(BuildContext context) {
  var preferences = ref.read(preferenceProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Center(
          child: Image.asset(
            "assets/images/image.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
          ),
        ),
        Center(
          child: preferences.isEmpty ? Preferences(): Container(),
        ),
      ]),
    );
  }
}
