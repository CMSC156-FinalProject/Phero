import 'package:flutter/material.dart';
import 'map_feed_screen.dart';
import 'my_reports_screen.dart';
import '../emergency/emergency_screen.dart';
import '../settings/account_settings_screen.dart';

class ReportScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const ReportScreen({super.key, required this.isDark, required this.onToggle});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Color get _primary => widget.isDark ? const Color(0xFF2ECC71) : const Color(0xFF3B4A2F);
  Color get _bg => widget.isDark ? const Color(0xFF0D1B2A) : Colors.white;
  Color get _cardBg => widget.isDark ? const Color(0xFF132030) : const Color(0xFFF5F7F2);
  Color get _textColor => widget.isDark ? Colors.white : const Color(0xFF2C3A1E);
  Color get _subText => widget.isDark ? const Color(0xFF8AABB0) : const Color(0xFF8A9A7A);
  Color get _inputBorder => widget.isDark ? const Color(0xFF1E3040) : const Color(0xFFE0E8D8);

  void _onTabTapped(int index) {
    if (index == 1) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MapFeedScreen(isDark: widget.isDark, onToggle: widget.onToggle),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyReportsScreen(isDark: widget.isDark, onToggle: widget.onToggle),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EmergencyScreen(isDark: widget.isDark, onToggle: widget.onToggle),
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccountSettingsScreen(
                          isDark: widget.isDark,
                          onToggle: widget.onToggle,
                        ),
                      ),
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: widget.isDark ? Colors.black : Colors.white,
                        size: 20,
                      ),
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

                    // Title
                    Center(
                      child: Text(
                        'Report Issue',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Help fix your neighborhood today.',
                        style: TextStyle(fontSize: 13, color: _subText),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Evidence Photo Label
                    Row(
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 16, color: _subText),
                        const SizedBox(width: 6),
                        Text(
                          'Evidence Photo',
                          style: TextStyle(
                            fontSize: 13,
                            color: _subText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Photo upload area
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _inputBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 36,
                            color: _subText.withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tap to take photo',
                            style: TextStyle(
                              fontSize: 14,
                              color: _subText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Location field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? const Color(0xFF1A3020)
                            : const Color(0xFFEDF4E8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 18, color: _primary),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '49.7128° N, 74.0060° W',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _subText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Issue Category Label
                    Text(
                      'Issue Category',
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.isDark ? const Color(0xFF2ECC71) : _textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _inputBorder, width: 1),
                      ),
                      child: TextField(
                        controller: _categoryController,
                        style: TextStyle(color: _textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description Label
                    Text(
                      'Description (Optional)',
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.isDark ? const Color(0xFF2ECC71) : _textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _inputBorder, width: 1),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: TextStyle(color: _textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Provide any helpful details...',
                          hintStyle: TextStyle(color: _subText, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Text(
                          'Submit Report',
                          style: TextStyle(
                            color: widget.isDark ? Colors.black : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
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
    final isActive = index == 1;
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