// main.dart
import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';

void main() {
  locator.setup();
  runApp(const PheroApp());
}

class PheroApp extends StatefulWidget {
  const PheroApp({super.key});

  @override
  State<PheroApp> createState() => _PheroAppState();
}

class _PheroAppState extends State<PheroApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const SplashScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool get _isDark => widget.themeMode == ThemeMode.dark;

  void _navigateToNext() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const NextScreen(),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double screenWidth = 390;
    const double screenHeight = 844;

    // 👇 JUST SWAP THESE WITH YOUR ACTUAL IMAGE PATHS
    const String lightImage = 'assets/images/splash_light.png';
    const String darkImage = 'assets/images/splash_dark.png';

    return GestureDetector(
      onTap: widget.onToggleTheme,
      onDoubleTap: _navigateToNext,
      child: Scaffold(
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: SizedBox(
              key: ValueKey(_isDark),
              width: screenWidth,
              height: screenHeight,
              child: Image.asset(
                _isDark ? darkImage : lightImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00C896)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to Phero.',
          style: TextStyle(
            color: Color(0xFF00C896),
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}