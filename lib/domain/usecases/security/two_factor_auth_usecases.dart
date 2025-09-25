import 'package:dartz/dartz.dart';
import '../../repositories/security_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/security.dart';

class EnableTwoFactorAuthUseCase {
  final SecurityRepository _repository;

  const EnableTwoFactorAuthUseCase(this._repository);

  Future<Either<Failure, TwoFactorAuth>> call({
    required TwoFactorMethod method,
    String? phoneNumber,
    String? email,
    bool setAsPrimary = true,
  }) async {
    // Validation
    if (method == TwoFactorMethod.sms && (phoneNumber == null || phoneNumber.isEmpty)) {
      return const Left(ValidationFailure('Phone number is required for SMS verification'));
    }

    if (method == TwoFactorMethod.email && (email == null || email.isEmpty)) {
      return const Left(ValidationFailure('Email is required for email verification'));
    }

    // Validate phone number format if SMS
    if (method == TwoFactorMethod.sms) {
      final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
      if (!phoneRegex.hasMatch(phoneNumber!)) {
        return const Left(ValidationFailure('Invalid phone number format'));
      }
    }

    // Validate email format if email
    if (method == TwoFactorMethod.email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email!)) {
        return const Left(ValidationFailure('Invalid email format'));
      }
    }

    try {
      final result = await _repository.enableTwoFactorAuth(
        method: method,
        phoneNumber: phoneNumber,
        email: email,
        setAsPrimary: setAsPrimary,
      );

      return result.fold(
        (failure) => Left(failure),
        (twoFactorAuth) async {
          // Generate backup codes if authenticator
          if (method == TwoFactorMethod.authenticator) {
            final backupCodesResult = await _repository.generateBackupCodes();
            return backupCodesResult.fold(
              (failure) => Left(failure),
              (backupCodes) => Right(twoFactorAuth.copyWith(backupCodes: backupCodes)),
            );
          }

          return Right(twoFactorAuth);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class DisableTwoFactorAuthUseCase {
  final SecurityRepository _repository;

  const DisableTwoFactorAuthUseCase(this._repository);

  Future<Either<Failure, void>> call(String password) async {
    if (password.isEmpty) {
      return const Left(ValidationFailure('Password cannot be empty'));
    }

    if (password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    return await _repository.disableTwoFactorAuth(password);
  }
}

class VerifyTwoFactorCodeUseCase {
  final SecurityRepository _repository;

  const VerifyTwoFactorCodeUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    required String code,
    required TwoFactorMethod method,
    String? verificationId,
    bool trustDevice = false,
  }) async {
    // Validation
    if (code.isEmpty) {
      return const Left(ValidationFailure('Verification code cannot be empty'));
    }

    if (code.length < 6) {
      return const Left(ValidationFailure('Verification code must be at least 6 digits'));
    }

    // Validate code format
    final codeRegex = RegExp(r'^\d{6,8}$');
    if (!codeRegex.hasMatch(code)) {
      return const Left(ValidationFailure('Invalid verification code format'));
    }

    return await _repository.verifyTwoFactorCode(
      code: code,
      method: method,
      verificationId: verificationId,
      trustDevice: trustDevice,
    );
  }
}

class SendTwoFactorCodeUseCase {
  final SecurityRepository _repository;

  const SendTwoFactorCodeUseCase(this._repository);

  Future<Either<Failure, String>> call(TwoFactorMethod method, {
    String? phoneNumber,
    String? email,
  }) async {
    // Validation
    if (method == TwoFactorMethod.sms && (phoneNumber == null || phoneNumber.isEmpty)) {
      return const Left(ValidationFailure('Phone number is required for SMS verification'));
    }

    if (method == TwoFactorMethod.email && (email == null || email.isEmpty)) {
      return const Left(ValidationFailure('Email is required for email verification'));
    }

    return await _repository.sendTwoFactorCode(
      method,
      phoneNumber: phoneNumber,
      email: email,
    );
  }
}

class GenerateBackupCodesUseCase {
  final SecurityRepository _repository;

  const GenerateBackupCodesUseCase(this._repository);

  Future<Either<Failure, String>> call() async {
    return await _repository.generateBackupCodes();
  }
}

class RegenerateBackupCodesUseCase {
  final SecurityRepository _repository;

  const RegenerateBackupCodesUseCase(this._repository);

  Future<Either<Failure, String>> call() async {
    return await _repository.regenerateBackupCodes();
  }
}

class VerifyBackupCodeUseCase {
  final SecurityRepository _repository;

  const VerifyBackupCodeUseCase(this._repository);

  Future<Either<Failure, bool>> call(String backupCode) async {
    if (backupCode.isEmpty) {
      return const Left(ValidationFailure('Backup code cannot be empty'));
    }

    if (backupCode.length != 8) {
      return const Left(ValidationFailure('Backup code must be 8 characters'));
    }

    return await _repository.verifyBackupCode(backupCode);
  }
}

class GetTwoFactorStatusUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorStatusUseCase(this._repository);

  Future<Either<Failure, TwoFactorAuth>> call() async {
    return await _repository.getTwoFactorStatus();
  }
}

class UpdateTwoFactorSettingsUseCase {
  final SecurityRepository _repository;

  const UpdateTwoFactorSettingsUseCase(this._repository);

  Future<Either<Failure, TwoFactorAuth>> call(TwoFactorAuth settings) async {
    return await _repository.updateTwoFactorSettings(settings);
  }
}

class GetTwoFactorRecoveryOptionsUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorRecoveryOptionsUseCase(this._repository);

  Future<Either<Failure, List<TwoFactorMethod>>> call() async {
    return await _repository.getTwoFactorRecoveryOptions();
  }
}

