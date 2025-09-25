import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/security.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';

abstract class SecurityRemoteDataSource {
  // Two-Factor Authentication Operations
  Future<Either<Failure, TwoFactorAuth>> enableTwoFactorAuth({
    required TwoFactorMethod method,
    String? phoneNumber,
    String? email,
    bool setAsPrimary = true,
  });

  Future<Either<Failure, void>> disableTwoFactorAuth(String password);

  Future<Either<Failure, bool>> verifyTwoFactorCode({
    required String code,
    required TwoFactorMethod method,
    String? verificationId,
    bool trustDevice = false,
  });

  Future<Either<Failure, String>> sendTwoFactorCode(
    TwoFactorMethod method, {
    String? phoneNumber,
    String? email,
  });

  Future<Either<Failure, String>> generateBackupCodes();

  Future<Either<Failure, String>> regenerateBackupCodes();

  Future<Either<Failure, bool>> verifyBackupCode(String backupCode);

  Future<Either<Failure, TwoFactorAuth>> getTwoFactorStatus();

  Future<Either<Failure, TwoFactorAuth>> updateTwoFactorSettings(TwoFactorAuth settings);

  Future<Either<Failure, List<TwoFactorMethod>>> getTwoFactorRecoveryOptions();

  Future<Either<Failure, void>> setupTwoFactorRecovery({
    List<SecurityQuestion>? securityQuestions,
    String? backupEmail,
    String? backupPhone,
  });

  Future<Either<Failure, bool>> verifyTwoFactorRecovery({
    List<String>? securityAnswers,
    String? backupCode,
    String? recoveryToken,
  });

  Future<Either<Failure, void>> disableTwoFactorTemporarily({
    required String reason,
    int durationMinutes = 60,
  });

  Future<Either<Failure, Map<String, dynamic>>> getTwoFactorStats();

  Future<Either<Failure, TwoFactorMethod>> configureTwoFactorMethod(TwoFactorMethod method, Map<String, dynamic> config);

  Future<Either<Failure, void>> unconfigureTwoFactorMethod(TwoFactorMethod method);

