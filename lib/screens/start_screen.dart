import 'package:flutter/material.dart';
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _openLoginOverlay();
    // });
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
      body: Center(
        child: Image.asset(
          "assets/images/image.jpg",
          fit: BoxFit.fitHeight,
          height: double.infinity,
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.black12,
        child: InkWell(
          onTap: () => _openLoginOverlay(),
          child: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Icon(
                  Icons.login,
                ),
                Text('login'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
