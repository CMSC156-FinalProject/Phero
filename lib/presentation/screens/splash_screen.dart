import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
      body: Center(
        child: Image.asset(
          isDark
              ? 'assets/images/logo_phero_dark.png'
              : 'assets/images/logo_phero_light.png',
          width: 150,
        ),
      ),
    );
  }
}