  Future<Either<Failure, List<TwoFactorVerification>>> getTwoFactorVerificationHistory({
    int limit = 20,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<Either<Failure, TwoFactorAuth>> setTwoFactorPrimaryMethod(TwoFactorMethod method);

  Future<Either<Failure, List<TwoFactorMethod>>> getTwoFactorMethods();

  Future<Either<Failure, bool>> testTwoFactorSetup(TwoFactorMethod method);

  Future<Either<Failure, List<String>>> getTwoFactorRecoveryCodes();

  Future<Either<Failure, void>> revokeTwoFactorRecoveryCodes();

  Future<Either<Failure, List<SecurityQuestion>>> getTwoFactorSecurityQuestions();

  Future<Either<Failure, void>> setTwoFactorSecurityQuestions(List<SecurityQuestion> questions);

  Future<Either<Failure, bool>> verifySecurityQuestionAnswers(Map<String, String> answers);

  Future<Either<Failure, TwoFactorAuth>> changeTwoFactorMethodOrder(List<TwoFactorMethod> methods);

  Future<Either<Failure, Map<String, dynamic>>> getTwoFactorMethodSettings(TwoFactorMethod method);

  Future<Either<Failure, void>> updateTwoFactorMethodSettings(TwoFactorMethod method, Map<String, dynamic> settings);

  Future<Either<Failure, String?>> getTwoFactorBackupEmail();

  Future<Either<Failure, void>> setTwoFactorBackupEmail(String email);

  Future<Either<Failure, String?>> getTwoFactorBackupPhone();

  Future<Either<Failure, void>> setTwoFactorBackupPhone(String phoneNumber);

  // Security Alert Operations
  Future<Either<Failure, void>> createSecurityAlert(SecurityAlert alert);

  Future<Either<Failure, List<SecurityAlert>>> getSecurityAlerts({
    SecurityAlertType? type,
    SecurityAlertSeverity? severity,
    bool unreadOnly = false,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, SecurityAlert>> getSecurityAlertById(String alertId);

  Future<Either<Failure, void>> markSecurityAlertAsRead(String alertId);

  Future<Either<Failure, void>> markAllSecurityAlertsAsRead();

  Future<Either<Failure, void>> deleteSecurityAlert(String alertId);

  Future<Either<Failure, void>> deleteAllSecurityAlerts();

  Future<Either<Failure, int>> getUnreadSecurityAlertsCount();

  // Device Management Operations
  Future<Either<Failure, List<DeviceInfo>>> getTrustedDevices();

  Future<Either<Failure, DeviceInfo>> getCurrentDeviceInfo();

  Future<Either<Failure, DeviceInfo>> addTrustedDevice(DeviceInfo device);

  Future<Either<Failure, void>> removeTrustedDevice(String deviceId);

  Future<Either<Failure, void>> trustCurrentDevice();

  Future<Either<Failure, void>> untrustCurrentDevice();

  Future<Either<Failure, void>> updateDeviceInfo(String deviceId, DeviceInfo device);

  Future<Either<Failure, bool>> isDeviceTrusted(String deviceId);

  // Session Management Operations
  Future<Either<Failure, List<LoginSession>>> getActiveSessions();

  Future<Either<Failure, LoginSession>> getCurrentSession();

  Future<Either<Failure, void>> terminateSession(String sessionId);

  Future<Either<Failure, void>> terminateAllSessions();

  Future<Either<Failure, void>> terminateOtherSessions();

  Future<Either<Failure, void>> extendSession(String sessionId);

  Future<Either<Failure, void>> updateSessionMetadata(String sessionId, Map<String, dynamic> metadata);

  // Security Settings Operations
  Future<Either<Failure, SecuritySettings>> getSecuritySettings();

  Future<Either<Failure, SecuritySettings>> updateSecuritySettings(SecuritySettings settings);

  Future<Either<Failure, void>> resetSecuritySettings();

  // Audit Log Operations
  Future<Either<Failure, List<AuditLog>>> getAuditLogs({
    AuditAction? action,
    DateTime? fromDate,
    DateTime? toDate,
    String? resource,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, AuditLog>> getAuditLogById(String logId);

  Future<Either<Failure, void>> createAuditLog(AuditLog log);

  Future<Either<Failure, Map<String, int>>> getAuditLogsByAction();

  Future<Either<Failure, Map<String, int>>> getAuditLogsByResource();

  Future<Either<Failure, void>> purgeAuditLogs({DateTime? beforeDate});

  // Security Stats Operations
  Future<Either<Failure, SecurityStats>> getSecurityStats();

  Future<Either<Failure, Map<String, int>>> getLoginAttemptsByMethod();

  Future<Either<Failure, Map<String, int>>> getFailedLoginAttemptsByReason();

  Future<Either<Failure, List<String>>> getRecentSuspiciousIPs();

  Future<Either<Failure, List<String>>> getRecentSuspiciousDevices();

  // Password Policy Operations
  Future<Either<Failure, PasswordPolicy>> getPasswordPolicy();

  Future<Either<Failure, PasswordPolicy>> updatePasswordPolicy(PasswordPolicy policy);

  Future<Either<Failure, bool>> validatePasswordStrength(String password);

  Future<Either<Failure, int>> getPasswordStrength(String password);

  Future<Either<Failure, List<String>>> checkPasswordAgainstBreached(String password);

  // Rate Limiting Operations
  Future<Either<Failure, bool>> isRateLimited(String identifier, RateLimitType type);

  Future<Either<Failure, RateLimit>> getRateLimit(String identifier, RateLimitType type);

  Future<Either<Failure, void>> incrementRateLimit(String identifier, RateLimitType type);

  Future<Either<Failure, void>> resetRateLimit(String identifier, RateLimitType type);

  Future<Either<Failure, void>> clearAllRateLimits();

  // Biometric Authentication Operations
  Future<Either<Failure, BiometricSettings>> getBiometricSettings();

  Future<Either<Failure, BiometricSettings>> updateBiometricSettings(BiometricSettings settings);

  Future<Either<Failure, bool>> isBiometricAvailable();

  Future<Either<Failure, bool>> authenticateWithBiometric();

  Future<Either<Failure, void>> enableBiometricAuth();

  Future<Either<Failure, void>> disableBiometricAuth();

  Future<Either<Failure, Map<String, dynamic>>> getBiometricData();

  // Security Reports Operations
  Future<Either<Failure, SecurityReport>> createSecurityReport(SecurityReport report);

  Future<Either<Failure, List<SecurityReport>>> getSecurityReports({
    SecurityReportType? type,
    SecurityReportStatus? status,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, SecurityReport>> getSecurityReportById(String reportId);

  Future<Either<Failure, SecurityReport>> updateSecurityReport(String reportId, SecurityReport report);

  Future<Either<Failure, void>> resolveSecurityReport(String reportId, String resolution, String resolvedBy);

  Future<Either<Failure, void>> escalateSecurityReport(String reportId);

  Future<Either<Failure, void>> closeSecurityReport(String reportId);

  // Security Configuration Operations
  Future<Either<Failure, SecurityConfiguration>> getSecurityConfiguration();

  Future<Either<Failure, SecurityConfiguration>> updateSecurityConfiguration(SecurityConfiguration config);

  Future<Either<Failure, void>> resetSecurityConfiguration();

  // Advanced Security Operations
  Future<Either<Failure, void>> performSecurityScan();

  Future<Either<Failure, Map<String, dynamic>>> getSecurityScore();

  Future<Either<Failure, List<String>>> getSecurityRecommendations();

  Future<Either<Failure, void>> updateSecurityScore();

  Future<Either<Failure, bool>> checkSuspiciousActivity(String activity);

  Future<Either<Failure, void>> blockSuspiciousIP(String ipAddress);

  Future<Either<Failure, void>> unblockIP(String ipAddress);

  Future<Either<Failure, List<String>>> getBlockedIPs();

  Future<Either<Failure, bool>> isIPBlocked(String ipAddress);
}

class SecurityRemoteDataSourceImpl implements SecurityRemoteDataSource {
  final ApiClient _apiClient;
  final Uuid _uuid = const Uuid();

  const SecurityRemoteDataSourceImpl(this._apiClient);

  // Two-Factor Authentication Operations
  @override
  Future<Either<Failure, TwoFactorAuth>> enableTwoFactorAuth({
    required TwoFactorMethod method,
    String? phoneNumber,
    String? email,
    bool setAsPrimary = true,
  }) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/enable',
        data: {
          'method': method.toString(),
          'phoneNumber': phoneNumber,
          'email': email,
          'setAsPrimary': setAsPrimary,
        },
      );

      final twoFactorAuth = TwoFactorAuth.fromJson(response.data);
      return Right(twoFactorAuth);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disableTwoFactorAuth(String password) async {
    try {
      await _apiClient.post(
        '/security/2fa/disable',
        data: {'password': password},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyTwoFactorCode({
    required String code,
    required TwoFactorMethod method,
    String? verificationId,
    bool trustDevice = false,
  }) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/verify',
        data: {
          'code': code,
          'method': method.toString(),
          'verificationId': verificationId,
          'trustDevice': trustDevice,
        },
      );
      return Right(response.data['valid'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendTwoFactorCode(
    TwoFactorMethod method, {
    String? phoneNumber,
    String? email,
  }) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/send-code',
        data: {
          'method': method.toString(),
          'phoneNumber': phoneNumber,
          'email': email,
        },
      );
      return Right(response.data['verificationId'] ?? '');
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateBackupCodes() async {
    try {
      final response = await _apiClient.post('/security/2fa/generate-backup-codes');
      return Right(response.data['backupCodes'].join(','));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> regenerateBackupCodes() async {
    try {
      final response = await _apiClient.post('/security/2fa/regenerate-backup-codes');
      return Right(response.data['backupCodes'].join(','));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyBackupCode(String backupCode) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/verify-backup-code',
        data: {'backupCode': backupCode},
      );
      return Right(response.data['valid'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorAuth>> getTwoFactorStatus() async {
    try {
      final response = await _apiClient.get('/security/2fa/status');
      final twoFactorAuth = TwoFactorAuth.fromJson(response.data);
      return Right(twoFactorAuth);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorAuth>> updateTwoFactorSettings(TwoFactorAuth settings) async {
    try {
      final response = await _apiClient.put(
        '/security/2fa/settings',
        data: settings.toJson(),
      );
      final twoFactorAuth = TwoFactorAuth.fromJson(response.data);
      return Right(twoFactorAuth);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TwoFactorMethod>>> getTwoFactorRecoveryOptions() async {
    try {
      final response = await _apiClient.get('/security/2fa/recovery-options');
      final methods = (response.data['methods'] as List)
          .map((e) => TwoFactorMethod.values.firstWhere((m) => m.toString() == e))
          .toList();
      return Right(methods);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setupTwoFactorRecovery({
    List<SecurityQuestion>? securityQuestions,
    String? backupEmail,
    String? backupPhone,
  }) async {
    try {
      await _apiClient.post(
        '/security/2fa/setup-recovery',
        data: {
          'securityQuestions': securityQuestions?.map((q) => q.toJson()).toList(),
          'backupEmail': backupEmail,
          'backupPhone': backupPhone,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyTwoFactorRecovery({
    List<String>? securityAnswers,
    String? backupCode,
    String? recoveryToken,
  }) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/verify-recovery',
        data: {
          'securityAnswers': securityAnswers,
          'backupCode': backupCode,
          'recoveryToken': recoveryToken,
        },
      );
      return Right(response.data['valid'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disableTwoFactorTemporarily({
    required String reason,
    int durationMinutes = 60,
  }) async {
    try {
      await _apiClient.post(
        '/security/2fa/disable-temporarily',
        data: {
          'reason': reason,
          'durationMinutes': durationMinutes,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTwoFactorStats() async {
    try {
      final response = await _apiClient.get('/security/2fa/stats');
      return Right(response.data as Map<String, dynamic>);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorMethod>> configureTwoFactorMethod(TwoFactorMethod method, Map<String, dynamic> config) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/configure-method',
        data: {
          'method': method.toString(),
          'config': config,
        },
      );
      final configuredMethod = TwoFactorMethod.values.firstWhere(
        (m) => m.toString() == response.data['method'],
      );
      return Right(configuredMethod);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unconfigureTwoFactorMethod(TwoFactorMethod method) async {
    try {
      await _apiClient.post(
        '/security/2fa/unconfigure-method',
        data: {'method': method.toString()},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TwoFactorVerification>>> getTwoFactorVerificationHistory({
    int limit = 20,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final response = await _apiClient.get('/security/2fa/verification-history', queryParameters: {
        'limit': limit,
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
      });
      final verifications = (response.data['verifications'] as List)
          .map((e) => TwoFactorVerification.fromJson(e))
          .toList();
      return Right(verifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorAuth>> setTwoFactorPrimaryMethod(TwoFactorMethod method) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/set-primary',
        data: {'method': method.toString()},
      );
      final twoFactorAuth = TwoFactorAuth.fromJson(response.data);
      return Right(twoFactorAuth);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TwoFactorMethod>>> getTwoFactorMethods() async {
    try {
      final response = await _apiClient.get('/security/2fa/methods');
      final methods = (response.data['methods'] as List)
          .map((e) => TwoFactorMethod.values.firstWhere((m) => m.toString() == e))
          .toList();
      return Right(methods);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> testTwoFactorSetup(TwoFactorMethod method) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/test-setup',
        data: {'method': method.toString()},
      );
      return Right(response.data['success'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTwoFactorRecoveryCodes() async {
    try {
      final response = await _apiClient.get('/security/2fa/recovery-codes');
      return Right(List<String>.from(response.data['recoveryCodes']));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revokeTwoFactorRecoveryCodes() async {
    try {
      await _apiClient.post('/security/2fa/revoke-recovery-codes');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SecurityQuestion>>> getTwoFactorSecurityQuestions() async {
    try {
      final response = await _apiClient.get('/security/2fa/security-questions');
      final questions = (response.data['questions'] as List)
          .map((e) => SecurityQuestion.fromJson(e))
          .toList();
      return Right(questions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTwoFactorSecurityQuestions(List<SecurityQuestion> questions) async {
    try {
      await _apiClient.post(
        '/security/2fa/set-security-questions',
        data: {'questions': questions.map((q) => q.toJson()).toList()},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifySecurityQuestionAnswers(Map<String, String> answers) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/verify-security-answers',
        data: {'answers': answers},
      );
      return Right(response.data['valid'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorAuth>> changeTwoFactorMethodOrder(List<TwoFactorMethod> methods) async {
    try {
      final response = await _apiClient.post(
        '/security/2fa/change-method-order',
        data: {'methods': methods.map((m) => m.toString()).toList()},
      );
      final twoFactorAuth = TwoFactorAuth.fromJson(response.data);
      return Right(twoFactorAuth);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTwoFactorMethodSettings(TwoFactorMethod method) async {
    try {
      final response = await _apiClient.get('/security/2fa/method-settings/${method.toString()}');
      return Right(response.data as Map<String, dynamic>);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTwoFactorMethodSettings(TwoFactorMethod method, Map<String, dynamic> settings) async {
    try {
      await _apiClient.put(
        '/security/2fa/method-settings/${method.toString()}',
        data: settings,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getTwoFactorBackupEmail() async {
    try {
      final response = await _apiClient.get('/security/2fa/backup-email');
      return Right(response.data['backupEmail']);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTwoFactorBackupEmail(String email) async {
    try {
      await _apiClient.post(
        '/security/2fa/set-backup-email',
        data: {'backupEmail': email},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getTwoFactorBackupPhone() async {
    try {
      final response = await _apiClient.get('/security/2fa/backup-phone');
      return Right(response.data['backupPhone']);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTwoFactorBackupPhone(String phoneNumber) async {
    try {
      await _apiClient.post(
        '/security/2fa/set-backup-phone',
        data: {'backupPhone': phoneNumber},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Alert Operations
  @override
  Future<Either<Failure, void>> createSecurityAlert(SecurityAlert alert) async {
    try {
      await _apiClient.post(
        '/security/alerts',
        data: alert.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SecurityAlert>>> getSecurityAlerts({
    SecurityAlertType? type,
    SecurityAlertSeverity? severity,
    bool unreadOnly = false,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get('/security/alerts', queryParameters: {
        'type': type?.toString(),
        'severity': severity?.toString(),
        'unreadOnly': unreadOnly,
        'page': page,
        'limit': limit,
      });
      final alerts = (response.data['alerts'] as List)
          .map((e) => SecurityAlert.fromJson(e))
          .toList();
      return Right(alerts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityAlert>> getSecurityAlertById(String alertId) async {
    try {
      final response = await _apiClient.get('/security/alerts/$alertId');
      final alert = SecurityAlert.fromJson(response.data);
      return Right(alert);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markSecurityAlertAsRead(String alertId) async {
    try {
      await _apiClient.put('/security/alerts/$alertId/mark-read');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllSecurityAlertsAsRead() async {
    try {
      await _apiClient.put('/security/alerts/mark-all-read');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSecurityAlert(String alertId) async {
    try {
      await _apiClient.delete('/security/alerts/$alertId');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllSecurityAlerts() async {
    try {
      await _apiClient.delete('/security/alerts');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadSecurityAlertsCount() async {
    try {
      final response = await _apiClient.get('/security/alerts/unread-count');
      return Right(response.data['count'] ?? 0);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Device Management Operations
  @override
  Future<Either<Failure, List<DeviceInfo>>> getTrustedDevices() async {
    try {
      final response = await _apiClient.get('/security/devices/trusted');
      final devices = (response.data['devices'] as List)
          .map((e) => DeviceInfo.fromJson(e))
          .toList();
      return Right(devices);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeviceInfo>> getCurrentDeviceInfo() async {
    try {
      final response = await _apiClient.get('/security/devices/current');
      final device = DeviceInfo.fromJson(response.data);
      return Right(device);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeviceInfo>> addTrustedDevice(DeviceInfo device) async {
    try {
      final response = await _apiClient.post(
        '/security/devices/trusted',
        data: device.toJson(),
      );
      final trustedDevice = DeviceInfo.fromJson(response.data);
      return Right(trustedDevice);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeTrustedDevice(String deviceId) async {
    try {
      await _apiClient.delete('/security/devices/trusted/$deviceId');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> trustCurrentDevice() async {
    try {
      await _apiClient.post('/security/devices/trust-current');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> untrustCurrentDevice() async {
    try {
      await _apiClient.post('/security/devices/untrust-current');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDeviceInfo(String deviceId, DeviceInfo device) async {
    try {
      await _apiClient.put(
        '/security/devices/$deviceId',
        data: device.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isDeviceTrusted(String deviceId) async {
    try {
      final response = await _apiClient.get('/security/devices/$deviceId/trusted');
      return Right(response.data['trusted'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Session Management Operations
  @override
  Future<Either<Failure, List<LoginSession>>> getActiveSessions() async {
    try {
      final response = await _apiClient.get('/security/sessions/active');
      final sessions = (response.data['sessions'] as List)
          .map((e) => LoginSession.fromJson(e))
          .toList();
      return Right(sessions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginSession>> getCurrentSession() async {
    try {
      final response = await _apiClient.get('/security/sessions/current');
      final session = LoginSession.fromJson(response.data);
      return Right(session);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateSession(String sessionId) async {
    try {
      await _apiClient.delete('/security/sessions/$sessionId');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateAllSessions() async {
    try {
      await _apiClient.delete('/security/sessions');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateOtherSessions() async {
    try {
      await _apiClient.delete('/security/sessions/others');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> extendSession(String sessionId) async {
    try {
      await _apiClient.post('/security/sessions/$sessionId/extend');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSessionMetadata(String sessionId, Map<String, dynamic> metadata) async {
    try {
      await _apiClient.put(
        '/security/sessions/$sessionId/metadata',
        data: metadata,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Settings Operations
  @override
  Future<Either<Failure, SecuritySettings>> getSecuritySettings() async {
    try {
      final response = await _apiClient.get('/security/settings');
      final settings = SecuritySettings.fromJson(response.data);
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecuritySettings>> updateSecuritySettings(SecuritySettings settings) async {
    try {
      final response = await _apiClient.put(
        '/security/settings',
        data: settings.toJson(),
      );
      final updatedSettings = SecuritySettings.fromJson(response.data);
      return Right(updatedSettings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetSecuritySettings() async {
    try {
      await _apiClient.post('/security/settings/reset');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Audit Log Operations
  @override
  Future<Either<Failure, List<AuditLog>>> getAuditLogs({
    AuditAction? action,
    DateTime? fromDate,
    DateTime? toDate,
    String? resource,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get('/security/audit-logs', queryParameters: {
        'action': action?.toString(),
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
        'resource': resource,
        'page': page,
        'limit': limit,
      });
      final logs = (response.data['logs'] as List)
          .map((e) => AuditLog.fromJson(e))
          .toList();
      return Right(logs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuditLog>> getAuditLogById(String logId) async {
    try {
      final response = await _apiClient.get('/security/audit-logs/$logId');
      final log = AuditLog.fromJson(response.data);
      return Right(log);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createAuditLog(AuditLog log) async {
    try {
      await _apiClient.post(
        '/security/audit-logs',
        data: log.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getAuditLogsByAction() async {
    try {
      final response = await _apiClient.get('/security/audit-logs/by-action');
      return Right(Map<String, int>.from(response.data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getAuditLogsByResource() async {
    try {
      final response = await _apiClient.get('/security/audit-logs/by-resource');
      return Right(Map<String, int>.from(response.data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> purgeAuditLogs({DateTime? beforeDate}) async {
    try {
      await _apiClient.delete('/security/audit-logs', queryParameters: {
        'beforeDate': beforeDate?.toIso8601String(),
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Stats Operations
  @override
  Future<Either<Failure, SecurityStats>> getSecurityStats() async {
    try {
      final response = await _apiClient.get('/security/stats');
      final stats = SecurityStats.fromJson(response.data);
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getLoginAttemptsByMethod() async {
    try {
      final response = await _apiClient.get('/security/stats/login-attempts-by-method');
      return Right(Map<String, int>.from(response.data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getFailedLoginAttemptsByReason() async {
    try {
      final response = await _apiClient.get('/security/stats/failed-login-attempts-by-reason');
      return Right(Map<String, int>.from(response.data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSuspiciousIPs() async {
    try {
      final response = await _apiClient.get('/security/stats/suspicious-ips');
      return Right(List<String>.from(response.data['ips']));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSuspiciousDevices() async {
    try {
      final response = await _apiClient.get('/security/stats/suspicious-devices');
      return Right(List<String>.from(response.data['devices']));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Password Policy Operations
  @override
  Future<Either<Failure, PasswordPolicy>> getPasswordPolicy() async {
    try {
      final response = await _apiClient.get('/security/password-policy');
      final policy = PasswordPolicy.fromJson(response.data);
      return Right(policy);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PasswordPolicy>> updatePasswordPolicy(PasswordPolicy policy) async {
    try {
      final response = await _apiClient.put(
        '/security/password-policy',
        data: policy.toJson(),
      );
      final updatedPolicy = PasswordPolicy.fromJson(response.data);
      return Right(updatedPolicy);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validatePasswordStrength(String password) async {
    try {
      final response = await _apiClient.post(
        '/security/validate-password-strength',
        data: {'password': password},
      );
      return Right(response.data['valid'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getPasswordStrength(String password) async {
    try {
      final response = await _apiClient.post(
        '/security/password-strength',
        data: {'password': password},
      );
      return Right(response.data['strength'] ?? 0);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> checkPasswordAgainstBreached(String password) async {
    try {
      final response = await _apiClient.post(
        '/security/check-password-breached',
        data: {'password': password},
      );
      return Right(List<String>.from(response.data['breaches']));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Rate Limiting Operations
  @override
  Future<Either<Failure, bool>> isRateLimited(String identifier, RateLimitType type) async {
    try {
      final response = await _apiClient.get('/security/rate-limit/$identifier/${type.toString()}');
      return Right(response.data['limited'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RateLimit>> getRateLimit(String identifier, RateLimitType type) async {
    try {
      final response = await _apiClient.get('/security/rate-limit/$identifier/${type.toString()}');
      final rateLimit = RateLimit.fromJson(response.data);
      return Right(rateLimit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementRateLimit(String identifier, RateLimitType type) async {
    try {
      await _apiClient.post('/security/rate-limit/$identifier/${type.toString()}/increment');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetRateLimit(String identifier, RateLimitType type) async {
    try {
      await _apiClient.post('/security/rate-limit/$identifier/${type.toString()}/reset');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllRateLimits() async {
    try {
      await _apiClient.delete('/security/rate-limit');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Biometric Authentication Operations
  @override
  Future<Either<Failure, BiometricSettings>> getBiometricSettings() async {
    try {
      final response = await _apiClient.get('/security/biometric/settings');
      final settings = BiometricSettings.fromJson(response.data);
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BiometricSettings>> updateBiometricSettings(BiometricSettings settings) async {
    try {
      final response = await _apiClient.put(
        '/security/biometric/settings',
        data: settings.toJson(),
      );
      final updatedSettings = BiometricSettings.fromJson(response.data);
      return Right(updatedSettings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBiometricAvailable() async {
    try {
      final response = await _apiClient.get('/security/biometric/available');
      return Right(response.data['available'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometric() async {
    try {
      final response = await _apiClient.post('/security/biometric/authenticate');
      return Right(response.data['authenticated'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableBiometricAuth() async {
    try {
      await _apiClient.post('/security/biometric/enable');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disableBiometricAuth() async {
    try {
      await _apiClient.post('/security/biometric/disable');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBiometricData() async {
    try {
      final response = await _apiClient.get('/security/biometric/data');
      return Right(response.data as Map<String, dynamic>);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Reports Operations
  @override
  Future<Either<Failure, SecurityReport>> createSecurityReport(SecurityReport report) async {
    try {
      final response = await _apiClient.post(
        '/security/reports',
        data: report.toJson(),
      );
      final createdReport = SecurityReport.fromJson(response.data);
      return Right(createdReport);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SecurityReport>>> getSecurityReports({
    SecurityReportType? type,
    SecurityReportStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get('/security/reports', queryParameters: {
        'type': type?.toString(),
        'status': status?.toString(),
        'page': page,
        'limit': limit,
      });
      final reports = (response.data['reports'] as List)
          .map((e) => SecurityReport.fromJson(e))
          .toList();
      return Right(reports);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityReport>> getSecurityReportById(String reportId) async {
    try {
      final response = await _apiClient.get('/security/reports/$reportId');
      final report = SecurityReport.fromJson(response.data);
      return Right(report);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityReport>> updateSecurityReport(String reportId, SecurityReport report) async {
    try {
      final response = await _apiClient.put(
        '/security/reports/$reportId',
        data: report.toJson(),
      );
      final updatedReport = SecurityReport.fromJson(response.data);
      return Right(updatedReport);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resolveSecurityReport(String reportId, String resolution, String resolvedBy) async {
    try {
      await _apiClient.post(
        '/security/reports/$reportId/resolve',
        data: {
          'resolution': resolution,
          'resolvedBy': resolvedBy,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> escalateSecurityReport(String reportId) async {
    try {
      await _apiClient.post('/security/reports/$reportId/escalate');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> closeSecurityReport(String reportId) async {
    try {
      await _apiClient.post('/security/reports/$reportId/close');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Configuration Operations
  @override
  Future<Either<Failure, SecurityConfiguration>> getSecurityConfiguration() async {
    try {
      final response = await _apiClient.get('/security/configuration');
      final config = SecurityConfiguration.fromJson(response.data);
      return Right(config);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityConfiguration>> updateSecurityConfiguration(SecurityConfiguration config) async {
    try {
      final response = await _apiClient.put(
        '/security/configuration',
        data: config.toJson(),
      );
      final updatedConfig = SecurityConfiguration.fromJson(response.data);
      return Right(updatedConfig);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetSecurityConfiguration() async {
    try {
      await _apiClient.post('/security/configuration/reset');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Advanced Security Operations
  @override
  Future<Either<Failure, void>> performSecurityScan() async {
    try {
      await _apiClient.post('/security/scan');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSecurityScore() async {
    try {
      final response = await _apiClient.get('/security/score');
      return Right(response.data as Map<String, dynamic>);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSecurityRecommendations() async {
    try {
      final response = await _apiClient.get('/security/recommendations');
      return Right(List<String>.from(response.data['recommendations']));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSecurityScore() async {
    try {
      await _apiClient.post('/security/score/update');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkSuspiciousActivity(String activity) async {
    try {
      final response = await _apiClient.post(
        '/security/check-suspicious',
        data: {'activity': activity},
      );
      return Right(response.data['suspicious'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> blockSuspiciousIP(String ipAddress) async {
    try {
      await _apiClient.post(
        '/security/block-ip',
        data: {'ipAddress': ipAddress},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unblockIP(String ipAddress) async {
    try {
      await _apiClient.post(
        '/security/unblock-ip',
        data: {'ipAddress': ipAddress},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getBlockedIPs() async {
    try {
      final response = await _apiClient.get('/security/blocked-ips');
      return Right(List<String>.from(response.data['ips']));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isIPBlocked(String ipAddress) async {
    try {
      final response = await _apiClient.get('/security/ip-blocked/$ipAddress');
      return Right(response.data['blocked'] ?? false);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
