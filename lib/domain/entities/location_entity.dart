import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? district;
  final String? neighborhood;
  final String? country;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final LocationType type;

  const LocationEntity({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.district,
    this.neighborhood,
    this.country,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.type = LocationType.current,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        latitude,
        longitude,
        address,
        city,
        district,
        neighborhood,
        country,
        createdAt,
        updatedAt,
        isActive,
        type,
      ];

  LocationEntity copyWith({
    String? id,
    String? userId,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? district,
    String? neighborhood,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    LocationType? type,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      district: district ?? this.district,
      neighborhood: neighborhood ?? this.neighborhood,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'district': district,
      'neighborhood': neighborhood,
      'country': country,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'type': type.value,
    };
  }

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      id: json['id'],
      userId: json['userId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      city: json['city'],
      district: json['district'],
      neighborhood: json['neighborhood'],
      country: json['country'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'] ?? true,
      type: json['type'] != null ? LocationType.fromString(json['type']) : LocationType.current,
    );
  }

  double distanceTo(LocationEntity other) {
    const double earthRadius = 6371; // km
    final double dLat = _degreesToRadians(other.latitude - latitude);
    final double dLon = _degreesToRadians(other.longitude - longitude);

    final double lat1Rad = _degreesToRadians(latitude);
    final double lat2Rad = _degreesToRadians(other.latitude);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  LocationEntity copyWith({
    String? id,
    String? userId,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? district,
    String? neighborhood,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    LocationType? type,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      district: district ?? this.district,
      neighborhood: neighborhood ?? this.neighborhood,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
    );
  }
}

enum LocationType {
  current('current', 'Current Location'),
  home('home', 'Home Address'),
  work('work', 'Work Address'),
  other('other', 'Other Address');

  const LocationType(this.value, this.displayName);
  final String value;
  final String displayName;

  static LocationType fromString(String value) {
    return LocationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => LocationType.current,
    );
  }
}
