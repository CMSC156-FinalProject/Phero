import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PheroApp());
}

class PheroApp extends StatefulWidget {
  const PheroApp({super.key});

  @override
  State<PheroApp> createState() => _PheroAppState();
}

class _PheroAppState extends State<PheroApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(isDark: isDark, onToggle: toggleTheme),
    );
  }
}