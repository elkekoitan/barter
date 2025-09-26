import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../../../core/errors/failures.dart';
import '../../../domain/repositories/map_repository.dart';
import '../../../domain/entities/location_entity.dart' as location_entity;
import '../../../domain/entities/location.dart';

abstract class MapRemoteDataSource {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();
  Future<Either<Failure, LocationEntity>> getLocationFromAddress(String address);
  Future<Either<Failure, List<GeocodingResult>>> geocodeAddress(String address);
  Future<Either<Failure, String>> reverseGeocode(double latitude, double longitude);
  Future<Either<Failure, LocationEntity>> saveLocation(LocationEntity location);
  Future<Either<Failure, void>> deleteLocation(String locationId);
  Future<Either<Failure, List<LocationEntity>>> getSavedLocations(String userId);
  Future<Either<Failure, LocationEntity>> updateLocation(String locationId, LocationEntity location);
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(PlaceSearchRequest request);
  Future<Either<Failure, PlaceEntity>> getPlaceDetails(String placeId);
  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces(NearbyPlacesRequest request);
  Future<Either<Failure, List<PlaceEntity>>> getPlacesByType(PlaceType type, GetPlacesRequest request);
  Future<Either<Failure, RouteEntity>> getRoute(RouteRequest request);
  Future<Either<Failure, List<RouteEntity>>> getRouteAlternatives(RouteAlternativesRequest request);
  Future<Either<Failure, MapEntity>> getMapData(MapDataRequest request);
  Future<Either<Failure, List<MapMarker>>> getMapMarkers(MapBounds bounds, MarkerRequest request);
  Future<Either<Failure, MapEntity>> updateMap(MapEntity map);
  Future<Either<Failure, UserLocationEntity>> getUserLocation(String userId);
  Future<Either<Failure, UserLocationEntity>> updateUserLocation(String userId, location_entity.LocationEntity location);
  Future<Either<Failure, void>> enableLocationSharing(String userId, bool enabled);
  Future<Either<Failure, void>> setHomeLocation(String userId, location_entity.LocationEntity location);
  Future<Either<Failure, void>> setWorkLocation(String userId, location_entity.LocationEntity location);
  Future<Either<Failure, List<UserLocationEntity>>> getNearbyUsers(String userId, NearbyUsersRequest request);
  Future<Either<Failure, double>> calculateDistance(LatLng from, LatLng to);
  Future<Either<Failure, double>> calculateArea(List<LatLng> points);
  Future<Either<Failure, bool>> isPointInPolygon(LatLng point, List<LatLng> polygon);
  Future<Either<Failure, MapSettingsEntity>> getMapSettings();
  Future<Either<Failure, MapSettingsEntity>> updateMapSettings(MapSettingsEntity settings);
  Future<Either<Failure, void>> resetMapSettings();
  Future<Either<Failure, List<MapSearchResult>>> searchMap(MapSearchRequest request);
  Future<Either<Failure, List<String>>> getSearchSuggestions(String query, SearchSuggestionsRequest request);
  Future<Either<Failure, List<String>>> getRecentSearches(String userId, int limit);
  Future<Either<Failure, void>> saveRecentSearch(String userId, String query);
  Future<Either<Failure, void>> clearRecentSearches(String userId);
  Future<Either<Failure, bool>> checkLocationPermission();
  Future<Either<Failure, void>> requestLocationPermission();
  Future<Either<Failure, void>> openInMaps(OpenInMapsRequest request);
  Future<Either<Failure, String>> getAddressFromCoordinates(double latitude, double longitude);
  Future<Either<Failure, LatLng>> getCoordinatesFromAddress(String address);
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final GoogleMapController? _mapController;
  final String _googleMapsApiKey;

