import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/map_repository.dart';

class MapWidget extends StatefulWidget {
  final LatLng? initialPosition;
  final Set<MapMarker> markers;
  final Set<MapPolyline> polylines;
  final Set<MapPolygon> polygons;
  final gmaps.MapType mapType;
  final bool showUserLocation;
  final bool showTraffic;
  final bool showBuildings;
  final VoidCallback? onMapCreated;
  final Function(LatLng)? onTap;
  final Function(MapMarker)? onMarkerTap;
  final Function(MapPolyline)? onPolylineTap;
  final Function(MapPolygon)? onPolygonTap;
  final bool isInteractive;

  const MapWidget({
    super.key,
    this.initialPosition,
    this.markers = const {},
    this.polylines = const {},
    this.polygons = const {},
    this.mapType = gmaps.MapType.normal,
    this.showUserLocation = true,
    this.showTraffic = false,
    this.showBuildings = true,
    this.onMapCreated,
    this.onTap,
    this.onMarkerTap,
    this.onPolylineTap,
    this.onPolygonTap,
    this.isInteractive = true,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late gmaps.GoogleMapController _mapController;
  late LatLng _currentPosition;
  final Set<gmaps.Marker> _googleMarkers = {};
  final Set<gmaps.Polyline> _googlePolylines = {};
  final Set<gmaps.Polygon> _googlePolygons = {};

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialPosition ?? const LatLng(41.0082, 28.9784); // Istanbul center
    _convertMarkers();
    _convertPolylines();
    _convertPolygons();
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.markers != oldWidget.markers) {
      _convertMarkers();
    }
    if (widget.polylines != oldWidget.polylines) {
      _convertPolylines();
    }
    if (widget.polygons != oldWidget.polygons) {
      _convertPolygons();
    }
  }

  void _convertMarkers() {
    _googleMarkers.clear();
    for (final marker in widget.markers) {
      _googleMarkers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(marker.id),
          position: gmaps.LatLng(marker.position.latitude, marker.position.longitude),
          infoWindow: gmaps.InfoWindow(
            title: marker.title,
            snippet: marker.snippet,
          ),
          icon: _getMarkerIcon(marker.icon),
          draggable: marker.isDraggable,
          visible: marker.isVisible,
          rotation: marker.rotation,
          onTap: () => widget.onMarkerTap?.call(marker),
        ),
      );
    }
  }

  void _convertPolylines() {
    _googlePolylines.clear();
    for (final polyline in widget.polylines) {
      _googlePolylines.add(
        gmaps.Polyline(
          polylineId: gmaps.PolylineId(polyline.id),
          points: polyline.points.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList(),
          color: _parseColor(polyline.color),
          width: polyline.width.toInt(),
          geodesic: polyline.isGeodesic,
          patterns: const <gmaps.PatternItem>[],
          onTap: () => widget.onPolylineTap?.call(polyline),
        ),
      );
    }
  }

  void _convertPolygons() {
    _googlePolygons.clear();
    for (final polygon in widget.polygons) {
      _googlePolygons.add(
        gmaps.Polygon(
          polygonId: gmaps.PolygonId(polygon.id),
          points: polygon.points.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList(),
          holes: polygon.holes
              .map((ring) => ring.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList())
              .toList(),
          strokeColor: _parseColor(polygon.strokeColor),
          fillColor: _parseColor(polygon.fillColor),
          strokeWidth: polygon.strokeWidth.toInt(),
          visible: polygon.isVisible,
          onTap: () => widget.onPolygonTap?.call(polygon),
        ),
      );
    }
  }

  gmaps.BitmapDescriptor _getMarkerIcon(MarkerIcon icon) {
    switch (icon) {
      case MarkerIcon.red:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueRed);
      case MarkerIcon.blue:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueBlue);
      case MarkerIcon.green:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueGreen);
      case MarkerIcon.yellow:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueYellow);
      case MarkerIcon.purple:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueViolet);
      case MarkerIcon.orange:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueOrange);
      case MarkerIcon.pink:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueRose);
      case MarkerIcon.custom:
        return gmaps.BitmapDescriptor.defaultMarker;
      default:
        return gmaps.BitmapDescriptor.defaultMarker;
    }
  }

  Color _parseColor(String color) {
    if (color.startsWith('#')) {
      return Color(int.parse(color.substring(1), radix: 16) | 0xFF000000);
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        child: gmaps.GoogleMap(
          initialCameraPosition: gmaps.CameraPosition(
            target: gmaps.LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 15.0,
          ),
          markers: _googleMarkers,
          polylines: _googlePolylines,
          polygons: _googlePolygons,
          mapType: _getMapType(widget.mapType),
          myLocationEnabled: widget.showUserLocation,
          myLocationButtonEnabled: widget.showUserLocation,
          trafficEnabled: widget.showTraffic,
          buildingsEnabled: widget.showBuildings,
          compassEnabled: true,
          zoomControlsEnabled: true,
          rotateGesturesEnabled: widget.isInteractive,
          scrollGesturesEnabled: widget.isInteractive,
          tiltGesturesEnabled: widget.isInteractive,
          zoomGesturesEnabled: widget.isInteractive,
          onMapCreated: (controller) {
            _mapController = controller;
            widget.onMapCreated?.call();
          },
          onTap: (pos) => widget.onTap?.call(LatLng(pos.latitude, pos.longitude)),
          onCameraMove: (position) {
            setState(() {
              _currentPosition = LatLng(position.target.latitude, position.target.longitude);
            });
          },
          onCameraIdle: () {
            // Handle camera idle events
          },
        ),
      ),
    );
  }

  gmaps.MapType _getMapType(gmaps.MapType type) {
    return type;
  }

  void animateToLocation(LatLng position, {double zoom = 15.0}) {
    _mapController.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(
          target: gmaps.LatLng(position.latitude, position.longitude),
          zoom: zoom,
        ),
      ),
    );
  }

  void animateToBounds(MapBounds bounds, {double padding = 50.0}) {
    _mapController.animateCamera(
      gmaps.CameraUpdate.newLatLngBounds(
        gmaps.LatLngBounds(
          southwest: gmaps.LatLng(bounds.southwest.latitude, bounds.southwest.longitude),
          northeast: gmaps.LatLng(bounds.northeast.latitude, bounds.northeast.longitude),
        ),
        padding,
      ),
    );
  }

  void addMarker(MapMarker marker) {
    setState(() {
      _googleMarkers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(marker.id),
          position: gmaps.LatLng(marker.position.latitude, marker.position.longitude),
          infoWindow: gmaps.InfoWindow(
            title: marker.title,
            snippet: marker.snippet,
          ),
          icon: _getMarkerIcon(marker.icon),
          draggable: marker.isDraggable,
          visible: marker.isVisible,
          rotation: marker.rotation,
          onTap: () => widget.onMarkerTap?.call(marker),
        ),
      );
    });
  }

  void removeMarker(String markerId) {
    setState(() {
      _googleMarkers.removeWhere((marker) => marker.markerId.value == markerId);
    });
  }

  void clearMarkers() {
    setState(() {
      _googleMarkers.clear();
    });
  }

  void addPolyline(MapPolyline polyline) {
    setState(() {
      _googlePolylines.add(
        gmaps.Polyline(
          polylineId: gmaps.PolylineId(polyline.id),
          points: polyline.points.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList(),
          color: _parseColor(polyline.color),
          width: polyline.width.toInt(),
          geodesic: polyline.isGeodesic,
          patterns: const <gmaps.PatternItem>[],
          onTap: () => widget.onPolylineTap?.call(polyline),
        ),
      );
    });
  }

  void removePolyline(String polylineId) {
    setState(() {
      _googlePolylines.removeWhere((polyline) => polyline.polylineId.value == polylineId);
    });
  }

  void clearPolylines() {
    setState(() {
      _googlePolylines.clear();
    });
  }

  void addPolygon(MapPolygon polygon) {
    setState(() {
      _googlePolygons.add(
        gmaps.Polygon(
          polygonId: gmaps.PolygonId(polygon.id),
          points: polygon.points.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList(),
          holes: polygon.holes
              .map((ring) => ring.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList())
              .toList(),
          strokeColor: _parseColor(polygon.strokeColor),
          fillColor: _parseColor(polygon.fillColor),
          strokeWidth: polygon.strokeWidth.toInt(),
          visible: polygon.isVisible,
          onTap: () => widget.onPolygonTap?.call(polygon),
        ),
      );
    });
  }

  void removePolygon(String polygonId) {
    setState(() {
      _googlePolygons.removeWhere((polygon) => polygon.polygonId.value == polygonId);
    });
  }

  void clearPolygons() {
    setState(() {
      _googlePolygons.clear();
    });
  }

  LatLng get currentPosition => _currentPosition;

  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

