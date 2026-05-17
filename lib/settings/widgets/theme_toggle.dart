import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_notifier.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () => context.read<ThemeNotifier>().toggle(),
    );
  }
}