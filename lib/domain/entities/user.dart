import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String? bio;
  final DateTime? birthDate;
  final String? gender;
  final UserLocation? location;
  final KYCStatus kycStatus;
  final UserStats stats;
  final UserSettings settings;
  final UserSubscription subscription;
  final UserWallet? wallet;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final UserStatus status;
  final String? fcmToken;

  const UserEntity({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    this.bio,
    this.birthDate,
    this.gender,
    this.location,
    required this.kycStatus,
    required this.stats,
    required this.settings,
    required this.subscription,
    this.wallet,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    required this.status,
    this.fcmToken,
  });

  String get fullName => '$firstName $lastName';

  bool get isKYCVerified => kycStatus == KYCStatus.verified;

  bool get isPremiumUser => subscription.type != SubscriptionType.free;

  bool get isActive => status == UserStatus.active;

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        firstName,
        lastName,
        avatarUrl,
        bio,
        birthDate,
        gender,
        location,
        kycStatus,
        stats,
        settings,
        subscription,
        wallet,
        createdAt,
        updatedAt,
        lastLoginAt,
        status,
        fcmToken,
      ];
}

class UserLocation extends Equatable {
  final String city;
  final String district;
  final String? neighborhood;
  final double? latitude;
  final double? longitude;

  const UserLocation({
    required this.city,
    required this.district,
    this.neighborhood,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [city, district, neighborhood, latitude, longitude];
}

class UserStats extends Equatable {
  final int totalListings;
  final int completedBarters;
  final double rating;
  final int reviewCount;
  final int favoriteCount;
  final int viewCount;

  const UserStats({
    this.totalListings = 0,
    this.completedBarters = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.favoriteCount = 0,
    this.viewCount = 0,
  });

  @override
  List<Object?> get props => [
        totalListings,
        completedBarters,
        rating,
        reviewCount,
        favoriteCount,
        viewCount,
      ];
}

class UserSettings extends Equatable {
  final String language;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool showPhone;
  final bool showEmail;
  final bool isPublicProfile;

  const UserSettings({
    this.language = 'tr',
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.showPhone = false,
    this.showEmail = false,
    this.isPublicProfile = true,
  });

  @override
  List<Object?> get props => [
        language,
        pushNotifications,
        emailNotifications,
        smsNotifications,
        showPhone,
        showEmail,
        isPublicProfile,
      ];
}

class UserSubscription extends Equatable {
  final SubscriptionType type;
  final DateTime? expiresAt;
  final List<String> features;

  const UserSubscription({
    this.type = SubscriptionType.free,
    this.expiresAt,
    this.features = const [],
  });

  bool get isExpired => expiresAt?.isBefore(DateTime.now()) == true;

  @override
  List<Object?> get props => [type, expiresAt, features];
}

class UserWallet extends Equatable {
  final double balance;
  final String currency;
  final List<WalletTransaction> transactions;

  const UserWallet({
    this.balance = 0.0,
    this.currency = 'TRY',
    this.transactions = const [],
  });

  @override
  List<Object?> get props => [balance, currency, transactions];
}

class WalletTransaction extends Equatable {
  final String id;
  final String type; // credit, debit, transfer
  final double amount;
  final String description;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, type, amount, description, createdAt];
}

enum KYCStatus {
  notStarted('not_started'),
  inProgress('in_progress'),
  pending('pending'),
  verified('verified'),
  rejected('rejected');

  const KYCStatus(this.value);
  final String value;

  static KYCStatus fromString(String value) {
    return KYCStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => KYCStatus.notStarted,
    );
  }
}

enum UserStatus {
  active('active'),
  suspended('suspended'),
  blocked('blocked'),
  deleted('deleted');

  const UserStatus(this.value);
  final String value;

  static UserStatus fromString(String value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserStatus.active,
    );
  }
}

enum SubscriptionType {
  free('free'),
  premium('premium'),
  pro('pro');

  const SubscriptionType(this.value);
  final String value;

  static SubscriptionType fromString(String value) {
    return SubscriptionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => SubscriptionType.free,
    );
  }
}
