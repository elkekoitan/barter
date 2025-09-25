import 'package:dartz/dartz.dart';
import '../../repositories/map_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/location.dart';

class GetCurrentLocationUseCase {
  final MapRepository _repository;

  const GetCurrentLocationUseCase(this._repository);

  Future<Either<Failure, LocationEntity>> call() async {
    try {
      // Check permission first
      final permissionResult = await _repository.checkLocationPermission();
      if (permissionResult.isLeft()) {
        return Left(PermissionFailure('Location permission required'));
      }

      if (!permissionResult.getOrElse(() => false)) {
        await _repository.requestLocationPermission();
      }

      return await _repository.getCurrentLocation();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class SearchPlacesUseCase {
  final MapRepository _repository;

  const SearchPlacesUseCase(this._repository);

  Future<Either<Failure, List<PlaceEntity>>> call({
    required String query,
    LatLng? location,
    double? radius = 1000,
    PlaceType? type,
    int page = 1,
    int limit = 20,
  }) async {
    // Validation
    if (query.isEmpty) {
      return const Left(ValidationFailure('Search query cannot be empty'));
    }

    if (query.length < 2) {
      return const Left(ValidationFailure('Search query too short'));
    }

    if (radius != null && radius <= 0) {
      return const Left(ValidationFailure('Radius must be positive'));
    }

    if (page < 1) {
      return const Left(ValidationFailure('Page must be greater than 0'));
    }

    if (limit < 1 || limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await _repository.searchPlaces(
      query: query,
      location: location,
      radius: radius,
      type: type,
      page: page,
      limit: limit,
    );
  }
}

class GetNearbyPlacesUseCase {
  final MapRepository _repository;

  const GetNearbyPlacesUseCase(this._repository);

  Future<Either<Failure, List<PlaceEntity>>> call({
    required LatLng location,
    double radius = 1000,
    PlaceType? type,
    int limit = 20,
  }) async {
    // Validation
    if (radius <= 0 || radius > 50000) { // Max 50km
      return const Left(ValidationFailure('Radius must be between 1 and 50,000 meters'));
    }

    if (limit < 1 || limit > 100) {
      return const Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    return await _repository.getNearbyPlaces(
      location: location,
      radius: radius,
      type: type,
      limit: limit,
    );
  }
}

class GetRouteUseCase {
  final MapRepository _repository;

  const GetRouteUseCase(this._repository);

  Future<Either<Failure, RouteEntity>> call({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
    RouteMode mode = RouteMode.driving,
    RouteAvoidance avoidance = RouteAvoidance.none,
  }) async {
    // Validation
    if (waypoints != null && waypoints.length > 23) { // Google Maps limit
      return const Left(ValidationFailure('Too many waypoints (max 23)'));
    }

    return await _repository.getRoute(
      origin: origin,
      destination: destination,
      waypoints: waypoints,
      mode: mode,
      avoidance: avoidance,
    );
  }
}

class CalculateDistanceUseCase {
  final MapRepository _repository;

  const CalculateDistanceUseCase(this._repository);

  Future<Either<Failure, double>> call(LatLng from, LatLng to) async {
    // Basic validation
    if (from.latitude < -90 || from.latitude > 90) {
      return const Left(ValidationFailure('Invalid latitude for origin'));
    }

    if (from.longitude < -180 || from.longitude > 180) {
      return const Left(ValidationFailure('Invalid longitude for origin'));
    }

    if (to.latitude < -90 || to.latitude > 90) {
      return const Left(ValidationFailure('Invalid latitude for destination'));
    }

    if (to.longitude < -180 || to.longitude > 180) {
      return const Left(ValidationFailure('Invalid longitude for destination'));
    }

    return await _repository.calculateDistance(from, to);
  }
}

class GeocodeAddressUseCase {
  final MapRepository _repository;

  const GeocodeAddressUseCase(this._repository);

  Future<Either<Failure, List<GeocodingResult>>> call(String address) async {
    if (address.isEmpty) {
      return const Left(ValidationFailure('Address cannot be empty'));
    }

    if (address.length < 3) {
      return const Left(ValidationFailure('Address too short'));
    }

    return await _repository.geocodeAddress(address);
  }
}

class ReverseGeocodeUseCase {
  final MapRepository _repository;

  const ReverseGeocodeUseCase(this._repository);

  Future<Either<Failure, String>> call(double latitude, double longitude) async {
    if (latitude < -90 || latitude > 90) {
      return const Left(ValidationFailure('Invalid latitude'));
    }

    if (longitude < -180 || longitude > 180) {
      return const Left(ValidationFailure('Invalid longitude'));
    }

    return await _repository.reverseGeocode(latitude, longitude);
  }
}

class SaveLocationUseCase {
  final MapRepository _repository;

  const SaveLocationUseCase(this._repository);

  Future<Either<Failure, LocationEntity>> call(LocationEntity location) async {
    if (location.address.isEmpty) {
      return const Left(ValidationFailure('Address cannot be empty'));
    }

    if (location.city.isEmpty) {
      return const Left(ValidationFailure('City cannot be empty'));
    }

    if (location.country.isEmpty) {
      return const Left(ValidationFailure('Country cannot be empty'));
    }

    if (!location.isValid) {
      return const Left(ValidationFailure('Invalid location coordinates'));
    }

    return await _repository.saveLocation(location);
  }
}

class GetSavedLocationsUseCase {
  final MapRepository _repository;

  const GetSavedLocationsUseCase(this._repository);

  Future<Either<Failure, List<LocationEntity>>> call(String userId) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await _repository.getSavedLocations(userId);
  }
}

class SearchMapUseCase {
  final MapRepository _repository;

  const SearchMapUseCase(this._repository);

  Future<Either<Failure, List<MapSearchResult>>> call({
    required String query,
    LatLng? location,
    double? radius,
    SearchType type = SearchType.general,
    int page = 1,
    int limit = 20,
  }) async {
    if (query.isEmpty) {
      return const Left(ValidationFailure('Search query cannot be empty'));
    }

    if (query.length < 2) {
      return const Left(ValidationFailure('Search query too short'));
    }

    if (page < 1) {
      return const Left(ValidationFailure('Page must be greater than 0'));
    }

    if (limit < 1 || limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await _repository.searchMap(
      query: query,
      location: location,
      radius: radius,
      type: type,
      page: page,
      limit: limit,
    );
  }
}

class GetMapMarkersUseCase {
  final MapRepository _repository;

  const GetMapMarkersUseCase(this._repository);

  Future<Either<Failure, List<MapMarker>>> call(MapBounds bounds, {
    List<String>? categories,
    bool includeUserListings = true,
  }) async {
    if (bounds.width <= 0 || bounds.height <= 0) {
      return const Left(ValidationFailure('Invalid map bounds'));
    }

    return await _repository.getMapMarkers(
      bounds,
      categories: categories,
      includeUserListings: includeUserListings,
    );
  }
}

class UpdateUserLocationUseCase {
  final MapRepository _repository;

  const UpdateUserLocationUseCase(this._repository);

  Future<Either<Failure, UserLocationEntity>> call(String userId, LocationEntity location) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    if (!location.isValid) {
      return const Left(ValidationFailure('Invalid location'));
    }

    return await _repository.updateUserLocation(userId, location);
  }
}

class EnableLocationSharingUseCase {
  final MapRepository _repository;

  const EnableLocationSharingUseCase(this._repository);

  Future<Either<Failure, void>> call(String userId, bool enabled) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await _repository.enableLocationSharing(userId, enabled);
  }
}

class GetNearbyUsersUseCase {
  final MapRepository _repository;

  const GetNearbyUsersUseCase(this._repository);

  Future<Either<Failure, List<UserLocationEntity>>> call(String userId, {
    double radius = 5000,
    int limit = 20,
  }) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    if (radius <= 0 || radius > 100000) { // Max 100km
      return const Left(ValidationFailure('Radius must be between 1 and 100,000 meters'));
    }

    if (limit < 1 || limit > 100) {
      return const Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    return await _repository.getNearbyUsers(
      userId,
      radius: radius,
      limit: limit,
    );
  }
}

class OpenInMapsUseCase {
  final MapRepository _repository;

  const OpenInMapsUseCase(this._repository);

  Future<Either<Failure, void>> call({
    LatLng? location,
    String? address,
    MapApp app = MapApp.googleMaps,
  }) async {
    if (location == null && (address == null || address!.isEmpty)) {
      return const Left(ValidationFailure('Either location or address must be provided'));
    }

    if (location != null) {
      if (location.latitude < -90 || location.latitude > 90) {
        return const Left(ValidationFailure('Invalid latitude'));
      }

      if (location.longitude < -180 || location.longitude > 180) {
        return const Left(ValidationFailure('Invalid longitude'));
      }
    }

    return await _repository.openInMaps(
      location: location,
      address: address,
      app: app,
    );
  }
}

class GetMapDataUseCase {
  final MapRepository _repository;

  const GetMapDataUseCase(this._repository);

  Future<Either<Failure, MapEntity>> call(MapBounds bounds, {
    MapType type = MapType.normal,
    MapStyle style = MapStyle.standard,
  }) async {
    if (bounds.width <= 0 || bounds.height <= 0) {
      return const Left(ValidationFailure('Invalid map bounds'));
    }

    return await _repository.getMapData(
      bounds,
      type: type,
      style: style,
    );
  }
}

class CheckLocationPermissionUseCase {
  final MapRepository _repository;

  const CheckLocationPermissionUseCase(this._repository);

  Future<Either<Failure, bool>> call() async {
    return await _repository.checkLocationPermission();
  }
}

class RequestLocationPermissionUseCase {
  final MapRepository _repository;

  const RequestLocationPermissionUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.requestLocationPermission();
  }
}

class GetPlaceDetailsUseCase {
  final MapRepository _repository;

  const GetPlaceDetailsUseCase(this._repository);

  Future<Either<Failure, PlaceEntity>> call(String placeId) async {
    if (placeId.isEmpty) {
      return const Left(ValidationFailure('Place ID cannot be empty'));
    }

    return await _repository.getPlaceDetails(placeId);
  }
}

class GetPlacesByTypeUseCase {
  final MapRepository _repository;

  const GetPlacesByTypeUseCase(this._repository);

  Future<Either<Failure, List<PlaceEntity>>> call(PlaceType type, {
    LatLng? location,
    int limit = 20,
  }) async {
    if (limit < 1 || limit > 100) {
      return const Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    return await _repository.getPlacesByType(
      type,
      location: location,
      limit: limit,
    );
  }
}

class GetCoordinatesFromAddressUseCase {
  final MapRepository _repository;

  const GetCoordinatesFromAddressUseCase(this._repository);

  Future<Either<Failure, LatLng>> call(String address) async {
    if (address.isEmpty) {
      return const Left(ValidationFailure('Address cannot be empty'));
    }

    if (address.length < 3) {
      return const Left(ValidationFailure('Address too short'));
    }

    return await _repository.getCoordinatesFromAddress(address);
  }
}

class GetAddressFromCoordinatesUseCase {
  final MapRepository _repository;

  const GetAddressFromCoordinatesUseCase(this._repository);

  Future<Either<Failure, String>> call(double latitude, double longitude) async {
    if (latitude < -90 || latitude > 90) {
      return const Left(ValidationFailure('Invalid latitude'));
    }

    if (longitude < -180 || longitude > 180) {
      return const Left(ValidationFailure('Invalid longitude'));
    }

    return await _repository.getAddressFromCoordinates(latitude, longitude);
  }
}
