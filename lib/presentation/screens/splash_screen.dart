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
  late Animation<double> _greenScale;

  bool _tapped = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Phase 1: logo zooms toward user
    _logoScale = Tween<double>(begin: 1.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );

    // Logo fades out as it zooms
    _logoFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.55, curve: Curves.easeIn),
      ),
    );

    // Phase 2: green floods screen
    _greenScale = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    final size = MediaQuery.of(context).size;
    final circleDiameter =
        (size.width * size.width + size.height * size.height)
            .clamp(800.0, 4000.0);

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

                // ── Green flood from center ───────────────────────────────
                Align(
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale: _greenScale.value,
                    child: Container(
                      width: circleDiameter,
                      height: circleDiameter,
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFF3B4A2F),
                        shape: BoxShape.circle,
                      ),
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

                // ── Moon / Sun toggle — always on top ────────────────────
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