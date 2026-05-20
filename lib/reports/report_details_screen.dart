import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../domain/models/report.dart';
import '../core/theme/theme_notifier.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/viewmodels/report_viewmodel.dart';

class ReportDetailsScreen extends StatefulWidget {
  final Report report;

  const ReportDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  Color _statusColor(String status, bool isDark) {
    switch (status.toUpperCase()) {
      case 'RESOLVED': return const Color(0xFF5AAA6A);
      default: return const Color(0xFFF55858);
    }
  }

  void _showUpdateStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Report Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['SUBMITTED', 'IN PROGRESS', 'RESOLVED'].map((status) {
              return ListTile(
                title: Text(status),
                trailing: widget.report.status.toUpperCase() == status
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () async {
                  Navigator.pop(dialogContext);
                  final success = await context
                      .read<ReportViewModel>()
                      .updateReportStatus(widget.report.id, status);
                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Status updated to $status')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to update status')),
                      );
                    }
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Report'),
          content: const Text('Are you sure you want to delete this report? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                final success = await context
                    .read<ReportViewModel>()
                    .deleteReport(widget.report.id);
                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report deleted successfully')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete report')),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF0D1B2A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
    final textColor = isDark ? Colors.white : const Color(0xFF2C3A1E);
    final subText = isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);

    final authViewModel = context.watch<AuthViewModel>();
    final currentUser = authViewModel.currentUser;
    final isAdmin = authViewModel.isAdmin;

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
          if (isAdmin || currentUser?.id == widget.report.userId)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: textColor),
              onSelected: (val) {
                if (val == 'delete') {
                  _showDeleteConfirmation(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Report', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderInfo(primary, textColor, subText, isDark),
            Container(height: 8, color: isDark ? Colors.black26 : Colors.grey[100]),
            _buildDescription(primary, textColor, subText),
            Container(height: 8, color: isDark ? Colors.black26 : Colors.grey[100]),
            _buildLocation(textColor),
            Container(height: 8, color: isDark ? Colors.black26 : Colors.grey[100]),
            _buildAttachments(textColor, isDark),
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
          child: isAdmin
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => _showUpdateStatusDialog(context),
                  child: Text(
                    'Update Progress Status',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF132030) : Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: primary.withValues(alpha: 0.5)),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Back to Feed',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(Color primary, Color textColor, Color subText, bool isDark) {
    final status = widget.report.status;
    final sColor = _statusColor(status, isDark);
    final dateStr = '${widget.report.timestamp.day}/${widget.report.timestamp.month}/${widget.report.timestamp.year}';
    final shortId = widget.report.id.length > 8 ? 'REP-${widget.report.id.substring(0, 8).toUpperCase()}' : 'REP-${widget.report.id.toUpperCase()}';

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
                  status.toUpperCase(),
                  style: TextStyle(
                    color: sColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                shortId,
                style: TextStyle(color: subText, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.report.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: subText),
              const SizedBox(width: 8),
              Text(dateStr, style: TextStyle(color: subText, fontSize: 13)),
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
                  '${widget.report.latitude.abs().toStringAsFixed(4)}° ${widget.report.latitude >= 0 ? 'N' : 'S'}, ${widget.report.longitude.abs().toStringAsFixed(4)}° ${widget.report.longitude >= 0 ? 'E' : 'W'}',
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
            widget.report.description.isNotEmpty
                ? widget.report.description
                : 'No details provided for this issue.',
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
            'Location Coordinates',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Latitude: ${widget.report.latitude}\nLongitude: ${widget.report.longitude}',
            style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments(Color textColor, bool isDark) {
    final mediaUrl = widget.report.mediaPath;
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
          if (mediaUrl != null && mediaUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: mediaUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: isDark ? const Color(0xFF1E3040) : Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: isDark ? const Color(0xFF1E3040) : Colors.grey[200],
                  child: Center(
                    child: Icon(Icons.broken_image_outlined, color: isDark ? Colors.white30 : Colors.black26, size: 40),
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3040) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text('No evidence photo attached.', style: TextStyle(color: textColor.withValues(alpha: 0.5))),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeline(Color primary, Color textColor, Color subText) {
    final statusUpper = widget.report.status.toUpperCase();
    final timelineItems = [
      {'title': 'Report Submitted', 'date': '${widget.report.timestamp.day}/${widget.report.timestamp.month}/${widget.report.timestamp.year}', 'status': 'completed'},
      {'title': 'Under Review', 'date': '', 'status': statusUpper == 'SUBMITTED' || statusUpper == 'PENDING' ? 'current' : 'completed'},
      {'title': 'In Progress', 'date': '', 'status': statusUpper == 'IN PROGRESS' ? 'current' : (statusUpper == 'RESOLVED' ? 'completed' : 'upcoming')},
      {'title': 'Resolved', 'date': '', 'status': statusUpper == 'RESOLVED' ? 'completed' : 'upcoming'},
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