import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/map_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/remote/map_remote_datasource.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource _remoteDataSource;

  const MapRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      return await _remoteDataSource.getCurrentLocation();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getLocationFromAddress(String address) async {
    try {
      return await _remoteDataSource.getLocationFromAddress(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GeocodingResult>>> geocodeAddress(String address) async {
    try {
      return await _remoteDataSource.geocodeAddress(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> reverseGeocode(double latitude, double longitude) async {
    try {
      return await _remoteDataSource.reverseGeocode(latitude, longitude);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> saveLocation(LocationEntity location) async {
    try {
      return await _remoteDataSource.saveLocation(location);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLocation(String locationId) async {
    try {
      return await _remoteDataSource.deleteLocation(locationId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getSavedLocations(String userId) async {
    try {
      return await _remoteDataSource.getSavedLocations(userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> updateLocation(String locationId, LocationEntity location) async {
    try {
      return await _remoteDataSource.updateLocation(locationId, location);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces({
    String query,
    LatLng? location,
    double? radius,
    PlaceType? type,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final request = PlaceSearchRequest(
        query: query,
        location: location,
        radius: radius,
        type: type,
        page: page,
        limit: limit,
      );

      return await _remoteDataSource.searchPlaces(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlaceEntity>> getPlaceDetails(String placeId) async {
    try {
      return await _remoteDataSource.getPlaceDetails(placeId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces({
    LatLng location,
    double radius = 1000,
    PlaceType? type,
    int limit = 20,
  }) async {
    try {
      final request = NearbyPlacesRequest(
        latitude: location.latitude,
        longitude: location.longitude,
        radius: radius,
        type: type,
        limit: limit,
      );

      return await _remoteDataSource.getNearbyPlaces(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlacesByType(PlaceType type, {
    LatLng? location,
    int limit = 20,
  }) async {
    try {
      final request = GetPlacesRequest(
        type: type,
        location: location,
        limit: limit,
      );

      return await _remoteDataSource.getPlacesByType(type, request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> getRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
    RouteMode mode = RouteMode.driving,
    RouteAvoidance avoidance = RouteAvoidance.none,
  }) async {
    try {
      final request = RouteRequest(
        origin: origin,
        destination: destination,
        waypoints: waypoints,
        mode: mode,
        avoidance: avoidance,
      );

      return await _remoteDataSource.getRoute(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RouteEntity>>> getRouteAlternatives({
    required LatLng origin,
    required LatLng destination,
    RouteMode mode = RouteMode.driving,
  }) async {
    try {
      final request = RouteAlternativesRequest(
        origin: origin,
        destination: destination,
        mode: mode,
      );

      return await _remoteDataSource.getRouteAlternatives(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MapEntity>> getMapData(MapBounds bounds, {
    MapType type = MapType.normal,
    MapStyle style = MapStyle.standard,
  }) async {
    try {
      final request = MapDataRequest(
        bounds: bounds,
        type: type,
        style: style,
      );

      return await _remoteDataSource.getMapData(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MapMarker>>> getMapMarkers(MapBounds bounds, {
    List<String>? categories,
    bool includeUserListings = true,
  }) async {
    try {
      final request = MarkerRequest(
        bounds: bounds,
        categories: categories,
        includeUserListings: includeUserListings,
      );

      return await _remoteDataSource.getMapMarkers(bounds, request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MapEntity>> updateMap(MapEntity map) async {
    try {
      return await _remoteDataSource.updateMap(map);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocationEntity>> getUserLocation(String userId) async {
    try {
      return await _remoteDataSource.getUserLocation(userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocationEntity>> updateUserLocation(String userId, LocationEntity location) async {
    try {
      return await _remoteDataSource.updateUserLocation(userId, location);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableLocationSharing(String userId, bool enabled) async {
    try {
      return await _remoteDataSource.enableLocationSharing(userId, enabled);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setHomeLocation(String userId, LocationEntity location) async {
    try {
      return await _remoteDataSource.setHomeLocation(userId, location);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setWorkLocation(String userId, LocationEntity location) async {
    try {
      return await _remoteDataSource.setWorkLocation(userId, location);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserLocationEntity>>> getNearbyUsers(String userId, {
    double radius = 5000,
    int limit = 20,
  }) async {
    try {
      final request = NearbyUsersRequest(
        userId: userId,
        radius: radius,
        limit: limit,
      );

      return await _remoteDataSource.getNearbyUsers(userId, request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> calculateDistance(LatLng from, LatLng to) async {
    try {
      return await _remoteDataSource.calculateDistance(from, to);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> calculateArea(List<LatLng> points) async {
    try {
      return await _remoteDataSource.calculateArea(points);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isPointInPolygon(LatLng point, List<LatLng> polygon) async {
    try {
      return await _remoteDataSource.isPointInPolygon(point, polygon);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MapSettingsEntity>> getMapSettings() async {
    try {
      return await _remoteDataSource.getMapSettings();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MapSettingsEntity>> updateMapSettings(MapSettingsEntity settings) async {
    try {
      return await _remoteDataSource.updateMapSettings(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetMapSettings() async {
    try {
      return await _remoteDataSource.resetMapSettings();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MapSearchResult>>> searchMap({
    String query,
    LatLng? location,
    double? radius,
    SearchType type = SearchType.general,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final request = MapSearchRequest(
        query: query,
        location: location,
        radius: radius,
        type: type,
        page: page,
        limit: limit,
      );

      return await _remoteDataSource.searchMap(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions(String query, {
    LatLng? location,
    int limit = 10,
  }) async {
    try {
      final request = SearchSuggestionsRequest(
        query: query,
        location: location,
        limit: limit,
      );

      return await _remoteDataSource.getSearchSuggestions(query, request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches(String userId, {
    int limit = 10,
  }) async {
    try {
      return await _remoteDataSource.getRecentSearches(userId, limit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveRecentSearch(String userId, String query) async {
    try {
      return await _remoteDataSource.saveRecentSearch(userId, query);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearRecentSearches(String userId) async {
    try {
      return await _remoteDataSource.clearRecentSearches(userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocationPermission() async {
    try {
      return await _remoteDataSource.checkLocationPermission();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestLocationPermission() async {
    try {
      return await _remoteDataSource.requestLocationPermission();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> openInMaps({
    LatLng? location,
    String? address,
    MapApp app = MapApp.googleMaps,
  }) async {
    try {
      final request = OpenInMapsRequest(
        location: location,
        address: address,
        app: app,
      );

      return await _remoteDataSource.openInMaps(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      return await _remoteDataSource.getAddressFromCoordinates(latitude, longitude);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LatLng>> getCoordinatesFromAddress(String address) async {
    try {
      return await _remoteDataSource.getCoordinatesFromAddress(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
