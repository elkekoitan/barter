import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class LocationEntity extends Equatable {
  final String id;
  final String address;
  final String city;
  final String district;
  final String country;
  final String postalCode;
  final double latitude;
  final double longitude;
  final LocationType type;
  final bool isVerified;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const LocationEntity({
    required this.id,
    required this.address,
    required this.city,
    required this.district,
    required this.country,
    this.postalCode = '',
    required this.latitude,
    required this.longitude,
    this.type = LocationType.address,
    this.isVerified = false,
    required this.createdAt,
    this.metadata,
  });

  String get fullAddress => '$address, $district, $city, $country';

  bool get isValid => latitude != 0.0 && longitude != 0.0 && address.isNotEmpty;

  double distanceTo(LocationEntity other) {
    const distance = Distance();
    final point1 = LatLng(latitude, longitude);
    final point2 = LatLng(other.latitude, other.longitude);
    return distance.as(LengthUnit.Kilometer, point1, point2);
  }

  bool isWithinRadius(LocationEntity center, double radiusKm) {
    return distanceTo(center) <= radiusKm;
  }

  @override
  List<Object?> get props => [
        id,
        address,
        city,
        district,
        country,
        postalCode,
        latitude,
        longitude,
        type,
        isVerified,
        createdAt,
        metadata,
      ];
}

enum LocationType {
  home('home', 'Ev'),
  work('work', 'İş'),
  other('other', 'Diğer'),
  address('address', 'Adres'),
  pickup('pickup', 'Alım Yeri'),
  delivery('delivery', 'Teslimat Yeri');

  const LocationType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class PlaceEntity extends Equatable {
  final String placeId;
  final String name;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final PlaceType type;
  final double? rating;
  final int? userRatingsTotal;
  final String? phoneNumber;
  final String? website;
  final bool isOpen;
  final Map<String, dynamic>? openingHours;
  final Map<String, dynamic>? photos;
  final Map<String, dynamic>? metadata;

  const PlaceEntity({
    required this.placeId,
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.type = PlaceType.other,
    this.rating,
    this.userRatingsTotal,
    this.phoneNumber,
    this.website,
    this.isOpen = false,
    this.openingHours,
    this.photos,
    this.metadata,
  });

  String get fullAddress => '$address, $city, $country';

  bool get hasPhone => phoneNumber != null && phoneNumber!.isNotEmpty;

  bool get hasWebsite => website != null && website!.isNotEmpty;

  bool get hasPhotos => photos != null && photos!.isNotEmpty;

  @override
  List<Object?> get props => [
        placeId,
        name,
        address,
        city,
        country,
        latitude,
        longitude,
        type,
        rating,
        userRatingsTotal,
        phoneNumber,
        website,
        isOpen,
        openingHours,
        photos,
        metadata,
      ];
}

enum PlaceType {
  restaurant('restaurant', 'Restoran'),
  cafe('cafe', 'Kafe'),
  store('store', 'Mağaza'),
  supermarket('supermarket', 'Süpermarket'),
  pharmacy('pharmacy', 'Eczane'),
  hospital('hospital', 'Hastane'),
  bank('bank', 'Banka'),
  atm('atm', 'ATM'),
  gasStation('gas_station', 'Benzin İstasyonu'),
  parking('parking', 'Otopark'),
  library('library', 'Kütüphane'),
  school('school', 'Okul'),
  university('university', 'Üniversite'),
  museum('museum', 'Müze'),
  theater('theater', 'Tiyatro'),
  cinema('cinema', 'Sinema'),
  gym('gym', 'Spor Salonu'),
  park('park', 'Park'),
  mall('mall', 'Alışveriş Merkezi'),
  other('other', 'Diğer');

  const PlaceType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class MapEntity extends Equatable {
  final String id;
  final String name;
  final MapType type;
  final MapBounds bounds;
  final List<MapMarker> markers;
  final List<MapPolyline> polylines;
  final List<MapPolygon> polygons;
  final MapStyle style;
  final bool isInteractive;
  final bool showUserLocation;
  final bool showTraffic;
  final bool showBuildings;
  final double zoom;
  final LatLng center;
  final Map<String, dynamic>? metadata;

  const MapEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.bounds,
    this.markers = const [],
    this.polylines = const [],
    this.polygons = const [],
    this.style = MapStyle.standard,
    this.isInteractive = true,
    this.showUserLocation = true,
    this.showTraffic = false,
    this.showBuildings = true,
    this.zoom = 15.0,
    required this.center,
    this.metadata,
  });

