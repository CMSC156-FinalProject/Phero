import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
      body: Stack(
        children: [
          // Toggle button top right
          Positioned(
            top: 15,
            right: 15,
            child: IconButton(
              icon: Icon(
                isDark ? Icons.wb_sunny : Icons.nightlight_round,
                color: isDark ? const Color(0xFF2ECC71) : const Color(0xFF5C6E3E),
                size: 28,
              ),
              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
              },
            ),
          ),

          // Centered logo
          Center(
            child: Image.asset(
              isDark
                  ? 'assets/images/logo_phero_dark.png'
                  : 'assets/images/logo_phero_light.png',
              width: 230,
            ),
          ),
        ],
      ),
    );
  }
}