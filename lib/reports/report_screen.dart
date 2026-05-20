import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'map_feed_screen.dart';
import 'my_reports_screen.dart';
import '../emergency/emergency_screen.dart';
import '../settings/account_settings_screen.dart';
import '../reports/widgets/custom_bottom_navbar.dart';
import '../core/theme/theme_notifier.dart';
import '../domain/repositories/location_service.dart';
import '../presentation/viewmodels/report_viewmodel.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  double? _latitude;
  double? _longitude;

  // Issue Category Dropdown
  String? _selectedCategory;
  final List<String> _categories = [
    'Broken Sidewalk',
    'Broken Streetlight',
    'Drainage Issue',
    'Fallen Tree',
    'Graffiti',
    'Illegal Dumping',
    'Pothole',
    'Spaghetti Wires',
    'Other',
  ];

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchLocation());
  }

  Future<void> _fetchLocation() async {
    try {
      final service = context.read<LocationService>();
      final location = await service.getCurrentLocation();
      if (location != null) {
        setState(() {
          _latitude = location.latitude;
          _longitude = location.longitude;
        });
      }
    } catch (e) {
      // Graceful error handling
    }
  }

  void _onTabTapped(int index) {
    if (index == 1) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapFeedScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyReportsScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EmergencyScreen()),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Compress image to 80% quality to save bandwidth
      );
      if (picked != null) {
        // setState(() => _image = File(picked.path));
        setState(() => _image = picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open camera: $e')),
        );
      }
    }
  }

  Future<void> _submitReport() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please attach an evidence photo')),
      );
      return;
    }
    
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an Issue Category')),
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available yet. Please wait a moment and try again.')),
      );
      return;
    }

    final reportViewModel = context.read<ReportViewModel>();
    final success = await reportViewModel.submitReport(
      title: _selectedCategory!,
      description: _descriptionController.text.trim(),
      localImagePath: _image!.path,
      latitude: _latitude,
      longitude: _longitude,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully!')),
        );
        setState(() {
          _selectedCategory = null;
          _image = null;
        });
        _descriptionController.clear();
        
        _onTabTapped(2); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(reportViewModel.errorMessage ?? 'Failed to submit report')),
        );
      }
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
    final inputBorder = isDark ? const Color(0xFF1E3040) : const Color(0xFFE0E8D8);

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
                  Row(
                    children: [
                      Image.asset(
                        isDark ? 'assets/images/logo_head_dark.png' : 'assets/images/logo_head_light.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Phero',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AccountSettingsScreen(),
                      ),
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: isDark ? Colors.black : Colors.white,
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
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Help fix your neighborhood today.',
                        style: TextStyle(fontSize: 13, color: subText),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Evidence Photo Label
                    Row(
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 16, color: subText),
                        const SizedBox(width: 6),
                        Text(
                          'Evidence Photo',
                          style: TextStyle(
                            fontSize: 13,
                            color: subText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Photo upload area
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: _takePhoto, 
                            child: Container(
                              width: double.infinity,
                              height: 160,
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: inputBorder,
                                  width: 1.5,
                                ),
                              ),
                              child: _image == null
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined, 
                                          size: 36,
                                          color: subText.withValues(alpha: 0.7),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Tap to take photo',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: subText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: kIsWeb 
                                          ? Image.network(
                                              _image!.path, 
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                          : Image.file(
                                              File(_image!.path), 
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                    ),
                            ),
                          ),
                          // Remove photo button (only shows if an image exists)
                          if (_image != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => setState(() => _image = null),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
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
                        color: isDark
                            ? const Color(0xFF1A3020)
                            : const Color(0xFFEDF4E8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 18, color: primary),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _latitude != null && _longitude != null
                                    ? '${_latitude!.abs().toStringAsFixed(4)}° ${_latitude! >= 0 ? 'N' : 'S'}, ${_longitude!.abs().toStringAsFixed(4)}° ${_longitude! >= 0 ? 'E' : 'W'}'
                                    : 'Fetching location...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subText,
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
                        color: isDark ? const Color(0xFF2ECC71) : textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      dropdownColor: cardBg,
                      icon: Icon(Icons.keyboard_arrow_down, color: subText),
                      style: TextStyle(color: textColor, fontSize: 14),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: cardBg,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: inputBorder, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: inputBorder, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primary, width: 1.5),
                        ),
                      ),
                      hint: Text('Select a category', style: TextStyle(color: subText, fontSize: 14)),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Description Label
                    Text(
                      'Description (Optional)',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? const Color(0xFF2ECC71) : textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: inputBorder, width: 1),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Provide any helpful details...',
                          hintStyle: TextStyle(color: subText, fontSize: 13),
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
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: context.watch<ReportViewModel>().isLoading ? null : _submitReport,
                        child: context.watch<ReportViewModel>().isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Submit Report',
                                  style: TextStyle(
                                    color: isDark ? Colors.black : Colors.white,
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
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),
    );
  }
}