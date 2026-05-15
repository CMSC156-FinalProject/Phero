import 'dart:math';
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
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _greenRadius; // radius in 0.0–1.0 of full coverage

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

    // Goes from 0 → 1 where 1 = fully covers screen
    _greenRadius = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => WelcomeScreen(
              isDark: widget.isDark,
              onToggle: widget.onToggle,
            ),
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
    final bg = widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final green = widget.isDark
        ? const Color(0xFF2ECC71)
        : const Color(0xFF3B4A2F);

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
                // ── Decorative top-left logo ──────────────────────────────
                if (_logoFade.value > 0)
                  Positioned(
                    top: -200,
                    left: -200,
                    child: Opacity(
                      opacity: (_logoFade.value * 0.6).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: 0.8,
                        child: Image.asset(
                          widget.isDark
                              ? 'assets/images/logo_head_dark.png'
                              : 'assets/images/logo_head_light.png',
                          width: 500,
                        ),
                      ),
                    ),
                  ),

                // ── Decorative bottom-right logo ──────────────────────────
                if (_logoFade.value > 0)
                  Positioned(
                    bottom: -180,
                    right: -180,
                    child: Opacity(
                      opacity: (_logoFade.value * 0.6).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: -0.8,
                        child: Image.asset(
                          widget.isDark
                              ? 'assets/images/logo_head_dark.png'
                              : 'assets/images/logo_head_light.png',
                          width: 500,
                        ),
                      ),
                    ),
                  ),

                // ── Green flood — CustomPainter draws circle that fills screen ──
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GreenFloodPainter(
                      progress: _greenRadius.value,
                      color: green,
                    ),
                  ),
                ),

                // ── Center logo — zooms toward user ───────────────────────
                if (_logoFade.value > 0)
                  Center(
                    child: Opacity(
                      opacity: _logoFade.value.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Image.asset(
                          widget.isDark
                              ? 'assets/images/logo_phero_dark.png'
                              : 'assets/images/logo_phero_light.png',
                          width: 230,
                        ),
                      ),
                    ),
                  ),

                // ── Moon / Sun toggle — always on top ─────────────────────
                Positioned(
                  top: 15,
                  right: 15,
                  child: IconButton(
                    icon: Icon(
                      widget.isDark
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                      color: widget.isDark
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFF5C6E3E),
                      size: 28,
                    ),
                    onPressed: widget.onToggle,
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

// Draws a circle from the center that grows to cover the entire canvas
class _GreenFloodPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0
  final Color color;

  _GreenFloodPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    // Max radius = distance from center to farthest corner
    final maxRadius = sqrt(
      pow(size.width / 2, 2) + pow(size.height / 2, 2),
    ) * 1.05; // tiny extra to eliminate edge gap

    final paint = Paint()..color = color;
    canvas.drawCircle(center, maxRadius * progress, paint);
  }

  @override
  bool shouldRepaint(_GreenFloodPainter old) => old.progress != progress;
}