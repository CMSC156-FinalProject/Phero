import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../settings/account_settings_screen.dart';
import '../reports/map_feed_screen.dart';
import '../reports/report_screen.dart';
import '../reports/my_reports_screen.dart';
import '../core/theme/theme_notifier.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  static const List<Map<String, dynamic>> _hotlines = [
    {'label': 'Police Emergency', 'number': '911', 'icon': Icons.local_police_outlined, 'iconColor': Color(0xFF4A90D9), 'iconBg': Color(0xFFE8F0FB), 'iconBgDark': Color(0xFF1A2A3A)},
    {'label': 'Fire Department', 'number': '911', 'icon': Icons.local_fire_department_outlined, 'iconColor': Color(0xFFE8821A), 'iconBg': Color(0xFFFDF0E0), 'iconBgDark': Color(0xFF2A1A0A)},
    {'label': 'Medical Emergency', 'number': '911', 'icon': Icons.monitor_heart_outlined, 'iconColor': Color(0xFFE84A4A), 'iconBg': Color(0xFFFDE8E8), 'iconBgDark': Color(0xFF2A0A0A)},
    {'label': 'Non-Emergency Police', 'number': '311', 'icon': Icons.phone_outlined, 'iconColor': Color(0xFF6A7A8A), 'iconBg': Color(0xFFEEF0F2), 'iconBgDark': Color(0xFF1A2030)},
    {'label': 'Poison Control', 'number': '1-800-222-1222', 'icon': Icons.medical_services_outlined, 'iconColor': Color(0xFF9B4AD4), 'iconBg': Color(0xFFF2E8FC), 'iconBgDark': Color(0xFF1E0A2A)},
  ];

  Future<void> _call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _onTabTapped(BuildContext context, int index) {
    if (index == 3) return;
    if (index == 0) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MapFeedScreen()));}
    else if (index == 1) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReportScreen()));}
    else if (index == 2) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyReportsScreen()));}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subText = isDark ? const Color(0xFF8A9BB0) : const Color(0xFF8A9070);

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: _buildBottomNav(context, bg, primary, subText),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('phero.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSettingsScreen())),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                      child: Icon(Icons.person, color: isDark ? Colors.black : Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(children: [
                            Icon(Icons.phone, color: Colors.red, size: 22),
                            SizedBox(width: 8),
                            Text('Emergency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                          ]),
                          const SizedBox(height: 8),
                          Text(
                            'If you are experiencing a life-threatening emergency, call 911 immediately. Do not use this app to report active crimes or emergencies in progress.',
                            style: TextStyle(fontSize: 13, color: subText, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    ..._hotlines.map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          children: [
                            Container(
                              width: 42, height: 42,
                              decoration: BoxDecoration(
                                color: isDark ? h['iconBgDark'] as Color : h['iconBg'] as Color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(h['icon'] as IconData, color: h['iconColor'] as Color, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(h['label'] as String, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
                                  const SizedBox(height: 2),
                                  Text(h['number'] as String, style: TextStyle(fontSize: 13, color: subText)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _call(h['number'] as String),
                              child: Container(
                                width: 42, height: 42,
                                decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle),
                                child: const Icon(Icons.phone, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, Color bg, Color primary, Color subText) {
    return Container(
      decoration: BoxDecoration(color: bg, border: Border(top: BorderSide(color: subText.withValues(alpha: 0.15), width: 1))),
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
    final isActive = index == 3;
    final color = isActive ? primary : subText;
    return GestureDetector(
      onTap: () => _onTabTapped(context, index),
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