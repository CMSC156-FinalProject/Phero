import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'presentation/screens/counter_screen.dart';

void main() {
  locator.setup();
  runApp(const PheroApp());
}

class PheroApp extends StatelessWidget {
  const PheroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phero',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CounterScreen(),
    );
  }
}
