import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/auth.dart';

class Startscreen extends ConsumerStatefulWidget {
  const Startscreen({super.key});

  @override
  ConsumerState<Startscreen> createState() => _StartscreenState();
}

class _StartscreenState extends ConsumerState<Startscreen> {
  @override
  void initState() {
    super.initState();
  }

  void _openLoginOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.white.withOpacity(0),
        elevation: 0,
        builder: (ctx) {
          return AuthScreen();
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Image.asset(
          "assets/images/image.jpg",
          fit: BoxFit.cover,
          height: double.infinity,
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 25, 27, 44),
        ),
        child: InkWell(
          onTap: () => _openLoginOverlay(),
          child: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                Text('login', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
