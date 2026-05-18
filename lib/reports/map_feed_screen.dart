import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'report_screen.dart';
import 'my_reports_screen.dart';
import '../emergency/emergency_screen.dart';
import '../settings/account_settings_screen.dart';
import '../reports/widgets/custom_bottom_navbar.dart';
import '../core/theme/theme_notifier.dart';

class MapFeedScreen extends StatefulWidget {
  const MapFeedScreen({super.key});

  @override
  State<MapFeedScreen> createState() => _MapFeedScreenState();
}

class _MapFeedScreenState extends State<MapFeedScreen> {
  bool _isListView = true;

  final List<Map<String, dynamic>> _issues = [
    {'title': 'Pothole', 'address': '123 Main St', 'time': '2h ago', 'status': 'REPORTED'},
    {'title': 'Broken Streetlight', 'address': '45 Oak Ave', 'time': '5h ago', 'status': 'IN PROGRESS'},
    {'title': 'Vandalism', 'address': 'Central Park', 'time': '1d ago', 'status': 'RESOLVED'},
    {'title': 'Fallen Tree', 'address': '90 Pine Rd', 'time': '3h ago', 'status': 'REPORTED'},
  ];

  Color _statusColor(String status, bool isDark) {
    switch (status) {
      case 'IN PROGRESS':
        return isDark ? const Color(0xFF2ECC71) : const Color(0xFF4A90D9);
      case 'RESOLVED':
        return const Color(0xFF7A9A6A);
      default:
        return isDark ? const Color(0xFF2ECC71) : const Color(0xFF5C6E3E);
    }
  }

  void _onTabTapped(int index) {
    if (index == 0) return;
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyReportsScreen()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
    final textColor = isDark ? Colors.white : const Color(0xFF2C3A1E);
    final subText = isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'phero.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                      child: Icon(Icons.person, color: isDark ? Colors.black : Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Map / List Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                height: 40,
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    _buildToggleBtn('Map', Icons.map_outlined, !_isListView, isDark, primary, subText),
                    _buildToggleBtn('List', Icons.list, _isListView, isDark, primary, subText),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _issues.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final issue = _issues[index];
                  return _buildIssueCard(issue, isDark, cardBg, textColor, subText);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildToggleBtn(String label, IconData icon, bool active, bool isDark, Color primary, Color subText) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isListView = label == 'List'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: active ? (isDark ? Colors.black : Colors.white) : subText),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? (isDark ? Colors.black : Colors.white) : subText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueCard(Map<String, dynamic> issue, bool isDark, Color cardBg, Color textColor, Color subText) {
    final statusColor = _statusColor(issue['status'], isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: subText.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Icon(Icons.info_outline, size: 18, color: subText),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(issue['title'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor)),
                const SizedBox(height: 2),
                Text(issue['address'], style: TextStyle(fontSize: 12, color: subText)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(issue['time'], style: TextStyle(fontSize: 11, color: subText)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  issue['status'],
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Color bg, Color primary, Color subText) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: subText.withValues(alpha: 0.15), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.map_outlined, 'Map Feed', 0, primary, subText),
              _buildNavItem(Icons.camera_alt_outlined, 'Report', 1, primary, subText),
              _buildNavItem(Icons.assignment_outlined, 'My Reports', 2, primary, subText),
              _buildNavItem(Icons.phone_outlined, 'Emergency', 3, primary, subText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, Color primary, Color subText) {
    final isActive = index == 0;
    final color = isActive ? primary : subText;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }
}