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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Logo zooms from normal size to huge (fills screen)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 30.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInExpo),
    );

    // Background fades out as logo zooms in
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Wait 1.5s then trigger zoom animation, then navigate
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _controller.forward().then((_) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MapFeedScreen(
              isDark: widget.isDark,
              onToggle: widget.onToggle,
            ),
            transitionDuration: Duration.zero,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Decorative logos fade out
              FadeTransition(
                opacity: _fadeAnimation,
                child: Stack(
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
                  ],
                ),
              ),

              // Center logo — zooms to fill screen
              Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.asset(
                    widget.isDark
                        ? 'assets/images/logo_phero_dark.png'
                        : 'assets/images/logo_phero_light.png',
                    width: 230,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}