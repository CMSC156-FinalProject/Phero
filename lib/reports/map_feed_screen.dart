import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'report_details_screen.dart';
import '../settings/account_settings_screen.dart';
import '../reports/widgets/custom_bottom_navbar.dart';
import '../core/theme/theme_notifier.dart';
import '../presentation/viewmodels/report_viewmodel.dart';
import '../domain/models/report.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../domain/repositories/location_service.dart';

class MapFeedScreen extends StatefulWidget {
  const MapFeedScreen({super.key});

  @override
  State<MapFeedScreen> createState() => _MapFeedScreenState();
}

class _MapFeedScreenState extends State<MapFeedScreen> {
  bool _isListView = true;
  double? _userLatitude;
  double? _userLongitude;
  final MapController _mapController = MapController();
  bool _isMapCentered = false;
  LatLngBounds? _visibleBounds;
  StreamSubscription<MapEvent>? _mapEventSub;

  @override
  void initState() {
    super.initState();
    // Track map viewport changes to keep the list in sync
    _mapEventSub = _mapController.mapEventStream.listen((event) {
      if (mounted) {
        setState(() => _visibleBounds = event.camera.visibleBounds);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportViewModel>().loadReports();
      _fetchUserLocation();
    });
  }

  @override
  void dispose() {
    _mapEventSub?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserLocation({bool forceRecenter = false}) async {
    try {
      final service = context.read<LocationService>();
      final location = await service.getCurrentLocation();
      if (location != null) {
        setState(() {
          _userLatitude = location.latitude;
          _userLongitude = location.longitude;
        });

        // 1. Fetch localized reports in the surrounding 10 km area via Clean Architecture backend
        if (mounted) {
          await context.read<ReportViewModel>().loadNearbyReports(
            location.latitude,
            location.longitude,
            10.0,
          );
        }

        // 2. Programmatically center the map viewport
        if (!_isMapCentered || forceRecenter) {
          _mapController.move(LatLng(location.latitude, location.longitude), 14.0);
          _isMapCentered = true;
        }
      } else {
        if (forceRecenter && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to retrieve location. Please check settings/permissions.'),
            ),
          );
        }
      }
    } catch (e) {
      if (forceRecenter && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Color _statusColor(String status, bool isDark) {
  switch (status.toUpperCase()) {
    case 'IN_PROGRESS':
      return const Color(0xFF4169E1); // Blue

    case 'RESOLVED':
      return const Color(0xFF008000); // Green

    case 'PENDING':
      return const Color(0xFFFF0000); // Red

    default:
      return isDark
          ? const Color(0xFFB0B0B0)
          : const Color(0xFF808080); // Gray fallback
  }
}

  /// Returns only reports whose coordinates fall within the current map viewport.
  /// Falls back to all reports when no bounds are known yet.
  List<Report> _getVisibleReports(List<Report> allReports) {
    if (_visibleBounds == null) return allReports;
    return allReports
        .where((r) => _visibleBounds!.contains(LatLng(r.latitude, r.longitude)))
        .toList();
  }

  Widget _buildListView(
    List<Report> allReports,
    Color subText,
    bool isDark,
    Color cardBg,
    Color textColor,
  ) {
    final visibleReports = _getVisibleReports(allReports);
    return Column(
      children: [
        // Subtle viewport indicator
        if (_visibleBounds != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              children: [
                Icon(Icons.map_outlined, size: 13, color: subText),
                const SizedBox(width: 6),
                Text(
                  '${visibleReports.length} report${visibleReports.length == 1 ? '' : 's'} in current map view',
                  style: TextStyle(fontSize: 12, color: subText),
                ),
              ],
            ),
          ),
        Expanded(
          child: visibleReports.isEmpty
              ? Center(
                  child: Text(
                    _visibleBounds != null
                        ? 'No reports in this area'
                        : 'No reports found',
                    style: TextStyle(color: subText),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: visibleReports.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _buildIssueCard(
                      visibleReports[index], isDark, cardBg, textColor, subText,
                    );
                  },
                ),
        ),
      ],
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

    final reportViewModel = context.watch<ReportViewModel>();
    final reports = reportViewModel.reports;
    final nearbyReports = reportViewModel.nearbyReports;

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
                  : reportViewModel.errorMessage != null
                      ? Center(child: Text('Error: ${reportViewModel.errorMessage}', style: const TextStyle(color: Colors.red)))
                      : _isListView
                          ? _buildListView(reports, subText, isDark, cardBg, textColor)
                      : ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    mapController: _mapController,
                                    options: MapOptions(
                                      initialCenter: _userLatitude != null && _userLongitude != null
                                          ? LatLng(_userLatitude!, _userLongitude!)
                                          : const LatLng(14.5995, 120.9842),
                                      initialZoom: 14.0,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.phero.app',
                                      ),
                                      MarkerLayer(
                                        markers: nearbyReports.isEmpty
                                          ? reports.map((report) => _makeMarker(report, context, isDark)).toList()
                                          : nearbyReports.map((report) => _makeMarker(report, context, isDark)).toList(),
                                      ),
                                    ],
                                  ),
                                  
                                  // Recenter Location Float Button
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: FloatingActionButton(
                                      mini: true,
                                      backgroundColor: primary,
                                      child: Icon(
                                        Icons.my_location,
                                        color: isDark ? Colors.black : Colors.white,
                                      ),
                                      onPressed: () => _fetchUserLocation(forceRecenter: true),
                                    ),
                                  ),
                                ],
                              ),
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

  Marker _makeMarker(Report report, BuildContext context, bool isDark) {
    return Marker(
      point: LatLng(report.latitude, report.longitude),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetailsScreen(report: report),
            ),
          );
        },
        child: Icon(
          Icons.location_on,
          size: 36,
          color: _statusColor(report.status, isDark),
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
                  Text('${report.latitude.abs().toStringAsFixed(4)}° ${report.latitude >= 0 ? 'N' : 'S'}, ${report.longitude.abs().toStringAsFixed(4)}° ${report.longitude >= 0 ? 'E' : 'W'}', style: TextStyle(fontSize: 12, color: subText)),
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