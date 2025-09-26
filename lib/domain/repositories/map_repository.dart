import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/location.dart';

abstract class MapRepository {
  // Location Operations
  Future<Either<Failure, LocationEntity>> getCurrentLocation();

  Future<Either<Failure, LocationEntity>> getLocationFromAddress(String address);

  Future<Either<Failure, List<GeocodingResult>>> geocodeAddress(String address);

  Future<Either<Failure, String>> reverseGeocode(double latitude, double longitude);

  Future<Either<Failure, LocationEntity>> saveLocation(LocationEntity location);

  Future<Either<Failure, void>> deleteLocation(String locationId);

  Future<Either<Failure, List<LocationEntity>>> getSavedLocations(String userId);

  Future<Either<Failure, LocationEntity>> updateLocation(String locationId, LocationEntity location);

  // Place Operations
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces({
    String query,
    LatLng? location,
    double? radius,
    PlaceType? type,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, PlaceEntity>> getPlaceDetails(String placeId);

  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces({
    LatLng location,
    double radius = 1000,
    PlaceType? type,
    int limit = 20,
  });

  Future<Either<Failure, List<PlaceEntity>>> getPlacesByType(PlaceType type, {
    LatLng? location,
    int limit = 20,
  });

  // Route Operations
  Future<Either<Failure, RouteEntity>> getRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
    RouteMode mode = RouteMode.driving,
    RouteAvoidance avoidance = RouteAvoidance.none,
  });

  Future<Either<Failure, List<RouteEntity>>> getRouteAlternatives({
    required LatLng origin,
    required LatLng destination,
    RouteMode mode = RouteMode.driving,
  });

  // Map Operations
  Future<Either<Failure, MapEntity>> getMapData(MapBounds bounds, {
    MapType type = MapType.normal,
    MapStyle style = MapStyle.standard,
  });

  Future<Either<Failure, List<MapMarker>>> getMapMarkers(MapBounds bounds, {
    List<String>? categories,
    bool includeUserListings = true,
  });

  Future<Either<Failure, MapEntity>> updateMap(MapEntity map);

  // User Location Operations
  Future<Either<Failure, UserLocationEntity>> getUserLocation(String userId);

  Future<Either<Failure, UserLocationEntity>> updateUserLocation(String userId, LocationEntity location);

  Future<Either<Failure, void>> enableLocationSharing(String userId, bool enabled);

  Future<Either<Failure, void>> setHomeLocation(String userId, LocationEntity location);

  Future<Either<Failure, void>> setWorkLocation(String userId, LocationEntity location);

  Future<Either<Failure, List<UserLocationEntity>>> getNearbyUsers(String userId, {
    double radius = 5000, // 5km
    int limit = 20,
  });

  // Distance & Area Operations
  Future<Either<Failure, double>> calculateDistance(LatLng from, LatLng to);

  Future<Either<Failure, double>> calculateArea(List<LatLng> points);

  Future<Either<Failure, bool>> isPointInPolygon(LatLng point, List<LatLng> polygon);

  // Map Settings
  Future<Either<Failure, MapSettingsEntity>> getMapSettings();

  Future<Either<Failure, MapSettingsEntity>> updateMapSettings(MapSettingsEntity settings);

  Future<Either<Failure, void>> resetMapSettings();