class LocationPicker extends StatefulWidget {
  final LatLng? initialPosition;
  final Function(LatLng, String)? onLocationSelected;
  final bool showSearchBar;
  final bool showCurrentLocationButton;
  final double? radius;

  const LocationPicker({
    super.key,
    this.initialPosition,
    this.onLocationSelected,
    this.showSearchBar = true,
    this.showCurrentLocationButton = true,
    this.radius,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late LatLng _selectedPosition;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition ?? const LatLng(41.0082, 28.9784);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.showSearchBar
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Adres ara...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                ),
                style: TextStyle(color: AppColors.textPrimary),
                onSubmitted: _searchLocation,
              )
            : const Text('Konum Seç'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          if (_isLoading)
            const CircularProgressIndicator()
          else
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'İptal',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
            initialPosition: _selectedPosition,
            onTap: _onMapTap,
            showUserLocation: true,
          ),
          if (widget.showCurrentLocationButton)
            Positioned(
              bottom: 100.h,
              right: 16.w,
              child: FloatingActionButton(
                onPressed: _goToCurrentLocation,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          Positioned(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
            child: ElevatedButton(
              onPressed: _confirmLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
                ),
              ),
              child: Text('Bu Konumu Seç'),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  void _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Search for location
      final results = await context.read<MapRepository>().searchMap(
        query: query,
        page: 1,
        limit: 5,
      );

      if (results.isRight() && results.getOrElse(() => []).isNotEmpty) {
        final result = results.getOrElse(() => []).first;
        setState(() {
          _selectedPosition = result.position;
        });

        // ignore: invalid_use_of_visible_for_testing_member
        (context.findAncestorStateOfType<_MapWidgetState>())?.animateToLocation(result.position);
      }
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await context.read<MapRepository>().getCurrentLocation();

      if (result.isRight()) {
        final location = result.getOrElse(() => LocationEntity(
          id: '',
          address: '',
          city: '',
          district: '',
          country: '',
          latitude: 0,
          longitude: 0,
          createdAt: DateTime.now(),
        ));

        setState(() {
          _selectedPosition = LatLng(location.latitude, location.longitude);
        });

        // ignore: invalid_use_of_visible_for_testing_member
        (context.findAncestorStateOfType<_MapWidgetState>())?.animateToLocation(_selectedPosition);
      }
    } catch (e) {
      debugPrint('Get current location error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _confirmLocation() {
    widget.onLocationSelected?.call(_selectedPosition, 'Selected location');
    Navigator.of(context).pop();
  }
}
