import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/report.dart';
import '../../../core/theme/theme_notifier.dart';

class AdminStatusModal extends StatefulWidget {
  final Report report;
  final Future<bool> Function(String) onStatusUpdate;

  const AdminStatusModal({
    super.key,
    required this.report,
    required this.onStatusUpdate,
  });

  @override
  State<AdminStatusModal> createState() => _AdminStatusModalState();
}

class _AdminStatusModalState extends State<AdminStatusModal> {
  late String _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.report.status;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;
    final primary = isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
    final bg = isDark ? const Color(0xFF132030) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subText = isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);
    final cardBg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF5F7F2);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: subText.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Update Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            widget.report.title,
            style: TextStyle(fontSize: 13, color: subText),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),

          // Dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedStatus,
            isExpanded: true,
            dropdownColor: cardBg,
            icon: Icon(Icons.keyboard_arrow_down, color: subText),
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: cardBg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: primary, width: 1.5),
              ),
            ),
            items: [
              DropdownMenuItem(
                value: 'pending',
                child: Text('Pending', style: TextStyle(color: textColor)),
              ),
              DropdownMenuItem(
                value: 'in_progress',
                child: Text('In Progress', style: TextStyle(color: textColor)),
              ),
              DropdownMenuItem(
                value: 'resolved',
                child: Text('Resolved', style: TextStyle(color: textColor)),
              ),
              DropdownMenuItem(
                value: 'invalid',
                child: Text('Invalid', style: TextStyle(color: textColor)),
              ),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedStatus = val);
            },
          ),
          const SizedBox(height: 24),

          // Confirm button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    final success = await widget.onStatusUpdate(_selectedStatus);
                    if (mounted && context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Status updated successfully'
                                : 'Failed to update status',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: isDark ? Colors.black : Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Confirm Update',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