  MapEntity copyWith({
    String? id,
    String? name,
    MapType? type,
    MapBounds? bounds,
    List<MapMarker>? markers,
    List<MapPolyline>? polylines,
    List<MapPolygon>? polygons,
    MapStyle? style,
    bool? isInteractive,
    bool? showUserLocation,
    bool? showTraffic,
    bool? showBuildings,
    double? zoom,
    LatLng? center,
    Map<String, dynamic>? metadata,
  }) {
    return MapEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      bounds: bounds ?? this.bounds,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      polygons: polygons ?? this.polygons,
      style: style ?? this.style,
      isInteractive: isInteractive ?? this.isInteractive,
      showUserLocation: showUserLocation ?? this.showUserLocation,
      showTraffic: showTraffic ?? this.showTraffic,
      showBuildings: showBuildings ?? this.showBuildings,
      zoom: zoom ?? this.zoom,
      center: center ?? this.center,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        bounds,
        markers,
        polylines,
        polygons,
        style,
        isInteractive,
        showUserLocation,
        showTraffic,
        showBuildings,
        zoom,
        center,
        metadata,
      ];
}

enum MapType {
  normal('normal', 'Normal'),
  satellite('satellite', 'Uydu'),
  terrain('terrain', 'Arazi'),
  hybrid('hybrid', 'Hibrit');

  const MapType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum MapStyle {
  standard('standard', 'Standart'),
  silver('silver', 'Gümüş'),
  retro('retro', 'Retro'),
  dark('dark', 'Karanlık'),
  night('night', 'Gece'),
  aubergine('aubergine', 'Patlıcan');

  const MapStyle(this.value, this.displayName);
  final String value;
  final String displayName;
}

class MapBounds extends Equatable {
  final LatLng northeast;
  final LatLng southwest;

  const MapBounds({
    required this.northeast,
    required this.southwest,
  });

  bool contains(LatLng point) {
    return point.latitude >= southwest.latitude &&
        point.latitude <= northeast.latitude &&
        point.longitude >= southwest.longitude &&
        point.longitude <= northeast.longitude;
  }

  double get width => northeast.longitude - southwest.longitude;

  double get height => northeast.latitude - southwest.latitude;

  @override
  List<Object?> get props => [northeast, southwest];
}

class MapMarker extends Equatable {
  final String id;
  final LatLng position;
  final String title;
  final String? snippet;
  final MarkerIcon icon;
  final bool isDraggable;
  final bool isVisible;
  final double rotation;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final bool showInfoWindow;
  final Map<String, dynamic>? infoWindowData;

  const MapMarker({
    required this.id,
    required this.position,
    required this.title,
    this.snippet,
    this.icon = MarkerIcon.defaultMarker,
    this.isDraggable = false,
    this.isVisible = true,
    this.rotation = 0.0,
    this.data,
    this.imageUrl,
    this.showInfoWindow = true,
    this.infoWindowData,
  });

  @override
  List<Object?> get props => [
        id,
        position,
        title,
        snippet,
        icon,
        isDraggable,
        isVisible,
        rotation,
        data,
        imageUrl,
        showInfoWindow,
        infoWindowData,
      ];
}

enum MarkerIcon {
  defaultMarker('default', 'Varsayılan'),
  red('red', 'Kırmızı'),
  blue('blue', 'Mavi'),
  green('green', 'Yeşil'),
  yellow('yellow', 'Sarı'),
  purple('purple', 'Mor'),
  orange('orange', 'Turuncu'),
  pink('pink', 'Pembe'),
  custom('custom', 'Özel');

  const MarkerIcon(this.value, this.displayName);
  final String value;
  final String displayName;
}

class MapPolyline extends Equatable {
  final String id;
  final List<LatLng> points;
  final String color;
  final double width;
  final bool isGeodesic;
  final List<PatternItem>? patterns;
  final Map<String, dynamic>? data;

  const MapPolyline({
    required this.id,
    required this.points,
    this.color = '#FF0000',
    this.width = 5.0,
    this.isGeodesic = true,
    this.patterns,
    this.data,
  });

  double get length {
    if (points.length < 2) return 0.0;
    const distance = Distance();
    double total = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      total += distance.as(LengthUnit.Kilometer, points[i], points[i + 1]);
    }
    return total;
  }

  @override
  List<Object?> get props => [id, points, color, width, isGeodesic, patterns, data];
}

class MapPolygon extends Equatable {
  final String id;
  final List<LatLng> points;
  final List<List<LatLng>> holes;
  final String strokeColor;
  final String fillColor;
  final double strokeWidth;
  final bool isVisible;
  final Map<String, dynamic>? data;