  // Search Operations
  Future<Either<Failure, List<MapSearchResult>>> searchMap({
    String query,
    LatLng? location,
    double? radius,
    SearchType type = SearchType.general,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, List<String>>> getSearchSuggestions(String query, {
    LatLng? location,
    int limit = 10,
  });

  Future<Either<Failure, List<String>>> getRecentSearches(String userId, {
    int limit = 10,
  });

  Future<Either<Failure, void>> saveRecentSearch(String userId, String query);

  Future<Either<Failure, void>> clearRecentSearches(String userId);

  // Real-time Operations
  Stream<Either<Failure, LocationEntity>> subscribeToUserLocation(String userId);

  Stream<Either<Failure, List<MapMarker>>> subscribeToMapMarkers(MapBounds bounds);

  Stream<Either<Failure, List<UserLocationEntity>>> subscribeToNearbyUsers(String userId, double radius);

  // Cache Operations
  Future<Either<Failure, void>> refreshLocationCache(String userId);

  Future<Either<Failure, void>> refreshMapCache(MapBounds bounds);

  Future<Either<Failure, void>> clearMapCache();

  // Utility Operations
  Future<Either<Failure, bool>> checkLocationPermission();

  Future<Either<Failure, void>> requestLocationPermission();

  Future<Either<Failure, void>> openInMaps({
    LatLng? location,
    String? address,
    MapApp app = MapApp.googleMaps,
  });

  Future<Either<Failure, String>> getAddressFromCoordinates(double latitude, double longitude);

  Future<Either<Failure, LatLng>> getCoordinatesFromAddress(String address);
}

// Request/Response Models
class MapSearchRequest {
  final String query;
  final LatLng? location;
  final double? radius;
  final SearchType type;
  final Map<String, dynamic>? filters;
  final int page;
  final int limit;

  const MapSearchRequest({
    required this.query,
    this.location,
    this.radius,
    this.type = SearchType.general,
    this.filters,
    this.page = 1,
    this.limit = 20,
  });
}

enum SearchType {
  general('general', 'Genel'),
  places('places', 'Yerler'),
  addresses('addresses', 'Adresler'),
  nearby('nearby', 'Yakınlardaki');

  const SearchType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum MapApp {
  googleMaps('google_maps', 'Google Maps'),
  appleMaps('apple_maps', 'Apple Maps'),
  yandexMaps('yandex_maps', 'Yandex Maps'),
  other('other', 'Diğer');

  const MapApp(this.value, this.displayName);
  final String value;
  final String displayName;
}

class LocationUpdateRequest {
  final String userId;
  final LocationEntity location;
  final bool shareLocation;
  final Map<String, dynamic>? metadata;

  const LocationUpdateRequest({
    required this.userId,
    required this.location,
    this.shareLocation = false,
    this.metadata,
  });
}

class RouteRequest {
  final LatLng origin;
  final LatLng destination;
  final List<LatLng>? waypoints;
  final RouteMode mode;
  final RouteAvoidance avoidance;
  final bool alternatives;
  final Map<String, dynamic>? options;

  const RouteRequest({
    required this.origin,
    required this.destination,
    this.waypoints,
    this.mode = RouteMode.driving,
    this.avoidance = RouteAvoidance.none,
    this.alternatives = false,
    this.options,
  });
}

class PlaceSearchRequest {
  final String query;
  final LatLng? location;
  final double? radius;
  final PlaceType? type;
  final int page;
  final int limit;
  final Map<String, dynamic>? filters;

  const PlaceSearchRequest({
    required this.query,
    this.location,
    this.radius,
    this.type,
    this.page = 1,
    this.limit = 20,
    this.filters,
  });
}

class NearbyPlacesRequest {
  final LatLng center;
  final double radius;
  final PlaceType? type;
  final int limit;

  const NearbyPlacesRequest({
    required this.center,
    required this.radius,
    this.type,
    this.limit = 20,
  });
}

class GetPlacesRequest {
  final List<String> placeIds;

  const GetPlacesRequest(this.placeIds);
}

class RouteAlternativesRequest {
  final LatLng origin;
  final LatLng destination;
  final TravelMode mode;
  final List<LatLng>? waypoints;
  final bool avoidTolls;
  final bool avoidHighways;

  const RouteAlternativesRequest({
    required this.origin,
    required this.destination,
    required this.mode,
    this.waypoints,
    this.avoidTolls = false,
    this.avoidHighways = false,
  });
}

class MarkerRequest {
  final MarkerType type;
  final MapBounds? bounds;
  final List<String>? categories;
  final int limit;
  final bool includeUserMarkers;

  const MarkerRequest({
    required this.type,
    this.bounds,
    this.categories,
    this.limit = 100,
    this.includeUserMarkers = false,
  });
}

enum MarkerType {
  all('all', 'Tümü'),
  user('user', 'Kullanıcı'),
  business('business', 'İş Yeri'),
  event('event', 'Etkinlik'),
  favorite('favorite', 'Favori'),
  recent('recent', 'Son');

  const MarkerType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class MapDataRequest {
  final MapBounds bounds;
  final MapType type;
  final MapStyle style;
  final bool includeMarkers;
  final bool includeTraffic;
  final bool includeBuildings;
  final Map<String, dynamic>? options;

  const MapDataRequest({
    required this.bounds,
    required this.type,
    required this.style,
    this.includeMarkers = true,
    this.includeTraffic = false,
    this.includeBuildings = true,
    this.options,
  });
}

class GeofenceEntity extends Equatable {
  final String id;
  final String name;
  final LatLng center;
  final double radius;
  final GeofenceType type;
  final List<String> triggerEvents;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  const GeofenceEntity({
    required this.id,
    required this.name,
    required this.center,
    required this.radius,
    required this.type,
    required this.triggerEvents,
    this.isActive = true,
    this.metadata,
  });

  double get area => 3.14159 * radius * radius; // πr²

  @override
  List<Object?> get props => [id, name, center, radius, type, triggerEvents, isActive, metadata];
}

enum GeofenceType {
  circular('circular', 'Dairesel'),
  polygonal('polygonal', 'Çokgen');

  const GeofenceType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class TrafficDataEntity extends Equatable {
  final MapBounds bounds;
  final List<TrafficIncident> incidents;
  final Map<String, TrafficCondition> conditions;
  final DateTime lastUpdated;

  const TrafficDataEntity({
    required this.bounds,
    required this.incidents,
    required this.conditions,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [bounds, incidents, conditions, lastUpdated];
}

class TrafficIncident extends Equatable {
  final String id;
  final LatLng location;
  final TrafficIncidentType type;
  final TrafficSeverity severity;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final List<LatLng> affectedArea;

  const TrafficIncident({
    required this.id,
    required this.location,
    required this.type,
    required this.severity,
    required this.description,
    required this.startTime,
    this.endTime,
    this.affectedArea = const [],
  });

  bool get isActive => endTime == null || DateTime.now().isBefore(endTime!);

  @override
  List<Object?> get props => [id, location, type, severity, description, startTime, endTime, affectedArea];
}

enum TrafficIncidentType {
  accident('accident', 'Kaza'),
  construction('construction', 'İnşaat'),
  disabledVehicle('disabled_vehicle', 'Arızalı Araç'),
  massTransit('mass_transit', 'Toplu Taşıma'),
  miscellaneous('miscellaneous', 'Diğer'),
  plannedEvent('planned_event', 'Planlı Etkinlik'),
  roadHazard('road_hazard', 'Yol Tehlikesi'),
  weatherCondition('weather_condition', 'Hava Durumu');

  const TrafficIncidentType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum TrafficSeverity {
  unknown('unknown', 'Bilinmiyor'),
  minor('minor', 'Hafif'),
  moderate('moderate', 'Orta'),
  major('major', 'Ağır'),
  blocking('blocking', 'Engelleyici');

  const TrafficSeverity(this.value, this.displayName);
  final String value;
  final String displayName;
}

class TrafficCondition extends Equatable {
  final LatLng location;
  final TrafficSpeed speed;
  final String roadName;
  final DateTime timestamp;

  const TrafficCondition({
    required this.location,
    required this.speed,
    required this.roadName,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [location, speed, roadName, timestamp];
}

enum TrafficSpeed {
  unknown('unknown', 'Bilinmiyor'),
  freeFlow('free_flow', 'Serbest Akış'),
  slow('slow', 'Yavaş'),
  moderate('moderate', 'Orta'),
  heavy('heavy', 'Ağır'),
  standstill('standstill', 'Durma');

  const TrafficSpeed(this.value, this.displayName);
  final String value;
  final String displayName;
}
