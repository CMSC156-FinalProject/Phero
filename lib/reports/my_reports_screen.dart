import 'package:flutter/material.dart';
import 'map_feed_screen.dart';
import 'report_screen.dart';

class MyReportsScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const MyReportsScreen({super.key, required this.isDark, required this.onToggle});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Submitted', 'In Progress', 'Resolved'];

  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'Pothole',
      'id': 'REP-1049',
      'address': 'Main St & 4th Ave',
      'date': 'Oct 12, 2023',
      'status': 'RESOLVED',
      'imagePlaceholder': Colors.brown,
    },
    {
      'title': 'Broken Streetlight',
      'id': 'REP-1050',
      'address': 'Parkside Rd',
      'date': 'Oct 14, 2023',
      'status': 'IN PROGRESS',
      'imagePlaceholder': Colors.blueGrey,
    },
    {
      'title': 'Graffiti',
      'id': 'REP-1051',
      'address': 'Community Center',
      'date': 'Today, 9:42 AM',
      'status': 'SUBMITTED',
      'imagePlaceholder': Colors.grey,
    },
  ];

  Color get _primary => widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
  Color get _bg => widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
  Color get _cardBg => widget.isDark ? const Color(0xFF132030) : Colors.white;
  Color get _textColor => widget.isDark ? Colors.white : const Color(0xFF2C3A1E);
  Color get _subText => widget.isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);

  Color _statusColor(String status) {
    switch (status) {
      case 'IN PROGRESS':
        return widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF4A90D9);
      case 'RESOLVED':
        return const Color(0xFF5AAA6A);
      default:
        return const Color(0xFFE6A817);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'IN PROGRESS':
        return Icons.sync;
      case 'RESOLVED':
        return Icons.check_circle_outline;
      default:
        return Icons.schedule;
    }
  }

  List<Map<String, dynamic>> get _filteredReports {
    if (_selectedFilter == 'All') return _reports;
    return _reports.where((r) {
      final status = r['status'] as String;
      if (_selectedFilter == 'Submitted') return status == 'SUBMITTED';
      if (_selectedFilter == 'In Progress') return status == 'IN PROGRESS';
      if (_selectedFilter == 'Resolved') return status == 'RESOLVED';
      return true;
    }).toList();
  }

  void _onTabTapped(int index) {
    if (index == 2) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MapFeedScreen(isDark: widget.isDark, onToggle: widget.onToggle),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReportScreen(isDark: widget.isDark, onToggle: widget.onToggle),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
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
                      color: _primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'US',
                          style: TextStyle(
                            color: widget.isDark ? Colors.black : Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Title & count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'My Reports',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? const Color(0xFF2ECC71) : _textColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_reports.length} Total',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Track your impact in the community',
                  style: TextStyle(fontSize: 12, color: _subText),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Filter chips
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
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? _primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? _primary : _subText.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? (widget.isDark ? Colors.black : Colors.white)
                              : _subText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Report cards
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredReports.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final report = _filteredReports[index];
                  return _buildReportCard(report);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final statusColor = _statusColor(report['status']);
    final statusIcon = _statusIcon(report['status']);

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: widget.isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: Container(
              width: 80,
              height: 85,
              color: (report['imagePlaceholder'] as Color).withValues(alpha: 
                widget.isDark ? 0.5 : 0.3,
              ),
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.white.withValues(alpha: 0.4),
                size: 28,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report['title'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          report['id'],
                          style: TextStyle(fontSize: 10, color: _subText),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    report['address'],
                    style: TextStyle(fontSize: 12, color: _subText),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 11, color: _subText),
                          const SizedBox(width: 4),
                          Text(
                            report['date'],
                            style: TextStyle(fontSize: 11, color: _subText),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 11, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                report['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
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
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        border: Border(
          top: BorderSide(color: _subText.withValues(alpha: 0.15), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.map_outlined, 'Map Feed', 0),
              _buildNavItem(Icons.camera_alt_outlined, 'Report', 1),
              _buildNavItem(Icons.assignment_outlined, 'My Reports', 2),
              _buildNavItem(Icons.phone_outlined, 'Emergency', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = index == 2;
    final color = isActive ? _primary : _subText;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
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
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}