  const MapPolygon({
    required this.id,
    required this.points,
    this.holes = const [],
    this.strokeColor = '#FF0000',
    this.fillColor = '#FF0000AA',
    this.strokeWidth = 2.0,
    this.isVisible = true,
    this.data,
  });

  double get area {
    if (points.length < 3) return 0.0;
    // Calculate polygon area using shoelace formula
    double area = 0.0;
    for (int i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      area += points[i].longitude * points[j].latitude;
      area -= points[j].longitude * points[i].latitude;
    }
    area = (area.abs() / 2.0);
    return area;
  }

  bool contains(LatLng point) {
    if (points.length < 3) return false;

    int intersectCount = 0;
    for (int i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      if (_doIntersect(points[i], points[j], point, LatLng(point.latitude + 90, point.longitude + 180))) {
        intersectCount++;
      }
    }

    return intersectCount % 2 == 1;
  }

  bool _doIntersect(LatLng p1, LatLng q1, LatLng p2, LatLng q2) {
    final o1 = _orientation(p1, q1, p2);
    final o2 = _orientation(p1, q1, q2);
    final o3 = _orientation(p2, q2, p1);
    final o4 = _orientation(p2, q2, q1);

    if (o1 != o2 && o3 != o4) return true;
    return false;
  }

  int _orientation(LatLng p, LatLng q, LatLng r) {
    final val = (q.longitude - p.longitude) * (r.latitude - p.latitude) -
        (q.latitude - p.latitude) * (r.longitude - p.longitude);

    if (val == 0) return 0;
    return val > 0 ? 1 : 2;
  }

  @override
  List<Object?> get props => [id, points, holes, strokeColor, fillColor, strokeWidth, isVisible, data];
}

class PatternItem extends Equatable {
  final PatternType type;
  final double length;

  const PatternItem(this.type, this.length);

  @override
  List<Object?> get props => [type, length];
}

enum PatternType {
  dash('dash', 'Kesikli'),
  dot('dot', 'Noktalı'),
  gap('gap', 'Boşluk');