  MapRemoteDataSourceImpl({
    GoogleMapController? mapController,
    required String googleMapsApiKey,
  })  : _mapController = mapController,
        _googleMapsApiKey = googleMapsApiKey;

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      // Check permission
      geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission == geolocator.LocationPermission.denied) {
          return const Left(PermissionFailure('Location permission denied'));
        }
      }

      if (permission == geolocator.LocationPermission.deniedForever) {
        return const Left(PermissionFailure('Location permission permanently denied'));
      }

      // Get current position
      final position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return const Left(ServerFailure('Could not get address for current location'));
      }

      final placemark = placemarks.first;

      final location = LocationEntity(
        id: 'current_${DateTime.now().millisecondsSinceEpoch}',
        address: '${placemark.street ?? ''} ${placemark.name ?? ''}'.trim(),
        city: placemark.locality ?? '',
        district: placemark.subLocality ?? '',
        country: placemark.country ?? '',
        postalCode: placemark.postalCode ?? '',
        latitude: position.latitude,
        longitude: position.longitude,
        type: LocationType.address,
        isVerified: true,
        createdAt: DateTime.now(),
      );

      return Right(location);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getLocationFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isEmpty) {
        return const Left(ServerFailure('No locations found for address'));
      }

      final location = locations.first;
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      final placemark = placemarks.isNotEmpty ? placemarks.first : null;

      final locationEntity = LocationEntity(
        id: 'search_${DateTime.now().millisecondsSinceEpoch}',
        address: address,
        city: placemark?.locality ?? '',
        district: placemark?.subLocality ?? '',
        country: placemark?.country ?? '',
        postalCode: placemark?.postalCode ?? '',
        latitude: location.latitude,
        longitude: location.longitude,
        type: LocationType.address,
        createdAt: DateTime.now(),
      );

      return Right(locationEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GeocodingResult>>> geocodeAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isEmpty) {
        return const Right([]);
      }

      final geocodingResults = await Future.wait(
        locations.map((location) async {
          final placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          final placemark = placemarks.isNotEmpty ? placemarks.first : null;

          final geometry = Geometry(
            location: LatLng(location.latitude, location.longitude),
            locationType: 'rooftop',
          );

          final addressComponents = <AddressComponent>[];

          if (placemark != null) {
            if (placemark.street != null) {
              addressComponents.add(AddressComponent(
                longName: placemark.street!,
                shortName: placemark.street!,
                types: ['route'],
              ));
            }

            if (placemark.locality != null) {
              addressComponents.add(AddressComponent(
                longName: placemark.locality!,
                shortName: placemark.locality!,
                types: ['locality'],
              ));
            }

            if (placemark.country != null) {
              addressComponents.add(AddressComponent(
                longName: placemark.country!,
                shortName: placemark.country!,
                types: ['country'],
              ));
            }
          }

          return GeocodingResult(
            formattedAddress: address,
            addressComponents: addressComponents,
            geometry: geometry,
            types: ['geocode'],
            placeId: 'geocode_${location.latitude}_${location.longitude}',
          );
        }),
      );

      return Right(geocodingResults);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> reverseGeocode(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return const Left(ServerFailure('Could not get address for coordinates'));
      }

      final placemark = placemarks.first;
      final addressParts = <String>[];

      if (placemark.street != null && placemark.street!.isNotEmpty) {
        addressParts.add(placemark.street!);
      }

      if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
        addressParts.add(placemark.subLocality!);
      }

      if (placemark.locality != null && placemark.locality!.isNotEmpty) {
        addressParts.add(placemark.locality!);
      }

      if (placemark.country != null && placemark.country!.isNotEmpty) {
        addressParts.add(placemark.country!);
      }

      return Right(addressParts.join(', '));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> saveLocation(LocationEntity location) async {
    try {
      // In a real implementation, this would save to a backend API
      debugPrint('Saving location: ${location.address}');
      return Right(location_entity.LocationEntity(
        id: 'saved_${DateTime.now().millisecondsSinceEpoch}',
        userId: location.userId,
        latitude: location.latitude,
        longitude: location.longitude,
        address: location.address,
        city: location.city,
        district: location.district,
        neighborhood: location.neighborhood,
        country: location.country,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: location.isActive,
        type: location_entity.LocationType.current,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLocation(String locationId) async {
    try {
      debugPrint('Deleting location: $locationId');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getSavedLocations(String userId) async {
    try {
      // In a real implementation, this would fetch from backend API
      debugPrint('Getting saved locations for user: $userId');
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> updateLocation(String locationId, LocationEntity location) async {
    try {
      debugPrint('Updating location: $locationId');
      return Right(location_entity.LocationEntity(
        id: locationId,
        userId: location.userId,
        latitude: location.latitude,
        longitude: location.longitude,
        address: location.address,
        city: location.city,
        district: location.district,
        neighborhood: location.neighborhood,
        country: location.country,
        createdAt: location.createdAt,
        updatedAt: DateTime.now(),
        isActive: location.isActive,
        type: location_entity.LocationType.current,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(PlaceSearchRequest request) async {
    try {
      // Use Google Places API
      final url = Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(request.query)}&key=$_googleMapsApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        final places = results.map((result) {
          final location = result['geometry']['location'];
          return PlaceEntity(
            placeId: result['place_id'],
            name: result['name'],
            address: result['formatted_address'],
            city: '',
            country: '',
            latitude: location['lat'],
            longitude: location['lng'],
            rating: result['rating']?.toDouble(),
            userRatingsTotal: result['user_ratings_total'],
            type: PlaceType.other,
          );
        }).toList();

        return Right(places);
      } else {
        return Left(ServerFailure('Failed to search places'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlaceEntity>> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleMapsApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];

        final location = result['geometry']['location'];
        return Right(PlaceEntity(
          placeId: placeId,
          name: result['name'],
          address: result['formatted_address'],
          city: '',
          country: '',
          latitude: location['lat'],
          longitude: location['lng'],
          rating: result['rating']?.toDouble(),
          userRatingsTotal: result['user_ratings_total'],
          phoneNumber: result['formatted_phone_number'],
          website: result['website'],
          type: PlaceType.other,
        ));
      } else {
        return Left(ServerFailure('Failed to get place details'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces(NearbyPlacesRequest request) async {
    try {
      final url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${request.latitude},${request.longitude}&radius=${request.radius}&type=${request.type?.value ?? 'establishment'}&key=$_googleMapsApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        final places = results.map((result) {
          final location = result['geometry']['location'];
          return PlaceEntity(
            placeId: result['place_id'],
            name: result['name'],
            address: result['vicinity'],
            city: '',
            country: '',
            latitude: location['lat'],
            longitude: location['lng'],
            rating: result['rating']?.toDouble(),
            userRatingsTotal: result['user_ratings_total'],
            type: request.type ?? PlaceType.other,
          );
        }).toList();

        return Right(places);
      } else {
        return Left(ServerFailure('Failed to get nearby places'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlacesByType(PlaceType type, GetPlacesRequest request) async {
    try {
      // Similar to searchPlaces but filtered by type
      final url = Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(type.displayName)}&key=$_googleMapsApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        final places = results.map((result) {
          final location = result['geometry']['location'];
          return PlaceEntity(
            placeId: result['place_id'],
            name: result['name'],
            address: result['formatted_address'],
            city: '',
            country: '',
            latitude: location['lat'],
            longitude: location['lng'],
            rating: result['rating']?.toDouble(),
            userRatingsTotal: result['user_ratings_total'],
            type: type,
          );
        }).toList();

        return Right(places);
      } else {
        return Left(ServerFailure('Failed to get places by type'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> getRoute(RouteRequest request) async {
    try {
      final origin = '${request.origin.latitude},${request.origin.longitude}';
      final destination = '${request.destination.latitude},${request.destination.longitude}';

      String waypoints = '';
      if (request.waypoints != null && request.waypoints.isNotEmpty) {
        waypoints = '&waypoints=${request.waypoints.map((w) => '${w.latitude},${w.longitude}').join('|')}';
      }

      final url = Uri.parse('https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination$waypoints&mode=${request.mode.value}&avoid=${request.avoidance.value}&key=$_googleMapsApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0];

        final polyline = route['overview_polyline']['points'];
        final legs = route['legs'][0];

        final steps = legs['steps'].map<RouteStep>((step) {
          final startLocation = step['start_location'];
          final endLocation = step['end_location'];

          return RouteStep(
            instruction: step['html_instructions'].replaceAll('<[^>]*>', ''),
            distance: step['distance']['value'] / 1000.0, // Convert to km
            duration: step['duration']['value'], // In seconds
            startLocation: LatLng(startLocation['lat'], startLocation['lng']),
            endLocation: LatLng(endLocation['lat'], endLocation['lng']),
            polyline: step['polyline']['points'],
            travelMode: RouteMode.values.firstWhere(
              (mode) => mode.value == step['travel_mode'].toLowerCase(),
              orElse: () => RouteMode.driving,
            ),
            maneuver: step['maneuver'],
          );
        }).toList();

        final routeEntity = RouteEntity(
          id: 'route_${DateTime.now().millisecondsSinceEpoch}',
          startPoint: request.origin,
          endPoint: request.destination,
          waypoints: request.waypoints ?? [],
          mode: request.mode,
          avoidance: request.avoidance,
          distance: legs['distance']['value'] / 1000.0, // Convert to km
          duration: legs['duration']['value'], // In seconds
          steps: steps,
          polyline: polyline,
        );

        return Right(routeEntity);
      } else {
        return Left(ServerFailure('Failed to get route'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RouteEntity>>> getRouteAlternatives(RouteAlternativesRequest request) async {
    try {
      // Similar to getRoute but with alternatives=true
      final origin = '${request.origin.latitude},${request.origin.longitude}';
      final destination = '${request.destination.latitude},${request.destination.longitude}';

      final url = Uri.parse('https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&alternatives=true&mode=${request.mode.value}&key=$_googleMapsApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routes = data['routes'] as List;

        final routeEntities = routes.map((route) {
          final legs = route['legs'][0];

          return RouteEntity(
            id: 'route_alt_${routes.indexOf(route)}',
            startPoint: request.origin,
            endPoint: request.destination,
            mode: request.mode,
            distance: legs['distance']['value'] / 1000.0,
            duration: legs['duration']['value'],
            polyline: route['overview_polyline']['points'],
          );
        }).toList();

        return Right(routeEntities);
      } else {
        return Left(ServerFailure('Failed to get route alternatives'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MapEntity>> getMapData(MapDataRequest request) async {
    try {
      // Return a basic map entity
      final mapEntity = MapEntity(
        id: 'map_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Map Data',
        type: request.type,
        bounds: request.bounds,
        style: request.style,
        center: request.bounds.northeast,
        zoom: 15.0,
      );

      return Right(mapEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MapMarker>>> getMapMarkers(MapBounds bounds, MarkerRequest request) async {
    try {
      // In a real implementation, this would fetch markers from backend
      debugPrint('Getting map markers for bounds: ${bounds.northeast.latitude}, ${bounds.northeast.longitude}');
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MapEntity>> updateMap(MapEntity map) async {
    try {
      debugPrint('Updating map: ${map.name}');
      return Right(map);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocationEntity>> getUserLocation(String userId) async {
    try {
      debugPrint('Getting user location: $userId');
      // In a real implementation, this would fetch from backend
      return Left(ServerFailure('Not implemented'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocationEntity>> updateUserLocation(String userId, location_entity.LocationEntity location) async {
    try {
      debugPrint('Updating user location: $userId');
      // In a real implementation, this would update in backend
      return Left(ServerFailure('Not implemented'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableLocationSharing(String userId, bool enabled) async {
    try {
      debugPrint('Enabling location sharing for user: $userId, enabled: $enabled');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setHomeLocation(String userId, location_entity.LocationEntity location) async {
    try {
      debugPrint('Setting home location for user: $userId');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setWorkLocation(String userId, location_entity.LocationEntity location) async {
    try {
      debugPrint('Setting work location for user: $userId');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserLocationEntity>>> getNearbyUsers(String userId, NearbyUsersRequest request) async {
    try {
      debugPrint('Getting nearby users for: $userId');
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> calculateDistance(LatLng from, LatLng to) async {
    try {
      return Right(geolocator.Geolocator.distanceBetween(from.latitude, from.longitude, to.latitude, to.longitude) / 1000.0); // Convert to km
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> calculateArea(List<LatLng> points) async {
    try {
      if (points.length < 3) {
        return const Right(0.0);
      }

      // Calculate area using shoelace formula
      double area = 0.0;
      for (int i = 0; i < points.length; i++) {
        final j = (i + 1) % points.length;
        area += points[i].longitude * points[j].latitude;
        area -= points[j].longitude * points[i].latitude;
      }
      area = (area.abs() / 2.0) * 111319.9 * 111319.9; // Convert to square meters

      return Right(area);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isPointInPolygon(LatLng point, List<LatLng> polygon) async {
    try {
      // Ray casting algorithm
      int intersectCount = 0;
      for (int i = 0; i < polygon.length; i++) {
        final j = (i + 1) % polygon.length;
        if (_doIntersect(polygon[i], polygon[j], point, LatLng(point.latitude + 90, point.longitude + 180))) {
          intersectCount++;
        }
      }

      return Right(intersectCount % 2 == 1);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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
  Future<Either<Failure, MapSettingsEntity>> getMapSettings() async {
    try {
      debugPrint('Getting map settings');
      return Right(const MapSettingsEntity(id: 'default'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MapSettingsEntity>> updateMapSettings(MapSettingsEntity settings) async {
    try {
      debugPrint('Updating map settings');
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetMapSettings() async {
    try {
      debugPrint('Resetting map settings');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MapSearchResult>>> searchMap(MapSearchRequest request) async {
    try {
      debugPrint('Searching map: ${request.query}');
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions(String query, SearchSuggestionsRequest request) async {
    try {
      debugPrint('Getting search suggestions: $query');
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches(String userId, int limit) async {
    try {
      debugPrint('Getting recent searches for user: $userId');
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveRecentSearch(String userId, String query) async {
    try {
      debugPrint('Saving recent search for user: $userId, query: $query');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearRecentSearches(String userId) async {
    try {
      debugPrint('Clearing recent searches for user: $userId');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocationPermission() async {
    try {
      final permission = await geolocator.Geolocator.checkPermission();
      return Right(permission == geolocator.LocationPermission.always || permission == geolocator.LocationPermission.whileInUse);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestLocationPermission() async {
    try {
      await geolocator.Geolocator.requestPermission();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> openInMaps(OpenInMapsRequest request) async {
    try {
      String url;
      if (request.app == MapApp.googleMaps) {
        if (request.location != null) {
          url = 'https://www.google.com/maps/search/?api=1&query=${request.location!.latitude},${request.location!.longitude}';
        } else {
          url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(request.addressOrCoordinates)}';
        }
      } else {
        // Default to Google Maps
        url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(request.addressOrCoordinates)}';
      }

      if (await canLaunch(url)) {
        await launch(url);
        return const Right(null);
      } else {
        return Left(ServerFailure('Could not open map application'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      return await reverseGeocode(latitude, longitude);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LatLng>> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isEmpty) {
        return const Left(ServerFailure('No coordinates found for address'));
      }

      return Right(LatLng(locations.first.latitude, locations.first.longitude));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
