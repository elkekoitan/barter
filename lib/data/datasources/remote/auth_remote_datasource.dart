import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';

// 🔥 AUTHENTICATION BACKEND - HTTP API Calls to Firebase Services 🔥
abstract class AuthRemoteDataSource {
  // 📡 LOGIN REQUEST → Firebase Auth Server
  // URL: https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword
  Future<AuthResponse> login(LoginRequest request);

  // 📡 REGISTER REQUEST → Firebase Auth Server
  // URL: https://identitytoolkit.googleapis.com/v1/accounts:signUp
  Future<AuthResponse> register(RegisterRequest request);

  // 💾 LOGOUT → Local storage only (no server call)
  Future<void> logout();

  // 🔄 TOKEN REFRESH → Firebase Auth Server
  // URL: https://securetoken.googleapis.com/v1/token
  Future<AuthResponse> refreshToken(String refreshToken);

  // 📱 OTP/SMS → Firebase Auth Server
  // URL: https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode
  Future<void> sendOTP(String identifier, OTPType type);
  Future<void> verifyOTP(OTPVerificationRequest request);

  // 📧 PASSWORD RESET → Firebase Auth Server + Email Service
  // URL: https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(ResetPasswordRequest request);

  // 👤 USER PROFILE → Firestore Database
  // URL: https://firestore.googleapis.com/v1/projects/.../documents/users/{userId}
  Future<UserResponse> getCurrentUser();
  Future<UserResponse> updateUserProfile(UpdateProfileRequest request);
  Future<UserResponse> uploadAvatar(String filePath);
  Future<void> deleteAccount();

  // 🆔 KYC VERIFICATION → Firestore Database
  // URL: https://firestore.googleapis.com/v1/projects/.../documents/users/{userId}/kyc
  Future<KYCResponse> getKYCStatus();
  Future<KYCResponse> submitKYC(KYCSubmissionRequest request);
  Future<KYCResponse> updateKYCStatus(String status);

  // 🔍 AUTH STATE → Local check
  Future<bool> isLoggedIn();

  // 📱 PUSH TOKEN → Firestore Database
  // URL: https://firestore.googleapis.com/v1/projects/.../documents/users/{userId}
  Future<void> updateFCMToken(String token);

