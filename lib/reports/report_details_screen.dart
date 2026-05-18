import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  final bool isDark;

  const ReportDetailsScreen({
    super.key,
    required this.report,
    required this.isDark,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'IN PROGRESS': return isDark ? const Color(0xFF2ECC71) : const Color(0xFF4A90D9);
      case 'RESOLVED': return const Color(0xFF5AAA6A);
      default: return const Color(0xFFF55858);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
    final textColor = isDark ? Colors.white : const Color(0xFF2C3A1E);
    final subText = isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Report Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderInfo(primary, textColor, subText),
            Container(height: 8, color: isDark ? Colors.black26 : Colors.grey[100]),
            _buildDescription(primary, textColor, subText),
            Container(height: 8, color: isDark ? Colors.black26 : Colors.grey[100]),
            _buildLocation(textColor),
            Container(height: 8, color: isDark ? Colors.black26 : Colors.grey[100]),
            _buildAttachments(textColor),
            Container(height: 8, color: isDark ? Colors.black26 : Colors.grey[100]),
            _buildTimeline(primary, textColor, subText),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border(top: BorderSide(color: subText.withValues(alpha: 0.2))),
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            // TODO: Implement update status or comment functionality
            onPressed: () {},
            child: Text(
              'Add Update or Comment',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(Color primary, Color textColor, Color subText) {
    final status = report['status'] ?? 'SUBMITTED';
    final sColor = _statusColor(status);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: sColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: sColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                report['id'] ?? '#RPT-0000',
                style: TextStyle(color: subText, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            report['title'] ?? 'Unknown Issue',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: subText),
              const SizedBox(width: 8),
              Text(report['date'] ?? 'Recently', style: TextStyle(color: subText, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: subText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  report['address'] ?? 'Unknown Location',
                  style: TextStyle(color: subText, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Color primary, Color textColor, Color subText) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, color: primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Details regarding the ${report['title']?.toLowerCase()} reported at ${report['address']}. Lorem ipsum dolor sit amet consectetur adipiscing elit.',
            style: TextStyle(color: textColor.withValues(alpha: 0.8), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location map',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? const Color(0xFF1E3040) : Colors.grey[300],
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1619468129361-605ebea04b44?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments(Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attachments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1658223684971-f262da87168f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080&q=80',
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E3040) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(Icons.broken_image_outlined, color: isDark ? Colors.white30 : Colors.black26),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(Color primary, Color textColor, Color subText) {
    // Dummy timeline data based on report status
    final timelineItems = [
      {'title': 'Report Submitted', 'date': report['date'] ?? 'Recently', 'status': 'completed'},
      {'title': 'Under Review', 'date': '', 'status': report['status'] == 'SUBMITTED' ? 'upcoming' : 'completed'},
      {'title': 'In Progress', 'date': '', 'status': report['status'] == 'IN PROGRESS' ? 'current' : (report['status'] == 'RESOLVED' ? 'completed' : 'upcoming')},
      {'title': 'Resolved', 'date': '', 'status': report['status'] == 'RESOLVED' ? 'completed' : 'upcoming'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timelineItems.length,
            itemBuilder: (context, index) {
              final item = timelineItems[index];
              final isLast = index == timelineItems.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _getTimelineIcon(item['status']!, primary),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: subText.withValues(alpha: 0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: item['status'] == 'upcoming' ? subText : textColor,
                            ),
                          ),
                          if (item['date']!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                item['date']!,
                                style: TextStyle(fontSize: 12, color: subText),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper function to get timeline icon based on status
  Widget _getTimelineIcon(String status, Color primary) {
    switch (status) {
      case 'completed':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'current':
        return Icon(Icons.motion_photos_on, color: primary);
      default:
        return Icon(Icons.radio_button_unchecked, color: Colors.grey.withValues(alpha: 0.5));
    }
  }
}