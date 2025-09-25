import 'package:dartz/dartz.dart';
import '../../entities/security.dart';
import '../../repositories/security_repository.dart';
import '../../../core/errors/failures.dart';

class GetTwoFactorStatusUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorStatusUseCase(this._repository);

  Future<Either<Failure, TwoFactorAuth>> call() {
    return _repository.getTwoFactorStatus();
  }
}

class EnableTwoFactorAuthUseCase {
  final SecurityRepository _repository;

  const EnableTwoFactorAuthUseCase(this._repository);

  Future<Either<Failure, TwoFactorAuth>> call({
    required TwoFactorMethod method,
    String? phoneNumber,
    String? email,
    bool setAsPrimary = true,
  }) {
    return _repository.enableTwoFactorAuth(
      method: method,
      phoneNumber: phoneNumber,
      email: email,
      setAsPrimary: setAsPrimary,
    );
  }
}

class DisableTwoFactorAuthUseCase {
  final SecurityRepository _repository;

  const DisableTwoFactorAuthUseCase(this._repository);

  Future<Either<Failure, void>> call(String password) {
    return _repository.disableTwoFactorAuth(password);
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
  }) {
    return _repository.verifyTwoFactorCode(
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

  Future<Either<Failure, String>> call(
    TwoFactorMethod method, {
    String? phoneNumber,
    String? email,
  }) {
    return _repository.sendTwoFactorCode(
      method,
      phoneNumber: phoneNumber,
      email: email,
    );
  }
}

class GenerateBackupCodesUseCase {
  final SecurityRepository _repository;

  const GenerateBackupCodesUseCase(this._repository);

  Future<Either<Failure, String>> call() {
    return _repository.generateBackupCodes();
  }
}

class VerifyBackupCodeUseCase {
  final SecurityRepository _repository;

  const VerifyBackupCodeUseCase(this._repository);

  Future<Either<Failure, bool>> call(String backupCode) {
    return _repository.verifyBackupCode(backupCode);
  }
}

class UpdateTwoFactorSettingsUseCase {
  final SecurityRepository _repository;

  const UpdateTwoFactorSettingsUseCase(this._repository);

  Future<Either<Failure, TwoFactorAuth>> call(TwoFactorAuth settings) {
    return _repository.updateTwoFactorSettings(settings);
  }
}

class GetTwoFactorRecoveryOptionsUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorRecoveryOptionsUseCase(this._repository);

  Future<Either<Failure, List<TwoFactorMethod>>> call() {
    return _repository.getTwoFactorRecoveryOptions();
  }
}

class SetupTwoFactorRecoveryUseCase {
  final SecurityRepository _repository;

  const SetupTwoFactorRecoveryUseCase(this._repository);

  Future<Either<Failure, void>> call({
    List<SecurityQuestion>? securityQuestions,
    String? backupEmail,
    String? backupPhone,
  }) {
    return _repository.setupTwoFactorRecovery(
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
  }) {
    return _repository.verifyTwoFactorRecovery(
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
  }) {
    return _repository.disableTwoFactorTemporarily(
      reason: reason,
      durationMinutes: durationMinutes,
    );
  }
}

class GetTwoFactorStatsUseCase {
  final SecurityRepository _repository;

  const GetTwoFactorStatsUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call() {
    return _repository.getTwoFactorStats();
  }
}

class GetSecurityAlertsUseCase {
  final SecurityRepository _repository;

  const GetSecurityAlertsUseCase(this._repository);

  Future<Either<Failure, List<SecurityAlert>>> call({
    SecurityAlertType? type,
    SecurityAlertSeverity? severity,
    bool unreadOnly = false,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getSecurityAlerts(
      type: type,
      severity: severity,
      unreadOnly: unreadOnly,
      page: page,
      limit: limit,
    );
  }
}

class MarkSecurityAlertAsReadUseCase {
  final SecurityRepository _repository;

  const MarkSecurityAlertAsReadUseCase(this._repository);

  Future<Either<Failure, void>> call(String alertId) {
    return _repository.markSecurityAlertAsRead(alertId);
  }
}

class GetTrustedDevicesUseCase {
  final SecurityRepository _repository;

  const GetTrustedDevicesUseCase(this._repository);

