import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/login_screen.dart';
import '../../reports/map_feed_screen.dart';
import '../../core/theme/theme_notifier.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _greenRadius;

  bool _tapped = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 1.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );

    _logoFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.55, curve: Curves.easeIn),
      ),
    );

    _greenRadius = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        
        final isLoggedIn = FirebaseAuth.instance.currentUser != null;
        final Widget nextScreen = isLoggedIn
            ? const MapFeedScreen()
            : const LoginScreen();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, _, _) => nextScreen,
            transitionDuration: Duration.zero,
          ),
        );
      }
    });
  }

  void _onTap() {
    if (_tapped) return;
    setState(() => _tapped = true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final green = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);

    return GestureDetector(
      onTap: _onTap,
      child: Scaffold(
        backgroundColor: bg,
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                if (_logoFade.value > 0)
                  Positioned(
                    top: -200,
                    left: -200,
                    child: Opacity(
                      opacity: (_logoFade.value * 0.6).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: 0.8,
                        child: Image.asset(
                          isDark
                              ? 'assets/images/logo_head_dark.png'
                              : 'assets/images/logo_head_light.png',
                          width: 500,
                        ),
                      ),
                    ),
                  ),

                if (_logoFade.value > 0)
                  Positioned(
                    bottom: -180,
                    right: -180,
                    child: Opacity(
                      opacity: (_logoFade.value * 0.6).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: -0.8,
                        child: Image.asset(
                          isDark
                              ? 'assets/images/logo_head_dark.png'
                              : 'assets/images/logo_head_light.png',
                          width: 500,
                        ),
                      ),
                    ),
                  ),

                Positioned.fill(
                  child: CustomPaint(
                    painter: _GreenFloodPainter(
                      progress: _greenRadius.value,
                      color: green,
                    ),
                  ),
                ),

                if (_logoFade.value > 0)
                  Center(
                    child: Opacity(
                      opacity: _logoFade.value.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Image.asset(
                          isDark
                              ? 'assets/images/logo_phero_dark.png'
                              : 'assets/images/logo_phero_light.png',
                          width: 230,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  top: 15,
                  right: 15,
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.wb_sunny : Icons.nightlight_round,
                      color: isDark
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFF5C6E3E),
                      size: 28,
                    ),
                    onPressed: () => context.read<ThemeNotifier>().toggle(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GreenFloodPainter extends CustomPainter {
  final double progress;
  final Color color;

  _GreenFloodPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(
      pow(size.width / 2, 2) + pow(size.height / 2, 2),
    ) * 1.05;
    final paint = Paint()..color = color;
    canvas.drawCircle(center, maxRadius * progress, paint);
  }

  @override
  bool shouldRepaint(_GreenFloodPainter old) => old.progress != progress;
}