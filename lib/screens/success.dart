import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Successfull login")),
      body: Center(
        child: Text("Successfull login"),
      ),
    );
  }
} 