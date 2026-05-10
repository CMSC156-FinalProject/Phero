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
          // Top-left rotated logo
          Positioned(
            top: -200,
            left: -200,
            child: Transform.rotate(
              angle: 0.8,
              child: Image.asset(
                isDark
                    ? 'assets/images/logo_head_dark.png'
                    : 'assets/images/logo_head_light.png',
                width: 500,
                opacity: const AlwaysStoppedAnimation(0.6),
              ),
            ),
          ),

          // Bottom-right rotated logo
          Positioned(
            bottom: -180,
            right: -180,
            child: Transform.rotate(
              angle: -0.8,
              child: Image.asset(
                isDark
                    ? 'assets/images/logo_head_dark.png'
                    : 'assets/images/logo_head_light.png',
                width: 500,
                opacity: const AlwaysStoppedAnimation(0.6),
              ),
            ),
          ),

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