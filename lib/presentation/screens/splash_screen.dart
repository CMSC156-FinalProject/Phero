import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'report_screen.dart';
import 'map_feed_screen.dart';
import 'emergency_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const SplashScreen({super.key, required this.isDark, required this.onToggle});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EmergencyScreen( //--> change this part to transition
            isDark: widget.isDark,
            onToggle: widget.onToggle,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? const Color(0xFF0D1B2A) : Colors.white,
      body: Stack(
        children: [
          // Top-left rotated logo
          Positioned(
            top: -200,
            left: -200,
            child: Transform.rotate(
              angle: 0.8,
              child: Image.asset(
                widget.isDark
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
                widget.isDark
                    ? 'assets/images/logo_head_dark.png'
                    : 'assets/images/logo_head_light.png',
                width: 500,
                opacity: const AlwaysStoppedAnimation(0.6),
              ),
            ),
          ),

          // Centered logo
          Center(
            child: Image.asset(
              widget.isDark
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