  Future<Either<Failure, List<DeviceInfo>>> call() {
    return _repository.getTrustedDevices();
  }
}

class TrustCurrentDeviceUseCase {
  final SecurityRepository _repository;

  const TrustCurrentDeviceUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.trustCurrentDevice();
  }
}

class RemoveTrustedDeviceUseCase {
  final SecurityRepository _repository;

  const RemoveTrustedDeviceUseCase(this._repository);

  Future<Either<Failure, void>> call(String deviceId) {
    return _repository.removeTrustedDevice(deviceId);
  }
}

class GetActiveSessionsUseCase {
  final SecurityRepository _repository;

  const GetActiveSessionsUseCase(this._repository);

  Future<Either<Failure, List<LoginSession>>> call() {
    return _repository.getActiveSessions();
  }
}

class TerminateSessionUseCase {
  final SecurityRepository _repository;

  const TerminateSessionUseCase(this._repository);

  Future<Either<Failure, void>> call(String sessionId) {
    return _repository.terminateSession(sessionId);
  }
}

class GetSecuritySettingsUseCase {
  final SecurityRepository _repository;

  const GetSecuritySettingsUseCase(this._repository);

  Future<Either<Failure, SecuritySettings>> call() {
    return _repository.getSecuritySettings();
  }
}

class UpdateSecuritySettingsUseCase {
  final SecurityRepository _repository;

  const UpdateSecuritySettingsUseCase(this._repository);

  Future<Either<Failure, SecuritySettings>> call(SecuritySettings settings) {
    return _repository.updateSecuritySettings(settings);
  }
}

class GetAuditLogsUseCase {
  final SecurityRepository _repository;

  const GetAuditLogsUseCase(this._repository);

  Future<Either<Failure, List<AuditLog>>> call({
    AuditAction? action,
    DateTime? fromDate,
    DateTime? toDate,
    String? resource,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getAuditLogs(
      action: action,
      fromDate: fromDate,
      toDate: toDate,
      resource: resource,
      page: page,
      limit: limit,
    );
  }
}

class GetSecurityStatsUseCase {
  final SecurityRepository _repository;

  const GetSecurityStatsUseCase(this._repository);

  Future<Either<Failure, SecurityStats>> call() {
    return _repository.getSecurityStats();
  }
}

class GetPasswordPolicyUseCase {
  final SecurityRepository _repository;

  const GetPasswordPolicyUseCase(this._repository);

  Future<Either<Failure, PasswordPolicy>> call() {
    return _repository.getPasswordPolicy();
  }
}

class UpdatePasswordPolicyUseCase {
  final SecurityRepository _repository;

  const UpdatePasswordPolicyUseCase(this._repository);

  Future<Either<Failure, PasswordPolicy>> call(PasswordPolicy policy) {
    return _repository.updatePasswordPolicy(policy);
  }
}

class ValidatePasswordStrengthUseCase {
  final SecurityRepository _repository;

  const ValidatePasswordStrengthUseCase(this._repository);

  Future<Either<Failure, bool>> call(String password) {
    return _repository.validatePasswordStrength(password);
  }
}

class GetPasswordStrengthUseCase {
  final SecurityRepository _repository;

  const GetPasswordStrengthUseCase(this._repository);

  Future<Either<Failure, int>> call(String password) {
    return _repository.getPasswordStrength(password);
  }
}

class CheckPasswordAgainstBreachedUseCase {
  final SecurityRepository _repository;

  const CheckPasswordAgainstBreachedUseCase(this._repository);

  Future<Either<Failure, List<String>>> call(String password) {
    return _repository.checkPasswordAgainstBreached(password);
  }
}

class IsRateLimitedUseCase {
  final SecurityRepository _repository;

  const IsRateLimitedUseCase(this._repository);

  Future<Either<Failure, bool>> call(String identifier, RateLimitType type) {
    return _repository.isRateLimited(identifier, type);
  }
}

class GetBiometricSettingsUseCase {
  final SecurityRepository _repository;

  const GetBiometricSettingsUseCase(this._repository);

  Future<Either<Failure, BiometricSettings>> call() {
    return _repository.getBiometricSettings();
  }
}

class UpdateBiometricSettingsUseCase {
  final SecurityRepository _repository;

