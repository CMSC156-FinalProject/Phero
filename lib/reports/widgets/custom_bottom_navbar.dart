import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../map_feed_screen.dart';
import '../report_screen.dart';
import '../my_reports_screen.dart';
import '/emergency/emergency_screen.dart';
import '../../core/theme/theme_notifier.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Do nothing if we are already on this tab

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const MapFeedScreen();
        break;
      case 1:
        nextScreen = const ReportScreen();
        break;
      case 2:
        nextScreen = const MyReportsScreen();
        break;
      case 3:
        nextScreen = const EmergencyScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => nextScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final subText = isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(color: subText.withValues(alpha: 0.15), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.map_outlined, 'Map Feed', 0, primary, subText),
              _buildNavItem(context, Icons.camera_alt_outlined, 'Report', 1, primary, subText),
              _buildNavItem(context, Icons.assignment_outlined, 'My Reports', 2, primary, subText),
              _buildNavItem(context, Icons.phone_outlined, 'Emergency', 3, primary, subText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, Color primary, Color subText) {
    final isActive = index == currentIndex;
    final color = isActive ? primary : subText;
    
    return GestureDetector(
      onTap: () => _onTabTapped(context, index),
      behavior: HitTestBehavior.opaque, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}