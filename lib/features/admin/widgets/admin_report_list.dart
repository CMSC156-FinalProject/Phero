import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../presentation/viewmodels/report_viewmodel.dart';
import '../../../domain/models/report.dart';
import 'admin_status_modal.dart';

class AdminReportList extends StatelessWidget {
  final List<String> targetStatuses;
  final bool isDark;
  final Color primary;
  final Color cardBg;
  final Color textColor;
  final Color subText;

  const AdminReportList({
    super.key,
    required this.targetStatuses,
    required this.isDark,
    required this.primary,
    required this.cardBg,
    required this.textColor,
    required this.subText,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
      case 'in progress':
        return isDark ? const Color(0xFF2ECC71) : const Color(0xFF4A90D9);
      case 'resolved':
        return const Color(0xFF5AAA6A);
      case 'invalid':
        return const Color(0xFF8A9A7A);
      default:
        return const Color(0xFFF55858);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
      case 'in progress':
        return Icons.sync;
      case 'resolved':
        return Icons.check_circle_outline;
      case 'invalid':
        return Icons.block_outlined;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReportViewModel>();

    if (viewModel.isLoading && viewModel.reports.isEmpty) {
      return Center(child: CircularProgressIndicator(color: primary));
    }

    if (!viewModel.isLoading && viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: ${viewModel.errorMessage}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final reports = viewModel.reports
        .where((r) => targetStatuses.contains(r.status.toLowerCase()))
        .toList();

    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: subText.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              'No reports in this category.',
              style: TextStyle(color: subText, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: reports.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildReportCard(context, reports[index]),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report) {
    final statusColor = _statusColor(report.status);
    final statusIcon = _statusIcon(report.status);
    final dateStr =
        '${report.timestamp.day}/${report.timestamp.month}/${report.timestamp.year}';
    final shortId = report.id.length > 8
        ? 'REP-${report.id.substring(0, 8).toUpperCase()}'
        : 'REP-${report.id.toUpperCase()}';

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Row(
        children: [
          // ── Thumbnail ─────────────────────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: SizedBox(
              width: 80,
              height: 90,
              child: report.mediaPath != null && report.mediaPath!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: report.mediaPath!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.withValues(alpha: 0.1),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.withValues(alpha: 0.3),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white.withValues(alpha: 0.4),
                          size: 28,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.blueGrey.withValues(alpha: isDark ? 0.5 : 0.3),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 28,
                      ),
                    ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          report.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(shortId, style: TextStyle(fontSize: 9, color: subText)),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Description
                  Text(
                    report.description.isNotEmpty
                        ? report.description
                        : 'No description provided.',
                    style: TextStyle(fontSize: 12, color: subText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Date + Status + Edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
                      Row(children: [
                        Icon(Icons.calendar_today_outlined, size: 11, color: subText),
                        const SizedBox(width: 4),
                        Text(dateStr, style: TextStyle(fontSize: 11, color: subText)),
                      ]),

                      // Status chip + Edit
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
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
                              Icon(statusIcon, size: 10, color: statusColor),
                              const SizedBox(width: 3),
                              Text(
                                report.status.toUpperCase().replaceAll('_', ' '),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Edit button
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => AdminStatusModal(
                                report: report,
                                onStatusUpdate: (newStatus) async {
                                  return await context
                                      .read<ReportViewModel>()
                                      .updateReportStatus(report.id, newStatus);
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.edit_outlined, size: 15, color: primary),
                          ),
                        ),
                        if (report.status.toLowerCase() == 'resolved' ||
                            report.status.toLowerCase() == 'invalid') ...[
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _showDeleteConfirmation(context, report),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.delete_outline, size: 15, color: Colors.red),
                            ),
                          ),
                        ],
                      ]),
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

  void _showDeleteConfirmation(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardBg,
          title: Text(
            'Delete Report',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete this closed report? This action cannot be undone.',
            style: TextStyle(color: textColor.withValues(alpha: 0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel', style: TextStyle(color: subText)),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                final success = await context
                    .read<ReportViewModel>()
                    .deleteReport(report.id);
                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Report deleted successfully'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
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
}