  // 🔵 GOOGLE LOGIN → Firebase Auth + Google OAuth
  // URL: https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp
  Future<AuthResponse> loginWithGoogle();
  Future<AuthResponse> loginWithApple();
  Future<AuthResponse> loginWithFacebook();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'identifier': request.identifier,
          'password': request.password,
          'fcmToken': request.fcmToken,
          'deviceInfo': request.deviceInfo,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return AuthResponse.fromJson(data);
      } else {
        throw ServerFailure('Login failed');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'email': request.email,
          'phone': request.phone,
          'password': request.password,
          'firstName': request.firstName,
          'lastName': request.lastName,
          'referralCode': request.referralCode,
          'fcmToken': request.fcmToken,
          'deviceInfo': request.deviceInfo,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data!['data'];
        return AuthResponse.fromJson(data);
      } else {
        throw ServerFailure('Registration failed');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post<void>('/auth/logout');
    } catch (e) {
      // Even if logout fails on server, we can still clear local data
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return AuthResponse.fromJson(data);
      } else {
        throw AuthFailure('Token refresh failed');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> sendOTP(String identifier, OTPType type) async {
    try {
      await _apiClient.post<void>(
        '/auth/send-otp',
        data: {
          'identifier': identifier,
          'type': type.value,
        },
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> verifyOTP(OTPVerificationRequest request) async {
    try {
      await _apiClient.post<void>(
        '/auth/verify-otp',
        data: {
          'identifier': request.identifier,
          'otp': request.otp,
          'type': request.type.value,
        },
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.post<void>(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await _apiClient.post<void>(
        '/auth/reset-password',
        data: {
          'token': request.token,
          'newPassword': request.newPassword,
          'confirmPassword': request.confirmPassword,
        },
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserResponse> getCurrentUser() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/users/profile');

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return UserResponse.fromJson(data);
      } else {
        throw ServerFailure('Failed to get user profile');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserResponse> updateUserProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/users/profile',
        data: {
          if (request.firstName != null) 'firstName': request.firstName,
          if (request.lastName != null) 'lastName': request.lastName,
          if (request.bio != null) 'bio': request.bio,
          if (request.birthDate != null) 'birthDate': request.birthDate!.toIso8601String(),
          if (request.gender != null) 'gender': request.gender,
          if (request.location != null) 'location': {
            'city': request.location!.city,
            'district': request.location!.district,
            'neighborhood': request.location!.neighborhood,
            'latitude': request.location!.latitude,
            'longitude': request.location!.longitude,
          },
        },
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return UserResponse.fromJson(data);
      } else {
        throw ServerFailure('Failed to update profile');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserResponse> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.post<Map<String, dynamic>>(
        '/users/avatar',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return UserResponse.fromJson(data);
      } else {
        throw ServerFailure('Failed to upload avatar');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _apiClient.delete<void>('/users/account');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<KYCResponse> getKYCStatus() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/kyc/status');

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return KYCResponse.fromJson(data);
      } else {
        throw ServerFailure('Failed to get KYC status');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<KYCResponse> submitKYC(KYCSubmissionRequest request) async {
    try {
      final formData = FormData.fromMap({
        'identityNumber': request.identityNumber,
        'firstName': request.firstName,
        'lastName': request.lastName,
        'birthDate': request.birthDate,
        if (request.faceImagePath != null)
          'faceImage': await MultipartFile.fromFile(request.faceImagePath!),
        if (request.idCardImagePath != null)
          'idCardImage': await MultipartFile.fromFile(request.idCardImagePath!),
        if (request.addressDocumentPath != null)
          'addressDocument': await MultipartFile.fromFile(request.addressDocumentPath!),
      });

      final response = await _apiClient.post<Map<String, dynamic>>(
        '/kyc/submit',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return KYCResponse.fromJson(data);
      } else {
        throw ServerFailure('Failed to submit KYC');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<KYCResponse> updateKYCStatus(String status) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/kyc/status',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return KYCResponse.fromJson(data);
      } else {
        throw ServerFailure('Failed to update KYC status');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final response = await _apiClient.get<bool>('/auth/status');
      return response.data == true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateFCMToken(String token) async {
    try {
      await _apiClient.post<void>(
        '/users/fcm-token',
        data: {'fcmToken': token},
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponse> loginWithGoogle() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>('/auth/google');

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return AuthResponse.fromJson(data);
      } else {
        throw AuthFailure('Google login failed');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponse> loginWithApple() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>('/auth/apple');

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return AuthResponse.fromJson(data);
      } else {
        throw AuthFailure('Apple login failed');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponse> loginWithFacebook() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>('/auth/facebook');

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        return AuthResponse.fromJson(data);
      } else {
        throw AuthFailure('Facebook login failed');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Helper method to handle errors
  Failure _handleError(dynamic error) {
    if (error is Failure) {
      return error;
    }
    return ServerFailure(error.toString());
  }
}

// Request/Response Models
class LoginRequest {
  final String identifier;
  final String password;
  final bool rememberMe;
  final String? fcmToken;
  final String? deviceInfo;

  const LoginRequest({
    required this.identifier,
    required this.password,
    this.rememberMe = false,
    this.fcmToken,
    this.deviceInfo,
  });
}

class RegisterRequest {
  final String email;
  final String phone;
  final String password;
  final String firstName;
  final String lastName;
  final String? referralCode;
  final String? fcmToken;
  final String? deviceInfo;

  const RegisterRequest({
    required this.email,
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.referralCode,
    this.fcmToken,
    this.deviceInfo,
  });
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserData user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      tokenType: json['tokenType'],
      expiresIn: json['expiresIn'],
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String? bio;
  final DateTime? birthDate;
  final String? gender;
  final UserLocationData? location;
  final String kycStatus;
  final UserStatsData stats;
  final UserSettingsData settings;
  final UserSubscriptionData subscription;
  final UserWalletData? wallet;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final String status;
  final String? fcmToken;

  UserData({
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

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      gender: json['gender'],
      location: json['location'] != null ? UserLocationData.fromJson(json['location']) : null,
      kycStatus: json['kycStatus'],
      stats: UserStatsData.fromJson(json['stats']),
      settings: UserSettingsData.fromJson(json['settings']),
      subscription: UserSubscriptionData.fromJson(json['subscription']),
      wallet: json['wallet'] != null ? UserWalletData.fromJson(json['wallet']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      status: json['status'],
      fcmToken: json['fcmToken'],
    );
  }
}

class UserLocationData {
  final String city;
  final String district;
  final String? neighborhood;
  final double? latitude;
  final double? longitude;

  UserLocationData({
    required this.city,
    required this.district,
    this.neighborhood,
    this.latitude,
    this.longitude,
  });

  factory UserLocationData.fromJson(Map<String, dynamic> json) {
    return UserLocationData(
      city: json['city'],
      district: json['district'],
      neighborhood: json['neighborhood'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}

class UserStatsData {
  final int totalListings;
  final int completedBarters;
  final double rating;
  final int reviewCount;
  final int favoriteCount;
  final int viewCount;

  UserStatsData({
    required this.totalListings,
    required this.completedBarters,
    required this.rating,
    required this.reviewCount,
    required this.favoriteCount,
    required this.viewCount,
  });

  factory UserStatsData.fromJson(Map<String, dynamic> json) {
    return UserStatsData(
      totalListings: json['totalListings'],
      completedBarters: json['completedBarters'],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'],
      favoriteCount: json['favoriteCount'],
      viewCount: json['viewCount'],
    );
  }
}

class UserSettingsData {
  final String language;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool showPhone;
  final bool showEmail;
  final bool isPublicProfile;

  UserSettingsData({
    required this.language,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.showPhone,
    required this.showEmail,
    required this.isPublicProfile,
  });

  factory UserSettingsData.fromJson(Map<String, dynamic> json) {
    return UserSettingsData(
      language: json['language'],
      pushNotifications: json['pushNotifications'],
      emailNotifications: json['emailNotifications'],
      smsNotifications: json['smsNotifications'],
      showPhone: json['showPhone'],
      showEmail: json['showEmail'],
      isPublicProfile: json['isPublicProfile'],
    );
  }
}

class UserSubscriptionData {
  final String type;
  final DateTime? expiresAt;
  final List<String> features;

  UserSubscriptionData({
    required this.type,
    this.expiresAt,
    required this.features,
  });

  factory UserSubscriptionData.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionData(
      type: json['type'],
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      features: List<String>.from(json['features']),
    );
  }
}

class UserWalletData {
  final double balance;
  final String currency;

  UserWalletData({
    required this.balance,
    required this.currency,
  });

  factory UserWalletData.fromJson(Map<String, dynamic> json) {
    return UserWalletData(
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'],
    );
  }
}

class OTPVerificationRequest {
  final String identifier;
  final String otp;
  final OTPType type;

  const OTPVerificationRequest({
    required this.identifier,
    required this.otp,
    required this.type,
  });
}

class ResetPasswordRequest {
  final String token;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordRequest({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? bio;
  final DateTime? birthDate;
  final String? gender;
  final UserLocation? location;

  const UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.bio,
    this.birthDate,
    this.gender,
    this.location,
  });
}

class KYCSubmissionRequest {
  final String identityNumber;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String? faceImagePath;
  final String? idCardImagePath;
  final String? addressDocumentPath;

  const KYCSubmissionRequest({
    required this.identityNumber,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.faceImagePath,
    this.idCardImagePath,
    this.addressDocumentPath,
  });
}

class UserResponse {
  final UserData user;

  UserResponse({required this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user: UserData.fromJson(json),
    );
  }
}

class KYCResponse {
  final String status;
  final String? message;
  final Map<String, dynamic>? data;

  KYCResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory KYCResponse.fromJson(Map<String, dynamic> json) {
    return KYCResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}

enum OTPType {
  registration('registration'),
  login('login'),
  passwordReset('password_reset');

  const OTPType(this.value);
  final String value;
}