  const PatternType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class RouteEntity extends Equatable {
  final String id;
  final LatLng startPoint;
  final LatLng endPoint;
  final List<LatLng> waypoints;
  final RouteMode mode;
  final RouteAvoidance avoidance;
  final double distance;
  final int duration;
  final List<RouteStep> steps;
  final String polyline;
  final Map<String, dynamic>? metadata;

  const RouteEntity({
    required this.id,
    required this.startPoint,
    required this.endPoint,
    this.waypoints = const [],
    this.mode = RouteMode.driving,
    this.avoidance = RouteAvoidance.none,
    required this.distance,
    required this.duration,
    this.steps = const [],
    required this.polyline,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        startPoint,
        endPoint,
        waypoints,
        mode,
        avoidance,
        distance,
        duration,
        steps,
        polyline,
        metadata,
      ];
}

enum RouteMode {
  driving('driving', 'Araba'),
  walking('walking', 'Yürüme'),
  bicycling('bicycling', 'Bisiklet'),
  transit('transit', 'Toplu Taşıma');

  const RouteMode(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum RouteAvoidance {
  none('none', 'Hiçbiri'),
  tolls('tolls', 'Ücretli Yollar'),
  highways('highways', 'Otoyollar'),
  ferries('ferries', 'Feribotlar');

  const RouteAvoidance(this.value, this.displayName);
  final String value;
  final String displayName;
}

class RouteStep extends Equatable {
  final String instruction;
  final double distance;
  final int duration;
  final LatLng startLocation;
  final LatLng endLocation;
  final String polyline;
  final RouteMode travelMode;
  final String? maneuver;

  const RouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    required this.polyline,
    required this.travelMode,
    this.maneuver,
  });

  @override
  List<Object?> get props => [
        instruction,
        distance,
        duration,
        startLocation,
        endLocation,
        polyline,
        travelMode,
        maneuver,
      ];
}

enum RouteMode {
  driving('driving', 'Araba'),
  walking('walking', 'Yürüme'),
  bicycling('bicycling', 'Bisiklet'),
  transit('transit', 'Toplu Taşıma');

  const RouteMode(this.value, this.displayName);
  final String value;
  final String displayName;
}

class GeocodingResult extends Equatable {
  final String formattedAddress;
  final List<AddressComponent> addressComponents;
  final Geometry geometry;
  final List<String> types;
  final double? partialMatch;
  final String placeId;

  const GeocodingResult({
    required this.formattedAddress,
    required this.addressComponents,
    required this.geometry,
    required this.types,
    this.partialMatch,
    required this.placeId,
  });

  @override
  List<Object?> get props => [formattedAddress, addressComponents, geometry, types, partialMatch, placeId];
}

class AddressComponent extends Equatable {
  final String longName;
  final String shortName;
  final List<String> types;

  const AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  bool get isStreetNumber => types.contains('street_number');
  bool get isRoute => types.contains('route');
  bool get isLocality => types.contains('locality');
  bool get isAdministrativeAreaLevel1 => types.contains('administrative_area_level_1');
  bool get isAdministrativeAreaLevel2 => types.contains('administrative_area_level_2');
  bool get isCountry => types.contains('country');
  bool get isPostalCode => types.contains('postal_code');

  @override
  List<Object?> get props => [longName, shortName, types];
}

class Geometry extends Equatable {
  final LatLng location;
  final String locationType;
  final MapBounds? viewport;
  final MapBounds? bounds;

  const Geometry({
    required this.location,
    required this.locationType,
    this.viewport,
    this.bounds,
  });

  @override
  List<Object?> get props => [location, locationType, viewport, bounds];
}

class MapSearchResult extends Equatable {
  final String id;
  final String title;
  final String description;
  final LatLng position;
  final String? imageUrl;
  final double? distance;
  final Map<String, dynamic>? data;

  const MapSearchResult({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    this.imageUrl,
    this.distance,
    this.data,
  });

  @override
  List<Object?> get props => [id, title, description, position, imageUrl, distance, data];
}

class MapSettingsEntity extends Equatable {
  final String id;
  final MapType defaultMapType;
  final MapStyle defaultMapStyle;
  final bool showTraffic;
  final bool showBuildings;
  final bool showIndoorMaps;
  final bool show3DModels;
  final bool enableLocationServices;
  final bool enableMyLocation;
  final bool enableCompass;
  final bool enableMapToolbar;
  final bool enableZoomControls;
  final bool enableRotateGestures;
  final bool enableScrollGestures;
  final bool enableTiltGestures;
  final bool enableAllGestures;
  final double minZoom;
  final double maxZoom;
  final int mapCacheSize;
  final Map<String, dynamic>? customSettings;

  const MapSettingsEntity({
    required this.id,
    this.defaultMapType = MapType.normal,
    this.defaultMapStyle = MapStyle.standard,
    this.showTraffic = false,
    this.showBuildings = true,
    this.showIndoorMaps = false,
    this.show3DModels = false,
    this.enableLocationServices = true,
    this.enableMyLocation = true,
    this.enableCompass = true,
    this.enableMapToolbar = true,
    this.enableZoomControls = true,
    this.enableRotateGestures = true,
    this.enableScrollGestures = true,
    this.enableTiltGestures = true,
    this.enableAllGestures = true,
    this.minZoom = 1.0,
    this.maxZoom = 20.0,
    this.mapCacheSize = 100,
    this.customSettings,
  });

  @override
  List<Object?> get props => [
        id,
        defaultMapType,
        defaultMapStyle,
        showTraffic,
        showBuildings,
        showIndoorMaps,
        show3DModels,
        enableLocationServices,
        enableMyLocation,
        enableCompass,
        enableMapToolbar,
        enableZoomControls,
        enableRotateGestures,
        enableScrollGestures,
        enableTiltGestures,
        enableAllGestures,
        minZoom,
        maxZoom,
        mapCacheSize,
        customSettings,
      ];
}

class UserLocationEntity extends Equatable {
  final String userId;
  final LocationEntity currentLocation;
  final LocationEntity? homeLocation;
  final LocationEntity? workLocation;
  final List<LocationEntity> savedLocations;
  final LocationAccuracy accuracy;
  final DateTime lastUpdated;
  final bool isLocationSharingEnabled;
  final Map<String, dynamic>? metadata;

  const UserLocationEntity({
    required this.userId,
    required this.currentLocation,
    this.homeLocation,
    this.workLocation,
    this.savedLocations = const [],
    this.accuracy = LocationAccuracy.medium,
    required this.lastUpdated,
    this.isLocationSharingEnabled = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        userId,
        currentLocation,
        homeLocation,
        workLocation,
        savedLocations,
        accuracy,
        lastUpdated,
        isLocationSharingEnabled,
        metadata,
      ];
}

enum LocationAccuracy {
  low('low', 'Düşük', 1000), // ~1km
  medium('medium', 'Orta', 100), // ~100m
  high('high', 'Yüksek', 10), // ~10m
  precise('precise', 'Hassas', 1); // ~1m

  const LocationAccuracy(this.value, this.displayName, this.accuracyMeters);
  final String value;
  final String displayName;
  final int accuracyMeters;
}
