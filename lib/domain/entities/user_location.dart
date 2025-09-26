import 'package:equatable/equatable.dart';

class UserLocation extends Equatable {
  final String userId;
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;
  final DateTime lastUpdated;
  final bool isActive;
  final LocationType locationType;

  const UserLocation({
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
    required this.lastUpdated,
    this.isActive = true,
    this.locationType = LocationType.current,
  });

  @override
  List<Object?> get props => [
        userId,
        latitude,
        longitude,
        address,
        city,
        country,
        lastUpdated,
        isActive,
        locationType,
      ];

  UserLocation copyWith({
    String? userId,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? country,
    DateTime? lastUpdated,
    bool? isActive,
    LocationType? locationType,
  }) {
    return UserLocation(
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isActive: isActive ?? this.isActive,
      locationType: locationType ?? this.locationType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isActive': isActive,
      'locationType': locationType.value,
    };
  }

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      userId: json['userId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      isActive: json['isActive'] ?? true,
      locationType: LocationType.fromValue(json['locationType'] ?? 'current'),
    );
  }

  double distanceTo(UserLocation other) {
    const double earthRadius = 6371; // km
    final double dLat = _degreesToRadians(other.latitude - latitude);
    final double dLon = _degreesToRadians(other.longitude - longitude);

    final double a = (dLat / 2).sin() * (dLat / 2).sin() +
        latitude.cos() * other.latitude.cos() *
        (dLon / 2).sin() * (dLon / 2).sin();

    final double c = 2 * a.sqrt().atan2((1 - a).sqrt());
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }
}

enum LocationType {
  current('current', 'Mevcut Konum'),
  home('home', 'Ev'),
  work('work', 'İş'),
  saved('saved', 'Kaydedilmiş');

  const LocationType(this.value, this.displayName);
  final String value;
  final String displayName;

  static LocationType fromValue(String value) {
    return LocationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LocationType.current,
    );
  }
}
