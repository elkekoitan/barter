import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/security.dart';

abstract class SecurityRepository {
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

  // Real-time Security Operations
  Stream<Either<Failure, SecurityAlert>> subscribeToSecurityAlerts();

  Stream<Either<Failure, List<DeviceInfo>>> subscribeToDeviceChanges();

  Stream<Either<Failure, List<LoginSession>>> subscribeToSessionChanges();

  Stream<Either<Failure, SecurityStats>> subscribeToSecurityStats();

  Stream<Either<Failure, bool>> subscribeToSuspiciousActivity();
}
