import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserEntity user);
  Future<UserEntity?> getCachedUser();
  Future<void> clearUserData();

  Future<void> storeTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();

  Future<void> storeUserSession(String userId, DateTime loginTime);
  Future<bool> isUserLoggedIn();
  Future<DateTime?> getLastLoginTime();

  Future<void> storeUserPreferences(UserSettings settings);
  Future<UserSettings?> getUserPreferences();

  Future<void> storeFCMToken(String token);
  Future<String?> getFCMToken();

  Future<void> clearAllData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  static const String _userKey = 'cached_user';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _lastLoginKey = 'last_login';
  static const String _preferencesKey = 'user_preferences';
  static const String _fcmTokenKey = 'fcm_token';

  AuthLocalDataSourceImpl(this._secureStorage, this._prefs);

  @override
  Future<void> cacheUser(UserEntity user) async {
    final userJson = jsonEncode(_userToJson(user));
    await _prefs.setString(_userKey, userJson);
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null || userJson.isEmpty) {
      return null;
    }

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return _userFromJson(userMap);
    } catch (e) {
      // If cached data is corrupted, clear it
      await _prefs.remove(_userKey);
      return null;
    }
  }

  @override
  Future<void> clearUserData() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_lastLoginKey);
    await _prefs.remove(_preferencesKey);
  }

  @override
  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  @override
  Future<void> storeUserSession(String userId, DateTime loginTime) async {
    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_lastLoginKey, loginTime.toIso8601String());
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final accessToken = await getAccessToken();
    final userId = _prefs.getString(_userIdKey);

    return accessToken != null && accessToken.isNotEmpty && userId != null && userId.isNotEmpty;
  }

  @override
  Future<DateTime?> getLastLoginTime() async {
    final lastLoginStr = _prefs.getString(_lastLoginKey);
    if (lastLoginStr == null || lastLoginStr.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(lastLoginStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> storeUserPreferences(UserSettings settings) async {
    final preferencesJson = jsonEncode(_userSettingsToJson(settings));
    await _prefs.setString(_preferencesKey, preferencesJson);
  }

  @override
  Future<UserSettings?> getUserPreferences() async {
    final preferencesJson = _prefs.getString(_preferencesKey);
    if (preferencesJson == null || preferencesJson.isEmpty) {
      return null;
    }

    try {
      final preferencesMap = jsonDecode(preferencesJson) as Map<String, dynamic>;
      return _userSettingsFromJson(preferencesMap);
    } catch (e) {
      // If cached data is corrupted, clear it
      await _prefs.remove(_preferencesKey);
      return null;
    }
  }

  @override
  Future<void> storeFCMToken(String token) async {
    await _secureStorage.write(key: _fcmTokenKey, value: token);
  }

  @override
  Future<String?> getFCMToken() async {
    return await _secureStorage.read(key: _fcmTokenKey);
  }

  @override
  Future<void> clearAllData() async {
    await clearUserData();
    await clearTokens();
    await _secureStorage.delete(key: _fcmTokenKey);
  }

  // Helper methods for JSON conversion
  Map<String, dynamic> _userToJson(UserEntity user) {
    return {
      'id': user.id,
      'email': user.email,
      'phone': user.phone,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'avatarUrl': user.avatarUrl,
      'bio': user.bio,
      'birthDate': user.birthDate?.toIso8601String(),
      'gender': user.gender,
      'location': user.location != null ? {
        'city': user.location!.city,
        'district': user.location!.district,
        'neighborhood': user.location!.neighborhood,
        'latitude': user.location!.latitude,
        'longitude': user.location!.longitude,
      } : null,
      'kycStatus': user.kycStatus.value,
      'stats': {
        'totalListings': user.stats.totalListings,
        'totalBarters': user.stats.totalBarters,
        'totalReviews': user.stats.totalReviews,
        'averageRating': user.stats.averageRating,
        'favoriteCount': user.stats.favoriteCount,
        'viewCount': user.stats.viewCount,
      },
      'settings': _userSettingsToJson(user.settings),
      'subscription': {
        'type': user.subscription.type.value,
        'expiresAt': user.subscription.expiresAt?.toIso8601String(),
        'features': user.subscription.features,
      },
      'wallet': user.wallet != null ? {
        'balance': user.wallet!.balance,
        'currency': user.wallet!.currency,
      } : null,
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
      'lastLoginAt': user.lastLoginAt?.toIso8601String(),
      'status': user.status.value,
      'fcmToken': user.fcmToken,
    };
  }

  UserEntity _userFromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      gender: json['gender'],
      location: json['location'] != null ? UserLocation(
        city: json['location']['city'],
        district: json['location']['district'],
        neighborhood: json['location']['neighborhood'],
        latitude: json['location']['latitude']?.toDouble(),
        longitude: json['location']['longitude']?.toDouble(),
      ) : null,
      kycStatus: KYCStatus.fromString(json['kycStatus']),
      stats: UserStats(
        totalListings: json['stats']['totalListings'],
        totalBarters: json['stats']['totalBarters'],
        totalReviews: json['stats']['totalReviews'],
        averageRating: (json['stats']['averageRating'] ?? 0).toDouble(),
        favoriteCount: json['stats']['favoriteCount'],
        viewCount: json['stats']['viewCount'],
      ),
      settings: _userSettingsFromJson(json['settings']),
      subscription: UserSubscription(
        type: SubscriptionType.fromString(json['subscription']['type']),
        expiresAt: json['subscription']['expiresAt'] != null
            ? DateTime.parse(json['subscription']['expiresAt'])
            : null,
        features: List<String>.from(json['subscription']['features']),
      ),
      wallet: json['wallet'] != null ? UserWallet(
        balance: (json['wallet']['balance'] ?? 0).toDouble(),
        currency: json['wallet']['currency'] ?? 'TRY',
      ) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      status: UserStatus.fromString(json['status']),
      fcmToken: json['fcmToken'],
    );
  }

  Map<String, dynamic> _userSettingsToJson(UserSettings settings) {
    return {
      'language': settings.language,
      'pushNotifications': settings.pushNotifications,
      'emailNotifications': settings.emailNotifications,
      'smsNotifications': settings.smsNotifications,
      'showPhone': settings.showPhone,
      'showEmail': settings.showEmail,
      'isPublicProfile': settings.isPublicProfile,
    };
  }

  UserSettings _userSettingsFromJson(Map<String, dynamic> json) {
    return UserSettings(
      language: json['language'] ?? 'tr',
      pushNotifications: json['pushNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
      showPhone: json['showPhone'] ?? false,
      showEmail: json['showEmail'] ?? false,
      isPublicProfile: json['isPublicProfile'] ?? true,
    );
  }
}
