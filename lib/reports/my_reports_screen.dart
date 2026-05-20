import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'report_details_screen.dart';
import '../settings/account_settings_screen.dart';
import '../reports/widgets/custom_bottom_navbar.dart';
import '../core/theme/theme_notifier.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/viewmodels/report_viewmodel.dart';
import '../domain/models/report.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Submitted', 'In Progress', 'Resolved'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthViewModel>().currentUser;
      if (user != null) {
        context.read<ReportViewModel>().loadUserReports(user.id);
      }
    });
  }

  Color _statusColor(String status, bool isDark) {
    switch (status.toUpperCase()) {
      case 'IN PROGRESS': return isDark ? const Color(0xFF2ECC71) : const Color(0xFF4A90D9);
      case 'RESOLVED': return const Color(0xFF5AAA6A);
      default: return const Color(0xFFF55858);
    }
  }

  Color _getFilterColor(String filter, bool isDark, Color primary) {
    if (filter == 'All') return primary;

    return _statusColor(filter.toUpperCase(), isDark);
  }

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'IN PROGRESS': return Icons.sync;
      case 'RESOLVED': return Icons.check_circle_outline;
      default: return Icons.schedule;
    }
  }

  List<Report> _filteredReports(List<Report> reports) {
    if (_selectedFilter == 'All') return reports;
    return reports.where((r) {
      final status = r.status.toUpperCase();
      if (_selectedFilter == 'Submitted') return status == 'SUBMITTED' || status == 'PENDING';
      if (_selectedFilter == 'In Progress') return status == 'IN PROGRESS';
      if (_selectedFilter == 'Resolved') return status == 'RESOLVED';
      return true;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF132030) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3A1E);
    final subText = isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);

    final reportViewModel = context.watch<ReportViewModel>();
    final reports = reportViewModel.userReports;
    final filtered = _filteredReports(reports);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('phero.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary, letterSpacing: 0.5)),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('My Reports', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF2ECC71) : textColor)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                    child: Text('${reports.length} Total', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Track your impact in the community', style: TextStyle(fontSize: 12, color: subText)),
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isActive = _selectedFilter == filter;
                  final activeColor = _getFilterColor(filter, isDark, primary);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isActive ? activeColor : subText.withValues(alpha: 0.4), width: 1.5),
                      ),
                      child: Text(filter, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? (isDark ? Colors.black : Colors.white) : subText)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            Expanded(
              child: reportViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? Center(child: Text('No reports found', style: TextStyle(color: subText)))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, index) => _buildReportCard(filtered[index], isDark, cardBg, textColor, subText),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildReportCard(Report report, bool isDark, Color cardBg, Color textColor, Color subText) {
    final statusColor = _statusColor(report.status, isDark);
    final statusIcon = _statusIcon(report.status);
    final dateStr = '${report.timestamp.day}/${report.timestamp.month}/${report.timestamp.year}';
    final shortId = report.id.length > 8 ? 'REP-${report.id.substring(0, 8).toUpperCase()}' : 'REP-${report.id.toUpperCase()}';

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
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              child: SizedBox(
                width: 80, height: 85,
                child: report.mediaPath != null && report.mediaPath!.isNotEmpty
                    ? Image.network(
                        report.mediaPath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.withValues(alpha: 0.3),
                          child: Icon(Icons.broken_image_outlined, color: Colors.white.withValues(alpha: 0.4), size: 28),
                        ),
                      )
                    : Container(
                        color: Colors.blueGrey.withValues(alpha: isDark ? 0.5 : 0.3),
                        child: Icon(Icons.image_outlined, color: Colors.white.withValues(alpha: 0.4), size: 28),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            report.title,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(shortId, style: TextStyle(fontSize: 10, color: subText)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${report.latitude.toStringAsFixed(4)}° N, ${report.longitude.toStringAsFixed(4)}° W',
                      style: TextStyle(fontSize: 12, color: subText),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.calendar_today_outlined, size: 11, color: subText),
                          const SizedBox(width: 4),
                          Text(dateStr, style: TextStyle(fontSize: 11, color: subText)),
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, size: 11, color: statusColor),
                                const SizedBox(width: 4),
                                Text(
                                  report.status.toUpperCase(),
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}