  const UpdateBiometricSettingsUseCase(this._repository);

  Future<Either<Failure, BiometricSettings>> call(BiometricSettings settings) {
    return _repository.updateBiometricSettings(settings);
  }
}

class IsBiometricAvailableUseCase {
  final SecurityRepository _repository;

  const IsBiometricAvailableUseCase(this._repository);

  Future<Either<Failure, bool>> call() {
    return _repository.isBiometricAvailable();
  }
}

class AuthenticateWithBiometricUseCase {
  final SecurityRepository _repository;

  const AuthenticateWithBiometricUseCase(this._repository);

  Future<Either<Failure, bool>> call() {
    return _repository.authenticateWithBiometric();
  }
}

class EnableBiometricAuthUseCase {
  final SecurityRepository _repository;

  const EnableBiometricAuthUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.enableBiometricAuth();
  }
}

class DisableBiometricAuthUseCase {
  final SecurityRepository _repository;

  const DisableBiometricAuthUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.disableBiometricAuth();
  }
}

class GetSecurityConfigurationUseCase {
  final SecurityRepository _repository;

  const GetSecurityConfigurationUseCase(this._repository);

  Future<Either<Failure, SecurityConfiguration>> call() {
    return _repository.getSecurityConfiguration();
  }
}

class UpdateSecurityConfigurationUseCase {
  final SecurityRepository _repository;

  const UpdateSecurityConfigurationUseCase(this._repository);

  Future<Either<Failure, SecurityConfiguration>> call(SecurityConfiguration config) {
    return _repository.updateSecurityConfiguration(config);
  }
}

class PerformSecurityScanUseCase {
  final SecurityRepository _repository;

  const PerformSecurityScanUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.performSecurityScan();
  }
}

class GetSecurityScoreUseCase {
  final SecurityRepository _repository;

  const GetSecurityScoreUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call() {
    return _repository.getSecurityScore();
  }
}

class GetSecurityRecommendationsUseCase {
  final SecurityRepository _repository;

  const GetSecurityRecommendationsUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() {
    return _repository.getSecurityRecommendations();
  }
}

class UpdateSecurityScoreUseCase {
  final SecurityRepository _repository;

  const UpdateSecurityScoreUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.updateSecurityScore();
  }
}

class CheckSuspiciousActivityUseCase {
  final SecurityRepository _repository;

  const CheckSuspiciousActivityUseCase(this._repository);

  Future<Either<Failure, bool>> call(String activity) {
    return _repository.checkSuspiciousActivity(activity);
  }
}

class BlockSuspiciousIPUseCase {
  final SecurityRepository _repository;

  const BlockSuspiciousIPUseCase(this._repository);

  Future<Either<Failure, void>> call(String ipAddress) {
    return _repository.blockSuspiciousIP(ipAddress);
  }
}

class GetBlockedIPsUseCase {
  final SecurityRepository _repository;

  const GetBlockedIPsUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() {
    return _repository.getBlockedIPs();
  }
}

class IsIPBlockedUseCase {
  final SecurityRepository _repository;

  const IsIPBlockedUseCase(this._repository);

  Future<Either<Failure, bool>> call(String ipAddress) {
    return _repository.isIPBlocked(ipAddress);
  }
}

class CreateSecurityAlertUseCase {
  final SecurityRepository _repository;

  const CreateSecurityAlertUseCase(this._repository);

  Future<Either<Failure, void>> call(SecurityAlert alert) {
    return _repository.createSecurityAlert(alert);
  }
}

class GetSecurityAlertByIdUseCase {
  final SecurityRepository _repository;

  const GetSecurityAlertByIdUseCase(this._repository);

  Future<Either<Failure, SecurityAlert>> call(String alertId) {
    return _repository.getSecurityAlertById(alertId);
  }
}

class MarkAllSecurityAlertsAsReadUseCase {
  final SecurityRepository _repository;

  const MarkAllSecurityAlertsAsReadUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.markAllSecurityAlertsAsRead();
  }
}

class DeleteSecurityAlertUseCase {
  final SecurityRepository _repository;

  const DeleteSecurityAlertUseCase(this._repository);

  Future<Either<Failure, void>> call(String alertId) {
    return _repository.deleteSecurityAlert(alertId);
  }
}

