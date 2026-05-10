import 'package:flutter/material.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(const PheroApp());
}

class PheroApp extends StatelessWidget {
  const PheroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}