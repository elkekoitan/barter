import 'package:equatable/equatable.dart';
import 'location_entity.dart';

class UserLocationEntity extends Equatable {
  final String userId;
  final LocationEntity homeLocation;
  final LocationEntity? workLocation;
  final List<LocationEntity> savedLocations;
  final bool locationSharingEnabled;
  final LocationEntity? lastKnownLocation;
  final DateTime lastLocationUpdate;
  final Map<String, dynamic>? preferences;

  const UserLocationEntity({
    required this.userId,
    required this.homeLocation,
    this.workLocation,
    this.savedLocations = const [],
    this.locationSharingEnabled = false,
    this.lastKnownLocation,
    required this.lastLocationUpdate,
    this.preferences,
  });

  // Convenience getter for current/last known location
  LocationEntity get location => lastKnownLocation ?? homeLocation;

  @override
  List<Object?> get props => [
        userId,
        homeLocation,
        workLocation,
        savedLocations,
        locationSharingEnabled,
        lastKnownLocation,
        lastLocationUpdate,
        preferences,
      ];

  UserLocationEntity copyWith({
    String? userId,
    LocationEntity? homeLocation,
    LocationEntity? workLocation,
    List<LocationEntity>? savedLocations,
    bool? locationSharingEnabled,
    LocationEntity? lastKnownLocation,
    DateTime? lastLocationUpdate,
    Map<String, dynamic>? preferences,
  }) {
    return UserLocationEntity(
      userId: userId ?? this.userId,
      homeLocation: homeLocation ?? this.homeLocation,
      workLocation: workLocation ?? this.workLocation,
      savedLocations: savedLocations ?? this.savedLocations,
      locationSharingEnabled: locationSharingEnabled ?? this.locationSharingEnabled,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'homeLocation': homeLocation.toJson(),
      'workLocation': workLocation?.toJson(),
      'savedLocations': savedLocations.map((location) => location.toJson()).toList(),
      'locationSharingEnabled': locationSharingEnabled,
      'lastKnownLocation': lastKnownLocation?.toJson(),
      'lastLocationUpdate': lastLocationUpdate.toIso8601String(),
      'preferences': preferences,
    };
  }

  factory UserLocationEntity.fromJson(Map<String, dynamic> json) {
    return UserLocationEntity(
      userId: json['userId'],
      homeLocation: LocationEntity.fromJson(json['homeLocation']),
      workLocation: json['workLocation'] != null
          ? LocationEntity.fromJson(json['workLocation'])
          : null,
      savedLocations: (json['savedLocations'] as List?)
              ?.map((location) => LocationEntity.fromJson(location))
              .toList() ??
          [],
      locationSharingEnabled: json['locationSharingEnabled'] ?? false,
      lastKnownLocation: json['lastKnownLocation'] != null
          ? LocationEntity.fromJson(json['lastKnownLocation'])
          : null,
      lastLocationUpdate: DateTime.parse(json['lastLocationUpdate']),
      preferences: json['preferences'],
    );
  }
}
