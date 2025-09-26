import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // Authentication
  Future<Either<Failure, AuthTokens>> login(LoginRequest request);
  Future<Either<Failure, AuthTokens>> register(RegisterRequest request);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthTokens>> refreshToken(String refreshToken);

  // OTP Verification
  Future<Either<Failure, void>> sendOTP(String identifier, OTPType type);
  Future<Either<Failure, void>> verifyOTP(OTPVerificationRequest request);

  // Password Management
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request);

  // User Management
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, UserEntity>> updateUserProfile(UpdateProfileRequest request);
  Future<Either<Failure, UserEntity>> uploadAvatar(String filePath);
  Future<Either<Failure, void>> deleteAccount();

  // KYC
  Future<Either<Failure, KYCStatus>> getKYCStatus();
  Future<Either<Failure, KYCStatus>> submitKYC(KYCSubmissionRequest request);
  Future<Either<Failure, KYCStatus>> updateKYCStatus(String status);

  // Session Management
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, void>> updateFCMToken(String token);

  // Social Login
  Future<Either<Failure, AuthTokens>> loginWithGoogle();
  Future<Either<Failure, AuthTokens>> loginWithApple();
  Future<Either<Failure, AuthTokens>> loginWithFacebook();

  // Advanced Social Login Operations
  Future<Either<Failure, UserCredential>> signInWithGoogle();
  Future<Either<Failure, UserCredential>> signInWithFacebook();
  Future<Either<Failure, UserCredential>> signInWithApple();
  Future<Either<Failure, UserCredential>> linkGoogleAccount();
  Future<Either<Failure, UserCredential>> linkFacebookAccount();
  Future<Either<Failure, UserCredential>> linkAppleAccount();
  Future<Either<Failure, void>> unlinkSocialAccount(String providerId);
  Future<Either<Failure, List<String>>> getLinkedSocialProviders();
  Future<Either<Failure, Map<String, bool>>> checkSocialLoginAvailability();
  Future<Either<Failure, UserCredential>> handleSocialLoginCallback(String providerId, Map<String, dynamic> credentials);
  Future<Either<Failure, Map<String, dynamic>>> getSocialLoginCredentials(String providerId);
  Future<Either<Failure, void>> updateSocialLoginScopes(String providerId, List<String> scopes);
  Future<Either<Failure, void>> revokeSocialLoginAccess(String providerId);
  Future<Either<Failure, SocialLoginSettings>> getSocialLoginSettings();
  Future<Either<Failure, SocialLoginSettings>> updateSocialLoginSettings(SocialLoginSettings settings);
}

// Request/Response Models
class LoginRequest {
  final String identifier; // email or phone
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
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String? referralCode;
  final String? fcmToken;
  final String? deviceInfo;

  const RegisterRequest({
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    this.referralCode,
    this.fcmToken,
    this.deviceInfo,
  });
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserEntity user;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });
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
  final String identityNumber; // TCKN
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

enum OTPType {
  registration('registration'),
  login('login'),
  passwordReset('password_reset');

  const OTPType(this.value);
  final String value;
}


class SocialLoginSettings {
  final bool enableGoogleLogin;
  final bool enableFacebookLogin;
  final bool enableAppleLogin;
  final bool requireEmailVerification;
  final bool allowAccountLinking;
  final List<String> allowedDomains;
  final Map<String, dynamic> customSettings;

  const SocialLoginSettings({
    this.enableGoogleLogin = true,
    this.enableFacebookLogin = true,
    this.enableAppleLogin = false, // iOS only by default
    this.requireEmailVerification = true,
    this.allowAccountLinking = true,
    this.allowedDomains = const [],
    this.customSettings = const {},
  });

  SocialLoginSettings copyWith({
    bool? enableGoogleLogin,
    bool? enableFacebookLogin,
    bool? enableAppleLogin,
    bool? requireEmailVerification,
    bool? allowAccountLinking,
    List<String>? allowedDomains,
    Map<String, dynamic>? customSettings,
  }) {
    return SocialLoginSettings(
      enableGoogleLogin: enableGoogleLogin ?? this.enableGoogleLogin,
      enableFacebookLogin: enableFacebookLogin ?? this.enableFacebookLogin,
      enableAppleLogin: enableAppleLogin ?? this.enableAppleLogin,
      requireEmailVerification: requireEmailVerification ?? this.requireEmailVerification,
      allowAccountLinking: allowAccountLinking ?? this.allowAccountLinking,
      allowedDomains: allowedDomains ?? this.allowedDomains,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableGoogleLogin': enableGoogleLogin,
      'enableFacebookLogin': enableFacebookLogin,
      'enableAppleLogin': enableAppleLogin,
      'requireEmailVerification': requireEmailVerification,
      'allowAccountLinking': allowAccountLinking,
      'allowedDomains': allowedDomains,
      'customSettings': customSettings,
    };
  }

  factory SocialLoginSettings.fromJson(Map<String, dynamic> json) {
    return SocialLoginSettings(
      enableGoogleLogin: json['enableGoogleLogin'] ?? true,
      enableFacebookLogin: json['enableFacebookLogin'] ?? true,
      enableAppleLogin: json['enableAppleLogin'] ?? false,
      requireEmailVerification: json['requireEmailVerification'] ?? true,
      allowAccountLinking: json['allowAccountLinking'] ?? true,
      allowedDomains: List<String>.from(json['allowedDomains'] ?? []),
      customSettings: Map<String, dynamic>.from(json['customSettings'] ?? {}),
    );
  }

  bool isProviderEnabled(String providerId) {
    switch (providerId) {
      case 'google.com':
        return enableGoogleLogin;
      case 'facebook.com':
        return enableFacebookLogin;
      case 'apple.com':
        return enableAppleLogin;
      default:
        return false;
    }
  }

  List<String> getEnabledProviders() {
    final providers = <String>[];
    if (enableGoogleLogin) providers.add('google.com');
    if (enableFacebookLogin) providers.add('facebook.com');
    if (enableAppleLogin) providers.add('apple.com');
    return providers;
  }

  bool isDomainAllowed(String email) {
    if (allowedDomains.isEmpty) return true;
    final domain = email.split('@').last.toLowerCase();
    return allowedDomains.contains(domain);
  }
}
