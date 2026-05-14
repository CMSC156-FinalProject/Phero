import 'package:flutter/material.dart';
import 'report_screen.dart';
import 'my_reports_screen.dart';
import '../../core/di/app_providers.dart';
import '../../domain/models/report_model.dart';

class MapFeedScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const MapFeedScreen({super.key, required this.isDark, required this.onToggle});

  @override
  State<MapFeedScreen> createState() => _MapFeedScreenState();
}

class _MapFeedScreenState extends State<MapFeedScreen> {
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviders.of(context).reportViewModel.fetchAllReports();
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'IN PROGRESS':
        return widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF4A90D9);
      case 'RESOLVED':
        return const Color(0xFF7A9A6A);
      default:
        return widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF5C6E3E);
    }
  }

  Color get _primary => widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
  Color get _bg => widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
  Color get _cardBg => widget.isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
  Color get _textColor => widget.isDark ? Colors.white : const Color(0xFF2C3A1E);
  Color get _subText => widget.isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);

  void _onTabTapped(int index) {
    if (index == 0) return; // already on Map Feed
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReportScreen(isDark: widget.isDark, onToggle: widget.onToggle),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyReportsScreen(isDark: widget.isDark, onToggle: widget.onToggle),
        ),
      );
    }
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
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
                  Row(
                    children: [
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
                ],
              ),
            ),

            // Map / List Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _buildToggleBtn('Map', Icons.map_outlined, !_isListView),
                    _buildToggleBtn('List', Icons.list, _isListView),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Issue List
            Expanded(
              child: ListenableBuilder(
                listenable: AppProviders.of(context).reportViewModel,
                builder: (context, _) {
                  final reportVM = AppProviders.of(context).reportViewModel;
                  
                  if (reportVM.isLoading && reportVM.allReports.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final issues = reportVM.allReports;
                  if (issues.isEmpty) {
                    return Center(
                      child: Text(
                        "No issues reported yet.\nBe the first!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _subText, fontSize: 16),
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: issues.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final issue = issues[index];
                      return _buildIssueCard(issue);
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildToggleBtn(String label, IconData icon, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isListView = label == 'List'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? _primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: active
                    ? (widget.isDark ? Colors.black : Colors.white)
                    : _subText,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active
                      ? (widget.isDark ? Colors.black : Colors.white)
                      : _subText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueCard(ReportModel issue) {
    final statusColor = _statusColor(issue.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _subText.withValues(alpha: 0.4), width: 1.5),
              image: issue.imageUrl != null 
                ? DecorationImage(image: NetworkImage(issue.imageUrl!), fit: BoxFit.cover)
                : null
            ),
            child: issue.imageUrl == null ? Icon(Icons.info_outline, size: 18, color: _subText) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  issue.location,
                  style: TextStyle(fontSize: 12, color: _subText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(issue.createdAt),
                style: TextStyle(fontSize: 11, color: _subText),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  issue.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
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
          top: BorderSide(
            color: _subText.withValues(alpha: 0.15),
            width: 1,
          ),
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
    final isActive = index == 0;
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
            style: TextStyle(fontSize: 10, color: color, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}