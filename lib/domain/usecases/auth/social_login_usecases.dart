import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _repository;

  const SignInWithGoogleUseCase(this._repository);

  Future<Either<Failure, UserCredential>> call() async {
    try {
      return await _repository.signInWithGoogle();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class SignInWithFacebookUseCase {
  final AuthRepository _repository;

  const SignInWithFacebookUseCase(this._repository);

  Future<Either<Failure, UserCredential>> call() async {
    try {
      return await _repository.signInWithFacebook();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class SignInWithAppleUseCase {
  final AuthRepository _repository;

  const SignInWithAppleUseCase(this._repository);

  Future<Either<Failure, UserCredential>> call() async {
    try {
      return await _repository.signInWithApple();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class LinkGoogleAccountUseCase {
  final AuthRepository _repository;

  const LinkGoogleAccountUseCase(this._repository);

  Future<Either<Failure, UserCredential>> call() async {
    try {
      return await _repository.linkGoogleAccount();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class LinkFacebookAccountUseCase {
  final AuthRepository _repository;

  const LinkFacebookAccountUseCase(this._repository);

  Future<Either<Failure, UserCredential>> call() async {
    try {
      return await _repository.linkFacebookAccount();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class LinkAppleAccountUseCase {
  final AuthRepository _repository;

  const LinkAppleAccountUseCase(this._repository);

  Future<Either<Failure, UserCredential>> call() async {
    try {
      return await _repository.linkAppleAccount();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class UnlinkSocialAccountUseCase {
  final AuthRepository _repository;

  const UnlinkSocialAccountUseCase(this._repository);

  Future<Either<Failure, void>> call(String providerId) async {
    if (providerId.isEmpty) {
      return const Left(ValidationFailure('Provider ID cannot be empty'));
    }

    try {
      return await _repository.unlinkSocialAccount(providerId);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class GetSocialLoginProvidersUseCase {
  final AuthRepository _repository;

  const GetSocialLoginProvidersUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() async {
    try {
      return await _repository.getLinkedSocialProviders();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class CheckSocialLoginAvailabilityUseCase {
  final AuthRepository _repository;

  const CheckSocialLoginAvailabilityUseCase(this._repository);

  Future<Either<Failure, Map<String, bool>>> call() async {
    try {
      return await _repository.checkSocialLoginAvailability();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class HandleSocialLoginCallbackUseCase {
  final AuthRepository _repository;

  const HandleSocialLoginCallbackUseCase(this._repository);

  Future<Either<Failure, UserCredential>> call(String providerId, Map<String, dynamic> credentials) async {
    if (providerId.isEmpty) {
      return const Left(ValidationFailure('Provider ID cannot be empty'));
    }

    if (credentials.isEmpty) {
      return const Left(ValidationFailure('Credentials cannot be empty'));
    }

    try {
      return await _repository.handleSocialLoginCallback(providerId, credentials);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class GetSocialLoginCredentialsUseCase {
  final AuthRepository _repository;

  const GetSocialLoginCredentialsUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String providerId) async {
    if (providerId.isEmpty) {
      return const Left(ValidationFailure('Provider ID cannot be empty'));
    }

    try {
      return await _repository.getSocialLoginCredentials(providerId);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class UpdateSocialLoginScopesUseCase {
  final AuthRepository _repository;

  const UpdateSocialLoginScopesUseCase(this._repository);

  Future<Either<Failure, void>> call(String providerId, List<String> scopes) async {
    if (providerId.isEmpty) {
      return const Left(ValidationFailure('Provider ID cannot be empty'));
    }

    if (scopes.isEmpty) {
      return const Left(ValidationFailure('Scopes cannot be empty'));
    }

    try {
      return await _repository.updateSocialLoginScopes(providerId, scopes);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class RevokeSocialLoginAccessUseCase {
  final AuthRepository _repository;

  const RevokeSocialLoginAccessUseCase(this._repository);

  Future<Either<Failure, void>> call(String providerId) async {
    if (providerId.isEmpty) {
      return const Left(ValidationFailure('Provider ID cannot be empty'));
    }

    try {
      return await _repository.revokeSocialLoginAccess(providerId);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class GetSocialLoginSettingsUseCase {
  final AuthRepository _repository;

  const GetSocialLoginSettingsUseCase(this._repository);

  Future<Either<Failure, SocialLoginSettings>> call() async {
    try {
      return await _repository.getSocialLoginSettings();
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class UpdateSocialLoginSettingsUseCase {
  final AuthRepository _repository;

  const UpdateSocialLoginSettingsUseCase(this._repository);

  Future<Either<Failure, SocialLoginSettings>> call(SocialLoginSettings settings) async {
    try {
      return await _repository.updateSocialLoginSettings(settings);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
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
