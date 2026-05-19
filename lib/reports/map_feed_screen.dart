import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'report_details_screen.dart';
import '../settings/account_settings_screen.dart';
import '../reports/widgets/custom_bottom_navbar.dart';
import '../core/theme/theme_notifier.dart';
import '../presentation/viewmodels/report_viewmodel.dart';
import '../domain/models/report.dart';

class MapFeedScreen extends StatefulWidget {
  const MapFeedScreen({super.key});

  @override
  State<MapFeedScreen> createState() => _MapFeedScreenState();
}

class _MapFeedScreenState extends State<MapFeedScreen> {
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportViewModel>().loadReports();
    });
  }

  Color _statusColor(String status, bool isDark) {
    switch (status.toUpperCase()) {
      case 'IN PROGRESS':
        return isDark ? const Color(0xFF2ECC71) : const Color(0xFF4A90D9);
      case 'RESOLVED':
        return const Color(0xFF7A9A6A);
      default:
        return isDark ? const Color(0xFF2ECC71) : const Color(0xFF5C6E3E);
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

    final reportViewModel = context.watch<ReportViewModel>();
    final reports = reportViewModel.reports;

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
              child: reportViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : reports.isEmpty
                      ? Center(child: Text('No reports found', style: TextStyle(color: subText)))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: reports.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final report = reports[index];
                            return _buildIssueCard(report, isDark, cardBg, textColor, subText);
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

  Widget _buildIssueCard(Report report, bool isDark, Color cardBg, Color textColor, Color subText) {
    final statusColor = _statusColor(report.status, isDark);
    final timeStr = '${report.timestamp.day}/${report.timestamp.month}/${report.timestamp.year}';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportDetailsScreen(
              report: report,
              isDark: isDark,
            ),
          ),
        );
      },
      child: Container(
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
                  Text(report.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor)),
                  const SizedBox(height: 2),
                  Text('${report.latitude.toStringAsFixed(4)}° N, ${report.longitude.toStringAsFixed(4)}° W', style: TextStyle(fontSize: 12, color: subText)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeStr, style: TextStyle(fontSize: 11, color: subText)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    report.status.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}