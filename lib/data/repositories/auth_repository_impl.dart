import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(
    this._apiClient,
    this._authLocalDataSource,
    this._authRemoteDataSource,
    this._secureStorage,
    this._prefs,
  );

  @override
  Future<Either<Failure, AuthTokens>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'identifier': request.identifier,
          'password': request.password,
          'fcmToken': request.fcmToken,
          'deviceInfo': request.deviceInfo ?? await _getDeviceInfo(),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        final tokens = AuthTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          tokenType: data['tokenType'],
          expiresIn: data['expiresIn'],
          user: _mapUserDataToEntity(data['user']),
        );

        // Store tokens securely
        await _storeTokens(tokens);

        // Update FCM token if provided
        if (request.fcmToken != null) {
          await updateFCMToken(request.fcmToken!);
        }

        return Right(tokens);
      } else {
        return Left(ServerFailure('Login failed'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> register(RegisterRequest request) async {
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
          'deviceInfo': request.deviceInfo ?? await _getDeviceInfo(),
        },
      );

      if (response.statusCode == 201) {
        final data = response.data!['data'];
        final tokens = AuthTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          tokenType: data['tokenType'],
          expiresIn: data['expiresIn'],
          user: _mapUserDataToEntity(data['user']),
        );

        // Store tokens securely
        await _storeTokens(tokens);

        return Right(tokens);
      } else {
        return Left(ServerFailure('Registration failed'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear local tokens
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      await _prefs.remove('user_id');
      await _prefs.remove('last_login');

      // Call logout endpoint
      await _apiClient.post<void>('/auth/logout');

      return const Right(null);
    } catch (e) {
      // Even if logout fails, we should clear local data
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      await _prefs.remove('user_id');
      await _prefs.remove('last_login');

      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        final tokens = AuthTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          tokenType: data['tokenType'],
          expiresIn: data['expiresIn'],
          user: _mapUserDataToEntity(data['user']),
        );

        // Update stored tokens
        await _storeTokens(tokens);

        return Right(tokens);
      } else {
        return Left(AuthFailure('Token refresh failed'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendOTP(String identifier, OTPType type) async {
    try {
      await _apiClient.post<void>(
        '/auth/send-otp',
        data: {
          'identifier': identifier,
          'type': type.value,
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOTP(OTPVerificationRequest request) async {
    try {
      await _apiClient.post<void>(
        '/auth/verify-otp',
        data: {
          'identifier': request.identifier,
          'otp': request.otp,
          'type': request.type.value,
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _apiClient.post<void>(
        '/auth/forgot-password',
        data: {'email': email},
      );

      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request) async {
    try {
      await _apiClient.post<void>(
        '/auth/reset-password',
        data: {
          'token': request.token,
          'newPassword': request.newPassword,
          'confirmPassword': request.confirmPassword,
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/users/profile');

      if (response.statusCode == 200) {
        final userData = response.data!['data'];
        final user = _mapUserDataToEntity(userData);

        // Cache user data locally
        await _authLocalDataSource.cacheUser(user);

        return Right(user);
      } else {
        return Left(ServerFailure('Failed to get user profile'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(UpdateProfileRequest request) async {
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
        final userData = response.data!['data'];
        final user = _mapUserDataToEntity(userData);

        // Update cached user data
        await _authLocalDataSource.cacheUser(user);

        return Right(user);
      } else {
        return Left(ServerFailure('Failed to update profile'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.post<Map<String, dynamic>>(
        '/users/avatar',
        data: formData,
      );

      if (response.statusCode == 200) {
        final userData = response.data!['data'];
        final user = _mapUserDataToEntity(userData);
        return Right(user);
      } else {
        return Left(ServerFailure('Failed to upload avatar'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _apiClient.delete<void>('/users/account');
      await logout(); // Clear local data
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, KYCStatus>> getKYCStatus() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/kyc/status');

      if (response.statusCode == 200) {
        final status = response.data!['data']['status'];
        return Right(KYCStatus.fromString(status));
      } else {
        return Left(ServerFailure('Failed to get KYC status'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, KYCStatus>> submitKYC(KYCSubmissionRequest request) async {
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
        final status = response.data!['data']['status'];
        return Right(KYCStatus.fromString(status));
      } else {
        return Left(ServerFailure('Failed to submit KYC'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, KYCStatus>> updateKYCStatus(String status) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/kyc/status',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        final status = response.data!['data']['status'];
        return Right(KYCStatus.fromString(status));
      } else {
        return Left(ServerFailure('Failed to update KYC status'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final accessToken = await _secureStorage.read(key: 'access_token');
      final userId = _prefs.getString('user_id');

      return Right(accessToken != null && accessToken.isNotEmpty && userId != null);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, void>> updateFCMToken(String token) async {
    try {
      await _apiClient.post<void>(
        '/users/fcm-token',
        data: {'fcmToken': token},
      );

      // Store FCM token locally
      await _prefs.setString('fcm_token', token);

      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> loginWithGoogle() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>('/auth/google');

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        final tokens = AuthTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          tokenType: data['tokenType'],
          expiresIn: data['expiresIn'],
          user: _mapUserDataToEntity(data['user']),
        );

        await _storeTokens(tokens);
        return Right(tokens);
      } else {
        return Left(AuthFailure('Google login failed'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> loginWithApple() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>('/auth/apple');

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        final tokens = AuthTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          tokenType: data['tokenType'],
          expiresIn: data['expiresIn'],
          user: _mapUserDataToEntity(data['user']),
        );

        await _storeTokens(tokens);
        return Right(tokens);
      } else {
        return Left(AuthFailure('Apple login failed'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> loginWithFacebook() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>('/auth/facebook');

      if (response.statusCode == 200) {
        final data = response.data!['data'];
        final tokens = AuthTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          tokenType: data['tokenType'],
          expiresIn: data['expiresIn'],
          user: _mapUserDataToEntity(data['user']),
        );

        await _storeTokens(tokens);
        return Right(tokens);
      } else {
        return Left(AuthFailure('Facebook login failed'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  // Helper methods
  Future<void> _storeTokens(AuthTokens tokens) async {
    await _secureStorage.write(key: 'access_token', value: tokens.accessToken);
    await _secureStorage.write(key: 'refresh_token', value: tokens.refreshToken);
    await _prefs.setString('user_id', tokens.user.id);
    await _prefs.setString('last_login', DateTime.now().toIso8601String());
  }

  Future<String> _getDeviceInfo() async {
    // TODO: Implement device info gathering
    return 'Flutter App - ${defaultTargetPlatform.name}';
  }

  UserEntity _mapUserDataToEntity(Map<String, dynamic> data) {
    return UserEntity(
      id: data['id'],
      email: data['email'],
      phone: data['phone'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      avatarUrl: data['avatarUrl'],
      bio: data['bio'],
      birthDate: data['birthDate'] != null ? DateTime.parse(data['birthDate']) : null,
      gender: data['gender'],
      location: data['location'] != null
          ? UserLocation(
              city: data['location']['city'],
              district: data['location']['district'],
              neighborhood: data['location']['neighborhood'],
              latitude: data['location']['latitude']?.toDouble(),
              longitude: data['location']['longitude']?.toDouble(),
            )
          : null,
      kycStatus: KYCStatus.fromString(data['kycStatus'] ?? 'not_started'),
      stats: UserStats(
        totalListings: data['stats']?['totalListings'] ?? 0,
        completedBarters: data['stats']?['completedBarters'] ?? 0,
        rating: (data['stats']?['rating'] ?? 0).toDouble(),
        reviewCount: data['stats']?['reviewCount'] ?? 0,
        favoriteCount: data['stats']?['favoriteCount'] ?? 0,
        viewCount: data['stats']?['viewCount'] ?? 0,
      ),
      settings: UserSettings(
        language: data['settings']?['language'] ?? 'tr',
        pushNotifications: data['settings']?['pushNotifications'] ?? true,
        emailNotifications: data['settings']?['emailNotifications'] ?? true,
        smsNotifications: data['settings']?['smsNotifications'] ?? false,
        showPhone: data['settings']?['showPhone'] ?? false,
        showEmail: data['settings']?['showEmail'] ?? false,
        isPublicProfile: data['settings']?['isPublicProfile'] ?? true,
      ),
      subscription: UserSubscription(
        type: SubscriptionType.fromString(data['subscription']?['type'] ?? 'free'),
        expiresAt: data['subscription']?['expiresAt'] != null
            ? DateTime.parse(data['subscription']['expiresAt'])
            : null,
        features: List<String>.from(data['subscription']?['features'] ?? []),
      ),
      wallet: data['wallet'] != null
          ? UserWallet(
              balance: (data['wallet']['balance'] ?? 0).toDouble(),
              currency: data['wallet']['currency'] ?? 'TRY',
            )
          : null,
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      lastLoginAt: data['lastLoginAt'] != null ? DateTime.parse(data['lastLoginAt']) : null,
      status: UserStatus.fromString(data['status'] ?? 'active'),
      fcmToken: data['fcmToken'],
    );
  }

  // Social Login Operations Implementation
  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    try {
      // TODO: Implement Google Sign-In
      // For now, return a placeholder error
      return const Left(ServerFailure('Google Sign-In not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithFacebook() async {
    try {
      // TODO: Implement Facebook Sign-In
      return const Left(ServerFailure('Facebook Sign-In not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithApple() async {
    try {
      // TODO: Implement Apple Sign-In
      return const Left(ServerFailure('Apple Sign-In not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> linkGoogleAccount() async {
    try {
      // TODO: Implement Google account linking
      return const Left(ServerFailure('Google account linking not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> linkFacebookAccount() async {
    try {
      // TODO: Implement Facebook account linking
      return const Left(ServerFailure('Facebook account linking not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> linkAppleAccount() async {
    try {
      // TODO: Implement Apple account linking
      return const Left(ServerFailure('Apple account linking not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> unlinkSocialAccount(String providerId) async {
    try {
      // TODO: Implement social account unlinking
      return const Left(ServerFailure('Social account unlinking not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getLinkedSocialProviders() async {
    try {
      // TODO: Implement getting linked social providers
      return const Right([]);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, bool>>> checkSocialLoginAvailability() async {
    try {
      // TODO: Implement social login availability check
      return const Right({
        'google': false,
        'facebook': false,
        'apple': false,
      });
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> handleSocialLoginCallback(String providerId, Map<String, dynamic> credentials) async {
    try {
      // TODO: Implement social login callback handling
      return const Left(ServerFailure('Social login callback handling not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSocialLoginCredentials(String providerId) async {
    try {
      // TODO: Implement getting social login credentials
      return const Right({});
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateSocialLoginScopes(String providerId, List<String> scopes) async {
    try {
      // TODO: Implement updating social login scopes
      return const Left(ServerFailure('Social login scope updating not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> revokeSocialLoginAccess(String providerId) async {
    try {
      // TODO: Implement revoking social login access
      return const Left(ServerFailure('Social login access revocation not yet implemented'));
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, SocialLoginSettings>> getSocialLoginSettings() async {
    try {
      // TODO: Implement getting social login settings
      return const Right(SocialLoginSettings());
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, SocialLoginSettings>> updateSocialLoginSettings(SocialLoginSettings settings) async {
    try {
      // TODO: Implement updating social login settings
      return Right(settings);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }
}