class GetUnreadSecurityAlertsCountUseCase {
  final SecurityRepository _repository;

  const GetUnreadSecurityAlertsCountUseCase(this._repository);

  Future<Either<Failure, int>> call() {
    return _repository.getUnreadSecurityAlertsCount();
  }
}

class GetCurrentDeviceInfoUseCase {
  final SecurityRepository _repository;

  const GetCurrentDeviceInfoUseCase(this._repository);

  Future<Either<Failure, DeviceInfo>> call() {
    return _repository.getCurrentDeviceInfo();
  }
}

class AddTrustedDeviceUseCase {
  final SecurityRepository _repository;

  const AddTrustedDeviceUseCase(this._repository);

  Future<Either<Failure, DeviceInfo>> call(DeviceInfo device) {
    return _repository.addTrustedDevice(device);
  }
}

class UntrustCurrentDeviceUseCase {
  final SecurityRepository _repository;

  const UntrustCurrentDeviceUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.untrustCurrentDevice();
  }
}

class UpdateDeviceInfoUseCase {
  final SecurityRepository _repository;

  const UpdateDeviceInfoUseCase(this._repository);

  Future<Either<Failure, void>> call(String deviceId, DeviceInfo device) {
    return _repository.updateDeviceInfo(deviceId, device);
  }
}

class IsDeviceTrustedUseCase {
  final SecurityRepository _repository;

  const IsDeviceTrustedUseCase(this._repository);

  Future<Either<Failure, bool>> call(String deviceId) {
    return _repository.isDeviceTrusted(deviceId);
  }
}

class GetCurrentSessionUseCase {
  final SecurityRepository _repository;

  const GetCurrentSessionUseCase(this._repository);

  Future<Either<Failure, LoginSession>> call() {
    return _repository.getCurrentSession();
  }
}

class TerminateAllSessionsUseCase {
  final SecurityRepository _repository;

  const TerminateAllSessionsUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.terminateAllSessions();
  }
}

class TerminateOtherSessionsUseCase {
  final SecurityRepository _repository;

  const TerminateOtherSessionsUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.terminateOtherSessions();
  }
}

class ExtendSessionUseCase {
  final SecurityRepository _repository;

  const ExtendSessionUseCase(this._repository);

  Future<Either<Failure, void>> call(String sessionId) {
    return _repository.extendSession(sessionId);
  }
}

class UpdateSessionMetadataUseCase {
  final SecurityRepository _repository;

  const UpdateSessionMetadataUseCase(this._repository);

  Future<Either<Failure, void>> call(String sessionId, Map<String, dynamic> metadata) {
    return _repository.updateSessionMetadata(sessionId, metadata);
  }
}

class ResetSecuritySettingsUseCase {
  final SecurityRepository _repository;

  const ResetSecuritySettingsUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.resetSecuritySettings();
  }
}

class CreateAuditLogUseCase {
  final SecurityRepository _repository;

  const CreateAuditLogUseCase(this._repository);

  Future<Either<Failure, void>> call(AuditLog log) {
    return _repository.createAuditLog(log);
  }
}

class GetAuditLogsByActionUseCase {
  final SecurityRepository _repository;

  const GetAuditLogsByActionUseCase(this._repository);

  Future<Either<Failure, Map<String, int>>> call() {
    return _repository.getAuditLogsByAction();
  }
}

class GetAuditLogsByResourceUseCase {
  final SecurityRepository _repository;

  const GetAuditLogsByResourceUseCase(this._repository);

  Future<Either<Failure, Map<String, int>>> call() {
    return _repository.getAuditLogsByResource();
  }
}

class PurgeAuditLogsUseCase {
  final SecurityRepository _repository;

  const PurgeAuditLogsUseCase(this._repository);

  Future<Either<Failure, void>> call({DateTime? beforeDate}) {
    return _repository.purgeAuditLogs(beforeDate: beforeDate);
  }
}

class GetLoginAttemptsByMethodUseCase {
  final SecurityRepository _repository;

  const GetLoginAttemptsByMethodUseCase(this._repository);

  Future<Either<Failure, Map<String, int>>> call() {
    return _repository.getLoginAttemptsByMethod();
  }
}

class GetFailedLoginAttemptsByReasonUseCase {
  final SecurityRepository _repository;

