import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/security.dart';
import '../../domain/repositories/security_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/remote/security_remote_datasource.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  final SecurityRemoteDataSource _remoteDataSource;
  final Uuid _uuid = const Uuid();

  const SecurityRepositoryImpl(this._remoteDataSource);

  // Two-Factor Authentication Operations
  @override
  Future<Either<Failure, TwoFactorAuth>> enableTwoFactorAuth({
    required TwoFactorMethod method,
    String? phoneNumber,
    String? email,
    bool setAsPrimary = true,
  }) async {
    try {
      final twoFactorAuth = await _remoteDataSource.enableTwoFactorAuth(
        method: method,
        phoneNumber: phoneNumber,
        email: email,
        setAsPrimary: setAsPrimary,
      );

      return twoFactorAuth;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disableTwoFactorAuth(String password) async {
    try {
      return await _remoteDataSource.disableTwoFactorAuth(password);
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
      return await _remoteDataSource.verifyTwoFactorCode(
        code: code,
        method: method,
        verificationId: verificationId,
        trustDevice: trustDevice,
      );
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
      return await _remoteDataSource.sendTwoFactorCode(
        method,
        phoneNumber: phoneNumber,
        email: email,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateBackupCodes() async {
    try {
      return await _remoteDataSource.generateBackupCodes();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> regenerateBackupCodes() async {
    try {
      return await _remoteDataSource.regenerateBackupCodes();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyBackupCode(String backupCode) async {
    try {
      return await _remoteDataSource.verifyBackupCode(backupCode);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorAuth>> getTwoFactorStatus() async {
    try {
      return await _remoteDataSource.getTwoFactorStatus();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorAuth>> updateTwoFactorSettings(TwoFactorAuth settings) async {
    try {
      return await _remoteDataSource.updateTwoFactorSettings(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TwoFactorMethod>>> getTwoFactorRecoveryOptions() async {
    try {
      return await _remoteDataSource.getTwoFactorRecoveryOptions();
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
      return await _remoteDataSource.setupTwoFactorRecovery(
        securityQuestions: securityQuestions,
        backupEmail: backupEmail,
        backupPhone: backupPhone,
      );
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
      return await _remoteDataSource.verifyTwoFactorRecovery(
        securityAnswers: securityAnswers,
        backupCode: backupCode,
        recoveryToken: recoveryToken,
      );
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
      return await _remoteDataSource.disableTwoFactorTemporarily(
        reason: reason,
        durationMinutes: durationMinutes,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTwoFactorStats() async {
    try {
      return await _remoteDataSource.getTwoFactorStats();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorMethod>> configureTwoFactorMethod(TwoFactorMethod method, Map<String, dynamic> config) async {
    try {
      return await _remoteDataSource.configureTwoFactorMethod(method, config);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unconfigureTwoFactorMethod(TwoFactorMethod method) async {
    try {
      return await _remoteDataSource.unconfigureTwoFactorMethod(method);
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
      return await _remoteDataSource.getTwoFactorVerificationHistory(
        limit: limit,
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorAuth>> setTwoFactorPrimaryMethod(TwoFactorMethod method) async {
    try {
      return await _remoteDataSource.setTwoFactorPrimaryMethod(method);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TwoFactorMethod>>> getTwoFactorMethods() async {
    try {
      return await _remoteDataSource.getTwoFactorMethods();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> testTwoFactorSetup(TwoFactorMethod method) async {
    try {
      return await _remoteDataSource.testTwoFactorSetup(method);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTwoFactorRecoveryCodes() async {
    try {
      return await _remoteDataSource.getTwoFactorRecoveryCodes();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revokeTwoFactorRecoveryCodes() async {
    try {
      return await _remoteDataSource.revokeTwoFactorRecoveryCodes();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SecurityQuestion>>> getTwoFactorSecurityQuestions() async {
    try {
      return await _remoteDataSource.getTwoFactorSecurityQuestions();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTwoFactorSecurityQuestions(List<SecurityQuestion> questions) async {
    try {
      return await _remoteDataSource.setTwoFactorSecurityQuestions(questions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifySecurityQuestionAnswers(Map<String, String> answers) async {
    try {
      return await _remoteDataSource.verifySecurityQuestionAnswers(answers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorAuth>> changeTwoFactorMethodOrder(List<TwoFactorMethod> methods) async {
    try {
      return await _remoteDataSource.changeTwoFactorMethodOrder(methods);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTwoFactorMethodSettings(TwoFactorMethod method) async {
    try {
      return await _remoteDataSource.getTwoFactorMethodSettings(method);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTwoFactorMethodSettings(TwoFactorMethod method, Map<String, dynamic> settings) async {
    try {
      return await _remoteDataSource.updateTwoFactorMethodSettings(method, settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getTwoFactorBackupEmail() async {
    try {
      return await _remoteDataSource.getTwoFactorBackupEmail();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTwoFactorBackupEmail(String email) async {
    try {
      return await _remoteDataSource.setTwoFactorBackupEmail(email);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getTwoFactorBackupPhone() async {
    try {
      return await _remoteDataSource.getTwoFactorBackupPhone();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTwoFactorBackupPhone(String phoneNumber) async {
    try {
      return await _remoteDataSource.setTwoFactorBackupPhone(phoneNumber);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Alert Operations
  @override
  Future<Either<Failure, void>> createSecurityAlert(SecurityAlert alert) async {
    try {
      return await _remoteDataSource.createSecurityAlert(alert);
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
      return await _remoteDataSource.getSecurityAlerts(
        type: type,
        severity: severity,
        unreadOnly: unreadOnly,
        page: page,
        limit: limit,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityAlert>> getSecurityAlertById(String alertId) async {
    try {
      return await _remoteDataSource.getSecurityAlertById(alertId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markSecurityAlertAsRead(String alertId) async {
    try {
      return await _remoteDataSource.markSecurityAlertAsRead(alertId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllSecurityAlertsAsRead() async {
    try {
      return await _remoteDataSource.markAllSecurityAlertsAsRead();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSecurityAlert(String alertId) async {
    try {
      return await _remoteDataSource.deleteSecurityAlert(alertId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllSecurityAlerts() async {
    try {
      return await _remoteDataSource.deleteAllSecurityAlerts();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadSecurityAlertsCount() async {
    try {
      return await _remoteDataSource.getUnreadSecurityAlertsCount();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Device Management Operations
  @override
  Future<Either<Failure, List<DeviceInfo>>> getTrustedDevices() async {
    try {
      return await _remoteDataSource.getTrustedDevices();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeviceInfo>> getCurrentDeviceInfo() async {
    try {
      return await _remoteDataSource.getCurrentDeviceInfo();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeviceInfo>> addTrustedDevice(DeviceInfo device) async {
    try {
      return await _remoteDataSource.addTrustedDevice(device);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeTrustedDevice(String deviceId) async {
    try {
      return await _remoteDataSource.removeTrustedDevice(deviceId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> trustCurrentDevice() async {
    try {
      return await _remoteDataSource.trustCurrentDevice();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> untrustCurrentDevice() async {
    try {
      return await _remoteDataSource.untrustCurrentDevice();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDeviceInfo(String deviceId, DeviceInfo device) async {
    try {
      return await _remoteDataSource.updateDeviceInfo(deviceId, device);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isDeviceTrusted(String deviceId) async {
    try {
      return await _remoteDataSource.isDeviceTrusted(deviceId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Session Management Operations
  @override
  Future<Either<Failure, List<LoginSession>>> getActiveSessions() async {
    try {
      return await _remoteDataSource.getActiveSessions();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginSession>> getCurrentSession() async {
    try {
      return await _remoteDataSource.getCurrentSession();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateSession(String sessionId) async {
    try {
      return await _remoteDataSource.terminateSession(sessionId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateAllSessions() async {
    try {
      return await _remoteDataSource.terminateAllSessions();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateOtherSessions() async {
    try {
      return await _remoteDataSource.terminateOtherSessions();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> extendSession(String sessionId) async {
    try {
      return await _remoteDataSource.extendSession(sessionId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSessionMetadata(String sessionId, Map<String, dynamic> metadata) async {
    try {
      return await _remoteDataSource.updateSessionMetadata(sessionId, metadata);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Settings Operations
  @override
  Future<Either<Failure, SecuritySettings>> getSecuritySettings() async {
    try {
      return await _remoteDataSource.getSecuritySettings();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecuritySettings>> updateSecuritySettings(SecuritySettings settings) async {
    try {
      return await _remoteDataSource.updateSecuritySettings(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetSecuritySettings() async {
    try {
      return await _remoteDataSource.resetSecuritySettings();
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
      return await _remoteDataSource.getAuditLogs(
        action: action,
        fromDate: fromDate,
        toDate: toDate,
        resource: resource,
        page: page,
        limit: limit,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuditLog>> getAuditLogById(String logId) async {
    try {
      return await _remoteDataSource.getAuditLogById(logId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createAuditLog(AuditLog log) async {
    try {
      return await _remoteDataSource.createAuditLog(log);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getAuditLogsByAction() async {
    try {
      return await _remoteDataSource.getAuditLogsByAction();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getAuditLogsByResource() async {
    try {
      return await _remoteDataSource.getAuditLogsByResource();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> purgeAuditLogs({DateTime? beforeDate}) async {
    try {
      return await _remoteDataSource.purgeAuditLogs(beforeDate: beforeDate);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Stats Operations
  @override
  Future<Either<Failure, SecurityStats>> getSecurityStats() async {
    try {
      return await _remoteDataSource.getSecurityStats();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getLoginAttemptsByMethod() async {
    try {
      return await _remoteDataSource.getLoginAttemptsByMethod();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getFailedLoginAttemptsByReason() async {
    try {
      return await _remoteDataSource.getFailedLoginAttemptsByReason();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSuspiciousIPs() async {
    try {
      return await _remoteDataSource.getRecentSuspiciousIPs();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSuspiciousDevices() async {
    try {
      return await _remoteDataSource.getRecentSuspiciousDevices();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Password Policy Operations
  @override
  Future<Either<Failure, PasswordPolicy>> getPasswordPolicy() async {
    try {
      return await _remoteDataSource.getPasswordPolicy();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PasswordPolicy>> updatePasswordPolicy(PasswordPolicy policy) async {
    try {
      return await _remoteDataSource.updatePasswordPolicy(policy);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validatePasswordStrength(String password) async {
    try {
      return await _remoteDataSource.validatePasswordStrength(password);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getPasswordStrength(String password) async {
    try {
      return await _remoteDataSource.getPasswordStrength(password);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> checkPasswordAgainstBreached(String password) async {
    try {
      return await _remoteDataSource.checkPasswordAgainstBreached(password);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Rate Limiting Operations
  @override
  Future<Either<Failure, bool>> isRateLimited(String identifier, RateLimitType type) async {
    try {
      return await _remoteDataSource.isRateLimited(identifier, type);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RateLimit>> getRateLimit(String identifier, RateLimitType type) async {
    try {
      return await _remoteDataSource.getRateLimit(identifier, type);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementRateLimit(String identifier, RateLimitType type) async {
    try {
      return await _remoteDataSource.incrementRateLimit(identifier, type);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetRateLimit(String identifier, RateLimitType type) async {
    try {
      return await _remoteDataSource.resetRateLimit(identifier, type);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllRateLimits() async {
    try {
      return await _remoteDataSource.clearAllRateLimits();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Biometric Authentication Operations
  @override
  Future<Either<Failure, BiometricSettings>> getBiometricSettings() async {
    try {
      return await _remoteDataSource.getBiometricSettings();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BiometricSettings>> updateBiometricSettings(BiometricSettings settings) async {
    try {
      return await _remoteDataSource.updateBiometricSettings(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBiometricAvailable() async {
    try {
      return await _remoteDataSource.isBiometricAvailable();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometric() async {
    try {
      return await _remoteDataSource.authenticateWithBiometric();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableBiometricAuth() async {
    try {
      return await _remoteDataSource.enableBiometricAuth();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disableBiometricAuth() async {
    try {
      return await _remoteDataSource.disableBiometricAuth();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBiometricData() async {
    try {
      return await _remoteDataSource.getBiometricData();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Reports Operations
  @override
  Future<Either<Failure, SecurityReport>> createSecurityReport(SecurityReport report) async {
    try {
      return await _remoteDataSource.createSecurityReport(report);
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
      return await _remoteDataSource.getSecurityReports(
        type: type,
        status: status,
        page: page,
        limit: limit,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityReport>> getSecurityReportById(String reportId) async {
    try {
      return await _remoteDataSource.getSecurityReportById(reportId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityReport>> updateSecurityReport(String reportId, SecurityReport report) async {
    try {
      return await _remoteDataSource.updateSecurityReport(reportId, report);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resolveSecurityReport(String reportId, String resolution, String resolvedBy) async {
    try {
      return await _remoteDataSource.resolveSecurityReport(reportId, resolution, resolvedBy);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> escalateSecurityReport(String reportId) async {
    try {
      return await _remoteDataSource.escalateSecurityReport(reportId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> closeSecurityReport(String reportId) async {
    try {
      return await _remoteDataSource.closeSecurityReport(reportId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Security Configuration Operations
  @override
  Future<Either<Failure, SecurityConfiguration>> getSecurityConfiguration() async {
    try {
      return await _remoteDataSource.getSecurityConfiguration();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityConfiguration>> updateSecurityConfiguration(SecurityConfiguration config) async {
    try {
      return await _remoteDataSource.updateSecurityConfiguration(config);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetSecurityConfiguration() async {
    try {
      return await _remoteDataSource.resetSecurityConfiguration();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Advanced Security Operations
  @override
  Future<Either<Failure, void>> performSecurityScan() async {
    try {
      return await _remoteDataSource.performSecurityScan();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSecurityScore() async {
    try {
      return await _remoteDataSource.getSecurityScore();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSecurityRecommendations() async {
    try {
      return await _remoteDataSource.getSecurityRecommendations();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSecurityScore() async {
    try {
      return await _remoteDataSource.updateSecurityScore();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkSuspiciousActivity(String activity) async {
    try {
      return await _remoteDataSource.checkSuspiciousActivity(activity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> blockSuspiciousIP(String ipAddress) async {
    try {
      return await _remoteDataSource.blockSuspiciousIP(ipAddress);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unblockIP(String ipAddress) async {
    try {
      return await _remoteDataSource.unblockIP(ipAddress);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getBlockedIPs() async {
    try {
      return await _remoteDataSource.getBlockedIPs();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isIPBlocked(String ipAddress) async {
    try {
      return await _remoteDataSource.isIPBlocked(ipAddress);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
