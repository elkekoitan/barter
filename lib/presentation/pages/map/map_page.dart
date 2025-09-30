import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/map_widget.dart';
import '../../widgets/custom_button.dart';
import '../../../domain/entities/location.dart';

class MapPage extends StatefulWidget {
  final LatLng? initialPosition;
  final Set<MapMarker> markers;
  final bool showSearchBar;
  final bool showCurrentLocationButton;
  final bool showRouteButton;
  final String? title;

  const MapPage({
    super.key,
    this.initialPosition,
    this.markers = const {},
    this.showSearchBar = true,
    this.showCurrentLocationButton = true,
    this.showRouteButton = false,
    this.title,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late LatLng _currentPosition;
  final TextEditingController _searchController = TextEditingController();
  final Set<MapMarker> _markers = {};
  final Set<MapPolyline> _polylines = {};
  final Set<MapPolygon> _polygons = {};
  bool _isLoading = false;
  bool _showSearchResults = false;
  List<MapSearchResult> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialPosition ?? const LatLng(41.0082, 28.9784);
    _markers.addAll(widget.markers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null
            ? Text(widget.title!)
            : Text('map'.tr()),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          if (widget.showSearchBar)
            IconButton(
              onPressed: _showSearchDialog,
              icon: Icon(Icons.search, color: AppColors.textSecondary),
            ),
          IconButton(
            onPressed: _toggleMapType,
            icon: Icon(Icons.layers, color: AppColors.textSecondary),
          ),
          IconButton(
            onPressed: _showMapSettings,
            icon: Icon(Icons.settings, color: AppColors.textSecondary),
          ),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
            initialPosition: _currentPosition,
            markers: _markers,
            polylines: _polylines,
            polygons: _polygons,
            showUserLocation: true,
            showTraffic: false,
            showBuildings: true,
            onMapCreated: _onMapCreated,
            onTap: _onMapTap,
            onMarkerTap: _onMarkerTap,
          ),
          if (widget.showCurrentLocationButton)
            Positioned(
              bottom: 120.h,
              right: 16.w,
              child: FloatingActionButton(
                onPressed: _goToCurrentLocation,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.my_location, color: AppColors.white),
              ),
            ),
          if (widget.showRouteButton)
            Positioned(
              bottom: 60.h,
              right: 16.w,
              child: FloatingActionButton(
                onPressed: _showRouteOptions,
                backgroundColor: AppColors.success,
                child: Icon(Icons.directions, color: AppColors.white),
              ),
            ),
          if (_isLoading)
            Container(
              color: AppColors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (_showSearchResults)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(AppDimensions.borderRadiusL),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      child: Row(
                        children: [
                          Text(
                            'search_results'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => setState(() => _showSearchResults = false),
                            icon: Icon(Icons.close, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Icon(
                                _getResultIcon(result),
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(
                              result.title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              result.description,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            onTap: () => _selectSearchResult(result),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showRouteButton)
            FloatingActionButton(
              onPressed: _showRouteOptions,
              backgroundColor: AppColors.success,
              child: Icon(Icons.directions, color: AppColors.white),
            ),
          SizedBox(height: AppDimensions.marginM),
          FloatingActionButton(
            onPressed: _addMarker,
            backgroundColor: AppColors.info,
            child: Icon(Icons.add_location, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  void _onMapCreated() {
    debugPrint('Map created');
  }

  void _onMapTap(LatLng position) {
    debugPrint('Map tapped at: ${position.latitude}, ${position.longitude}');
    _addMarkerAtPosition(position);
  }

  void _onMarkerTap(MapMarker marker) {
    debugPrint('Marker tapped: ${marker.title}');
    _showMarkerDetails(marker);
  }

  void _showSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'search_location'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              ),
              onSubmitted: _searchLocation,
            ),
            SizedBox(height: AppDimensions.marginL),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'cancel'.tr(),
                    onPressed: () => Navigator.of(context).pop(),
                    type: ButtonType.outline,
                  ),
                ),
                SizedBox(width: AppDimensions.marginM),
                Expanded(
                  child: CustomButton(
                    text: 'search'.tr(),
                    onPressed: () => _searchLocation(_searchController.text),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSearchResults = true;
    });

    Navigator.of(context).pop(); // Close search dialog

    try {
      // Search for locations
      // This would use the map repository
      debugPrint('Searching for: $query');

      // Mock search results
      _searchResults = [
        MapSearchResult(
          id: '1',
          title: 'İstanbul, Türkiye',
          description: 'Türkiye\'nin en büyük şehri',
          position: const LatLng(41.0082, 28.9784),
        ),
        MapSearchResult(
          id: '2',
          title: 'Kadıköy, İstanbul',
          description: 'İstanbul\'un popüler semti',
          position: const LatLng(40.9878, 29.0307),
        ),
      ];

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Search error: $e');
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  void _selectSearchResult(MapSearchResult result) {
    setState(() {
      _showSearchResults = false;
      _currentPosition = result.position;
    });

    // Animate map to selected location
    // _mapWidget.animateToLocation(result.position);
  }

  IconData _getResultIcon(MapSearchResult result) {
    if (result.title.contains('İstanbul')) {
      return Icons.location_city;
    } else if (result.title.contains('Kadıköy')) {
      return Icons.location_on;
    } else {
      return Icons.place;
    }
  }

  void _toggleMapType() {
    // Toggle between map types
    debugPrint('Toggle map type');
  }

  void _showMapSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.traffic, color: AppColors.textSecondary),
              title: Text('show_traffic'.tr()),
              trailing: Switch(
                value: false, // _showTraffic
                onChanged: (value) {
                  setState(() {
                    // _showTraffic = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.business, color: AppColors.textSecondary),
              title: Text('show_buildings'.tr()),
              trailing: Switch(
                value: true, // _showBuildings
                onChanged: (value) {
                  setState(() {
                    // _showBuildings = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.my_location, color: AppColors.textSecondary),
              title: Text('show_user_location'.tr()),
              trailing: Switch(
                value: true, // _showUserLocation
                onChanged: (value) {
                  setState(() {
                    // _showUserLocation = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToCurrentLocation() {
    setState(() {
      _isLoading = true;
    });

    // Get current location and animate map to it
    debugPrint('Go to current location');

    setState(() {
      _isLoading = false;
    });
  }

  void _showRouteOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.directions_car, color: AppColors.primary),
              title: Text('driving'.tr()),
              onTap: () => _showRoute(RouteMode.driving),
            ),
            ListTile(
              leading: Icon(Icons.directions_walk, color: AppColors.primary),
              title: Text('walking'.tr()),
              onTap: () => _showRoute(RouteMode.walking),
            ),
            ListTile(
              leading: Icon(Icons.directions_bike, color: AppColors.primary),
              title: Text('bicycling'.tr()),
              onTap: () => _showRoute(RouteMode.bicycling),
            ),
            ListTile(
              leading: Icon(Icons.directions_transit, color: AppColors.primary),
              title: Text('transit'.tr()),
              onTap: () => _showRoute(RouteMode.transit),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoute(RouteMode mode) {
    Navigator.of(context).pop();
    debugPrint('Show route with mode: $mode');
  }

  void _addMarker() {
    _addMarkerAtPosition(_currentPosition);
  }

  void _addMarkerAtPosition(LatLng position) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_marker'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'marker_title'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
                ),
              ),
              onSubmitted: (value) => _addMarkerWithTitle(value, position),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('add'.tr()),
          ),
        ],
      ),
    );
  }

  void _addMarkerWithTitle(String title, LatLng position) {
    Navigator.of(context).pop();

    final marker = MapMarker(
      id: 'marker_${DateTime.now().millisecondsSinceEpoch}',
      position: position,
      title: title,
      snippet: 'Added marker',
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _showMarkerDetails(MapMarker marker) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              marker.title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (marker.snippet != null) ...[
              SizedBox(height: AppDimensions.marginS),
              Text(
                marker.snippet!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            SizedBox(height: AppDimensions.marginL),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'get_directions'.tr(),
                    onPressed: () => _getDirectionsToMarker(marker),
                    type: ButtonType.outline,
                  ),
                ),
                SizedBox(width: AppDimensions.marginM),
                Expanded(
                  child: CustomButton(
                    text: 'remove'.tr(),
                    onPressed: () => _removeMarker(marker.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _getDirectionsToMarker(MapMarker marker) {
    Navigator.of(context).pop();
    _showRoute(RouteMode.driving);
  }

  void _removeMarker(String markerId) {
    Navigator.of(context).pop();
    setState(() {
      _markers.removeWhere((marker) => marker.id == markerId);
    });
  }
}