  const GetFailedLoginAttemptsByReasonUseCase(this._repository);

  Future<Either<Failure, Map<String, int>>> call() {
    return _repository.getFailedLoginAttemptsByReason();
  }
}

class GetRecentSuspiciousIPsUseCase {
  final SecurityRepository _repository;

  const GetRecentSuspiciousIPsUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() {
    return _repository.getRecentSuspiciousIPs();
  }
}

class GetRecentSuspiciousDevicesUseCase {
  final SecurityRepository _repository;

  const GetRecentSuspiciousDevicesUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() {
    return _repository.getRecentSuspiciousDevices();
  }
}

class IncrementRateLimitUseCase {
  final SecurityRepository _repository;

  const IncrementRateLimitUseCase(this._repository);

  Future<Either<Failure, void>> call(String identifier, RateLimitType type) {
    return _repository.incrementRateLimit(identifier, type);
  }
}

class GetRateLimitUseCase {
  final SecurityRepository _repository;

  const GetRateLimitUseCase(this._repository);

  Future<Either<Failure, RateLimit>> call(String identifier, RateLimitType type) {
    return _repository.getRateLimit(identifier, type);
  }
}

class ResetRateLimitUseCase {
  final SecurityRepository _repository;

  const ResetRateLimitUseCase(this._repository);

  Future<Either<Failure, void>> call(String identifier, RateLimitType type) {
    return _repository.resetRateLimit(identifier, type);
  }
}

class ClearAllRateLimitsUseCase {
  final SecurityRepository _repository;

  const ClearAllRateLimitsUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.clearAllRateLimits();
  }
}

class GetBiometricDataUseCase {
  final SecurityRepository _repository;

  const GetBiometricDataUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call() {
    return _repository.getBiometricData();
  }
}

class CreateSecurityReportUseCase {
  final SecurityRepository _repository;

  const CreateSecurityReportUseCase(this._repository);

  Future<Either<Failure, SecurityReport>> call(SecurityReport report) {
    return _repository.createSecurityReport(report);
  }
}

class GetSecurityReportsUseCase {
  final SecurityRepository _repository;

  const GetSecurityReportsUseCase(this._repository);

  Future<Either<Failure, List<SecurityReport>>> call({
    SecurityReportType? type,
    SecurityReportStatus? status,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getSecurityReports(
      type: type,
      status: status,
      page: page,
      limit: limit,
    );
  }
}

class GetSecurityReportByIdUseCase {
  final SecurityRepository _repository;

  const GetSecurityReportByIdUseCase(this._repository);

  Future<Either<Failure, SecurityReport>> call(String reportId) {
    return _repository.getSecurityReportById(reportId);
  }
}

class UpdateSecurityReportUseCase {
  final SecurityRepository _repository;

  const UpdateSecurityReportUseCase(this._repository);

  Future<Either<Failure, SecurityReport>> call(String reportId, SecurityReport report) {
    return _repository.updateSecurityReport(reportId, report);
  }
}

class ResolveSecurityReportUseCase {
  final SecurityRepository _repository;

  const ResolveSecurityReportUseCase(this._repository);

  Future<Either<Failure, void>> call(String reportId, String resolution, String resolvedBy) {
    return _repository.resolveSecurityReport(reportId, resolution, resolvedBy);
  }
}

class EscalateSecurityReportUseCase {
  final SecurityRepository _repository;

  const EscalateSecurityReportUseCase(this._repository);

  Future<Either<Failure, void>> call(String reportId) {
    return _repository.escalateSecurityReport(reportId);
  }
}

class CloseSecurityReportUseCase {
  final SecurityRepository _repository;

  const CloseSecurityReportUseCase(this._repository);

  Future<Either<Failure, void>> call(String reportId) {
    return _repository.closeSecurityReport(reportId);
  }
}

class ResetSecurityConfigurationUseCase {
  final SecurityRepository _repository;

  const ResetSecurityConfigurationUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.resetSecurityConfiguration();
  }
}

class UnblockIPUseCase {
  final SecurityRepository _repository;

  const UnblockIPUseCase(this._repository);

  Future<Either<Failure, void>> call(String ipAddress) {
    return _repository.unblockIP(ipAddress);
  }
}