class SetupTwoFactorRecoveryUseCase {
  final SecurityRepository _repository;

  const SetupTwoFactorRecoveryUseCase(this._repository);

  Future<Either<Failure, void>> call({
    List<SecurityQuestion>? securityQuestions,
    String? backupEmail,
    String? backupPhone,
  }) async {
    // At least one recovery method required
    if (securityQuestions == null && backupEmail == null && backupPhone == null) {
      return const Left(ValidationFailure('At least one recovery method required'));
    }

    return await _repository.setupTwoFactorRecovery(
      securityQuestions: securityQuestions,
      backupEmail: backupEmail,
      backupPhone: backupPhone,
    );
  }
}

class VerifyTwoFactorRecoveryUseCase {
  final SecurityRepository _repository;

  const VerifyTwoFactorRecoveryUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    List<String>? securityAnswers,
    String? backupCode,
    String? recoveryToken,
  }) async {
    if (securityAnswers == null && backupCode == null && recoveryToken == null) {
      return const Left(ValidationFailure('Recovery method required'));
    }

    return await _repository.verifyTwoFactorRecovery(
      securityAnswers: securityAnswers,
      backupCode: backupCode,
      recoveryToken: recoveryToken,
    );
  }
}

class DisableTwoFactorTemporarilyUseCase {
  final SecurityRepository _repository;

  const DisableTwoFactorTemporarilyUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String reason,
    int durationMinutes = 60,
  }) async {
    if (reason.isEmpty) {
      return const Left(ValidationFailure('Reason cannot be empty'));
    }

    if (durationMinutes < 1 || durationMinutes > 1440) { // Max 24 hours
      return const Left(ValidationFailure('Duration must be between 1 and 1440 minutes'));
    }

    return await _repository.disableTwoFactorTemporarily(
      reason: reason,
      durationMinutes: durationMinutes,
    );
  }
}

class GetTwoFactorStatsUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorStatsUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    return await _repository.getTwoFactorStats();
  }
}

class ConfigureTwoFactorMethodUseCase {
  final SecurityRepository _repository;

  const ConfigureTwoFactorMethodUseCase(this._repository);

  Future<Either<Failure, TwoFactorMethod>> call(TwoFactorMethod method, Map<String, dynamic> config) async {
    if (method == TwoFactorMethod.sms && !config.containsKey('phoneNumber')) {
      return const Left(ValidationFailure('Phone number required for SMS'));
    }

    if (method == TwoFactorMethod.email && !config.containsKey('email')) {
      return const Left(ValidationFailure('Email required for email verification'));
    }

    if (method == TwoFactorMethod.authenticator && !config.containsKey('secret')) {
      return const Left(ValidationFailure('Secret required for authenticator'));
    }

    return await _repository.configureTwoFactorMethod(method, config);
  }
}

class UnconfigureTwoFactorMethodUseCase {
  final SecurityRepository _repository;

  const UnconfigureTwoFactorMethodUseCase(this._repository);

  Future<Either<Failure, void>> call(TwoFactorMethod method) async {
    return await _repository.unconfigureTwoFactorMethod(method);
  }
}

class GetTwoFactorVerificationHistoryUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorVerificationHistoryUseCase(this._repository);

  Future<Either<Failure, List<TwoFactorVerification>>> call({
    int limit = 20,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (limit < 1 || limit > 100) {
      return const Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    return await _repository.getTwoFactorVerificationHistory(
      limit: limit,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}

class SetTwoFactorPrimaryMethodUseCase {
  final SecurityRepository _repository;

  const SetTwoFactorPrimaryMethodUseCase(this._repository);

  Future<Either<Failure, TwoFactorAuth>> call(TwoFactorMethod method) async {
    return await _repository.setTwoFactorPrimaryMethod(method);
  }
}

class GetTwoFactorMethodsUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorMethodsUseCase(this._repository);

  Future<Either<Failure, List<TwoFactorMethod>>> call() async {
    return await _repository.getTwoFactorMethods();
  }
}

class TestTwoFactorSetupUseCase {
  final SecurityRepository _repository;

  const TestTwoFactorSetupUseCase(this._repository);

  Future<Either<Failure, bool>> call(TwoFactorMethod method) async {
    return await _repository.testTwoFactorSetup(method);
  }
}

class GetTwoFactorRecoveryCodesUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorRecoveryCodesUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() async {
    return await _repository.getTwoFactorRecoveryCodes();
  }
}

class RevokeTwoFactorRecoveryCodesUseCase {
  final SecurityRepository _repository;

  const RevokeTwoFactorRecoveryCodesUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.revokeTwoFactorRecoveryCodes();
  }
}

class GetTwoFactorSecurityQuestionsUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorSecurityQuestionsUseCase(this._repository);

  Future<Either<Failure, List<SecurityQuestion>>> call() async {
    return await _repository.getTwoFactorSecurityQuestions();
  }
}

class SetTwoFactorSecurityQuestionsUseCase {
  final SecurityRepository _repository;

  const SetTwoFactorSecurityQuestionsUseCase(this._repository);

  Future<Either<Failure, void>> call(List<SecurityQuestion> questions) async {
    if (questions.isEmpty) {
      return const Left(ValidationFailure('At least one security question required'));
    }

    if (questions.length < 3) {
      return const Left(ValidationFailure('At least 3 security questions required'));
    }

    return await _repository.setTwoFactorSecurityQuestions(questions);
  }
}

class VerifySecurityQuestionAnswersUseCase {
  final SecurityRepository _repository;

  const VerifySecurityQuestionAnswersUseCase(this._repository);

  Future<Either<Failure, bool>> call(Map<String, String> answers) async {
    if (answers.isEmpty) {
      return const Left(ValidationFailure('Answers cannot be empty'));
    }

    return await _repository.verifySecurityQuestionAnswers(answers);
  }
}

class ChangeTwoFactorMethodOrderUseCase {
  final SecurityRepository _repository;

  const ChangeTwoFactorMethodOrderUseCase(this._repository);

  Future<Either<Failure, TwoFactorAuth>> call(List<TwoFactorMethod> methods) async {
    if (methods.isEmpty) {
      return const Left(ValidationFailure('Methods cannot be empty'));
    }

    return await _repository.changeTwoFactorMethodOrder(methods);
  }
}

class GetTwoFactorMethodSettingsUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorMethodSettingsUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call(TwoFactorMethod method) async {
    return await _repository.getTwoFactorMethodSettings(method);
  }
}

class UpdateTwoFactorMethodSettingsUseCase {
  final SecurityRepository _repository;

  const UpdateTwoFactorMethodSettingsUseCase(this._repository);

  Future<Either<Failure, void>> call(TwoFactorMethod method, Map<String, dynamic> settings) async {
    if (settings.isEmpty) {
      return const Left(ValidationFailure('Settings cannot be empty'));
    }

    return await _repository.updateTwoFactorMethodSettings(method, settings);
  }
}

class GetTwoFactorBackupEmailUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorBackupEmailUseCase(this._repository);

  Future<Either<Failure, String?>> call() async {
    return await _repository.getTwoFactorBackupEmail();
  }
}

class SetTwoFactorBackupEmailUseCase {
  final SecurityRepository _repository;

  const SetTwoFactorBackupEmailUseCase(this._repository);

  Future<Either<Failure, void>> call(String email) async {
    if (email.isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty'));
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return const Left(ValidationFailure('Invalid email format'));
    }

    return await _repository.setTwoFactorBackupEmail(email);
  }
}

class GetTwoFactorBackupPhoneUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorBackupPhoneUseCase(this._repository);

  Future<Either<Failure, String?>> call() async {
    return await _repository.getTwoFactorBackupPhone();
  }
}

class SetTwoFactorBackupPhoneUseCase {
  final SecurityRepository _repository;

  const SetTwoFactorBackupPhoneUseCase(this._repository);

  Future<Either<Failure, void>> call(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      return const Left(ValidationFailure('Phone number cannot be empty'));
    }

    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      return const Left(ValidationFailure('Invalid phone number format'));
    }

    return await _repository.setTwoFactorBackupPhone(phoneNumber);
  }
}
