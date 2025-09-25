import 'package:equatable/equatable.dart';
import '../../../domain/entities/security.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object?> get props => [];
}

// Two-Factor Authentication Events
class EnableTwoFactorAuthRequested extends SecurityEvent {
  final TwoFactorMethod method;
  final String? phoneNumber;
  final String? email;
  final bool setAsPrimary;

  const EnableTwoFactorAuthRequested({
    required this.method,
    this.phoneNumber,
    this.email,
    this.setAsPrimary = true,
  });

  @override
  List<Object?> get props => [method, phoneNumber, email, setAsPrimary];
}

class DisableTwoFactorAuthRequested extends SecurityEvent {
  final String password;

  const DisableTwoFactorAuthRequested(this.password);

  @override
  List<Object?> get props => [password];
}

class VerifyTwoFactorCodeRequested extends SecurityEvent {
  final String code;
  final TwoFactorMethod method;
  final String? verificationId;
  final bool trustDevice;

  const VerifyTwoFactorCodeRequested({
    required this.code,
    required this.method,
    this.verificationId,
    this.trustDevice = false,
  });

  @override
  List<Object?> get props => [code, method, verificationId, trustDevice];
}

class SendTwoFactorCodeRequested extends SecurityEvent {
  final TwoFactorMethod method;
  final String? phoneNumber;
  final String? email;

  const SendTwoFactorCodeRequested({
    required this.method,
    this.phoneNumber,
    this.email,
  });

  @override
  List<Object?> get props => [method, phoneNumber, email];
}

class GenerateBackupCodesRequested extends SecurityEvent {}

class VerifyBackupCodeRequested extends SecurityEvent {
  final String backupCode;

  const VerifyBackupCodeRequested(this.backupCode);

  @override
  List<Object?> get props => [backupCode];
}

class GetTwoFactorStatusRequested extends SecurityEvent {}

class UpdateTwoFactorSettingsRequested extends SecurityEvent {
  final TwoFactorAuth settings;

  const UpdateTwoFactorSettingsRequested(this.settings);

  @override
  List<Object?> get props => [settings];
}

class GetTwoFactorRecoveryOptionsRequested extends SecurityEvent {}

class SetupTwoFactorRecoveryRequested extends SecurityEvent {
  final List<SecurityQuestion>? securityQuestions;
  final String? backupEmail;
  final String? backupPhone;

  const SetupTwoFactorRecoveryRequested({
    this.securityQuestions,
    this.backupEmail,
    this.backupPhone,
  });

  @override
  List<Object?> get props => [securityQuestions, backupEmail, backupPhone];
}

class VerifyTwoFactorRecoveryRequested extends SecurityEvent {
  final List<String>? securityAnswers;
  final String? backupCode;
  final String? recoveryToken;

  const VerifyTwoFactorRecoveryRequested({
    this.securityAnswers,
    this.backupCode,
    this.recoveryToken,
  });

  @override
  List<Object?> get props => [securityAnswers, backupCode, recoveryToken];
}

class DisableTwoFactorTemporarilyRequested extends SecurityEvent {
  final String reason;
  final int durationMinutes;

  const DisableTwoFactorTemporarilyRequested({
    required this.reason,
    this.durationMinutes = 60,
  });

  @override
  List<Object?> get props => [reason, durationMinutes];
}

class GetTwoFactorStatsRequested extends SecurityEvent {}

class ConfigureTwoFactorMethodRequested extends SecurityEvent {
  final TwoFactorMethod method;
  final Map<String, dynamic> config;

  const ConfigureTwoFactorMethodRequested(this.method, this.config);

  @override
  List<Object?> get props => [method, config];
}

class UnconfigureTwoFactorMethodRequested extends SecurityEvent {
  final TwoFactorMethod method;

  const UnconfigureTwoFactorMethodRequested(this.method);

  @override
  List<Object?> get props => [method];
}

class GetTwoFactorVerificationHistoryRequested extends SecurityEvent {
  final int limit;
  final DateTime? fromDate;
  final DateTime? toDate;

  const GetTwoFactorVerificationHistoryRequested({
    this.limit = 20,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [limit, fromDate, toDate];
}

class SetTwoFactorPrimaryMethodRequested extends SecurityEvent {
  final TwoFactorMethod method;

  const SetTwoFactorPrimaryMethodRequested(this.method);

  @override
  List<Object?> get props => [method];
}

class GetTwoFactorMethodsRequested extends SecurityEvent {}

class TestTwoFactorSetupRequested extends SecurityEvent {
  final TwoFactorMethod method;

  const TestTwoFactorSetupRequested(this.method);

  @override
  List<Object?> get props => [method];
}

class GetTwoFactorRecoveryCodesRequested extends SecurityEvent {}

class RevokeTwoFactorRecoveryCodesRequested extends SecurityEvent {}

class GetTwoFactorSecurityQuestionsRequested extends SecurityEvent {}

class SetTwoFactorSecurityQuestionsRequested extends SecurityEvent {
  final List<SecurityQuestion> questions;

  const SetTwoFactorSecurityQuestionsRequested(this.questions);

  @override
  List<Object?> get props => [questions];
}

class VerifySecurityQuestionAnswersRequested extends SecurityEvent {
  final Map<String, String> answers;

  const VerifySecurityQuestionAnswersRequested(this.answers);

  @override
  List<Object?> get props => [answers];
}

class ChangeTwoFactorMethodOrderRequested extends SecurityEvent {
  final List<TwoFactorMethod> methods;

  const ChangeTwoFactorMethodOrderRequested(this.methods);

  @override
  List<Object?> get props => [methods];
}

class GetTwoFactorMethodSettingsRequested extends SecurityEvent {
  final TwoFactorMethod method;

  const GetTwoFactorMethodSettingsRequested(this.method);

  @override
  List<Object?> get props => [method];
}

class UpdateTwoFactorMethodSettingsRequested extends SecurityEvent {
  final TwoFactorMethod method;
  final Map<String, dynamic> settings;

  const UpdateTwoFactorMethodSettingsRequested(this.method, this.settings);

  @override
  List<Object?> get props => [method, settings];
}

class GetTwoFactorBackupEmailRequested extends SecurityEvent {}

class SetTwoFactorBackupEmailRequested extends SecurityEvent {
  final String email;

  const SetTwoFactorBackupEmailRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class GetTwoFactorBackupPhoneRequested extends SecurityEvent {}

class SetTwoFactorBackupPhoneRequested extends SecurityEvent {
  final String phoneNumber;

  const SetTwoFactorBackupPhoneRequested(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

// Security Alert Events
class CreateSecurityAlertRequested extends SecurityEvent {
  final SecurityAlert alert;

  const CreateSecurityAlertRequested(this.alert);

  @override
  List<Object?> get props => [alert];
}

class GetSecurityAlertsRequested extends SecurityEvent {
  final SecurityAlertType? type;
  final SecurityAlertSeverity? severity;
  final bool unreadOnly;
  final int page;
  final int limit;

  const GetSecurityAlertsRequested({
    this.type,
    this.severity,
    this.unreadOnly = false,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [type, severity, unreadOnly, page, limit];
}

class GetSecurityAlertByIdRequested extends SecurityEvent {
  final String alertId;

  const GetSecurityAlertByIdRequested(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class MarkSecurityAlertAsReadRequested extends SecurityEvent {
  final String alertId;

  const MarkSecurityAlertAsReadRequested(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class MarkAllSecurityAlertsAsReadRequested extends SecurityEvent {}

class DeleteSecurityAlertRequested extends SecurityEvent {
  final String alertId;

  const DeleteSecurityAlertRequested(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class GetUnreadSecurityAlertsCountRequested extends SecurityEvent {}

// Device Management Events
class GetTrustedDevicesRequested extends SecurityEvent {}

class GetCurrentDeviceInfoRequested extends SecurityEvent {}

class AddTrustedDeviceRequested extends SecurityEvent {
  final DeviceInfo device;

  const AddTrustedDeviceRequested(this.device);

  @override
  List<Object?> get props => [device];
}

class RemoveTrustedDeviceRequested extends SecurityEvent {
  final String deviceId;

  const RemoveTrustedDeviceRequested(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class TrustCurrentDeviceRequested extends SecurityEvent {}

class UntrustCurrentDeviceRequested extends SecurityEvent {}

class UpdateDeviceInfoRequested extends SecurityEvent {
  final String deviceId;
  final DeviceInfo device;

  const UpdateDeviceInfoRequested(this.deviceId, this.device);

  @override
  List<Object?> get props => [deviceId, device];
}

class IsDeviceTrustedRequested extends SecurityEvent {
  final String deviceId;

  const IsDeviceTrustedRequested(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

// Session Management Events
class GetActiveSessionsRequested extends SecurityEvent {}

class GetCurrentSessionRequested extends SecurityEvent {}

class TerminateSessionRequested extends SecurityEvent {
  final String sessionId;

  const TerminateSessionRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class TerminateAllSessionsRequested extends SecurityEvent {}

class TerminateOtherSessionsRequested extends SecurityEvent {}

class ExtendSessionRequested extends SecurityEvent {
  final String sessionId;

  const ExtendSessionRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class UpdateSessionMetadataRequested extends SecurityEvent {
  final String sessionId;
  final Map<String, dynamic> metadata;

  const UpdateSessionMetadataRequested(this.sessionId, this.metadata);

  @override
  List<Object?> get props => [sessionId, metadata];
}

// Security Settings Events
class GetSecuritySettingsRequested extends SecurityEvent {}

class UpdateSecuritySettingsRequested extends SecurityEvent {
  final SecuritySettings settings;

  const UpdateSecuritySettingsRequested(this.settings);

  @override
  List<Object?> get props => [settings];
}

class ResetSecuritySettingsRequested extends SecurityEvent {}

// Audit Log Events
class GetAuditLogsRequested extends SecurityEvent {
  final AuditAction? action;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? resource;
  final int page;
  final int limit;

  const GetAuditLogsRequested({
    this.action,
    this.fromDate,
    this.toDate,
    this.resource,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [action, fromDate, toDate, resource, page, limit];
}

class GetAuditLogByIdRequested extends SecurityEvent {
  final String logId;

  const GetAuditLogByIdRequested(this.logId);

  @override
  List<Object?> get props => [logId];
}

class CreateAuditLogRequested extends SecurityEvent {
  final AuditLog log;

  const CreateAuditLogRequested(this.log);

  @override
  List<Object?> get props => [log];
}

class GetAuditLogsByActionRequested extends SecurityEvent {}

class GetAuditLogsByResourceRequested extends SecurityEvent {}

class PurgeAuditLogsRequested extends SecurityEvent {
  final DateTime? beforeDate;

  const PurgeAuditLogsRequested({this.beforeDate});

  @override
  List<Object?> get props => [beforeDate];
}

// Security Stats Events
class GetSecurityStatsRequested extends SecurityEvent {}

class GetLoginAttemptsByMethodRequested extends SecurityEvent {}

class GetFailedLoginAttemptsByReasonRequested extends SecurityEvent {}

class GetRecentSuspiciousIPsRequested extends SecurityEvent {}

class GetRecentSuspiciousDevicesRequested extends SecurityEvent {}

// Password Policy Events
class GetPasswordPolicyRequested extends SecurityEvent {}

class UpdatePasswordPolicyRequested extends SecurityEvent {
  final PasswordPolicy policy;

  const UpdatePasswordPolicyRequested(this.policy);

  @override
  List<Object?> get props => [policy];
}

class ValidatePasswordStrengthRequested extends SecurityEvent {
  final String password;

  const ValidatePasswordStrengthRequested(this.password);

  @override
  List<Object?> get props => [password];
}

class GetPasswordStrengthRequested extends SecurityEvent {
  final String password;

  const GetPasswordStrengthRequested(this.password);

  @override
  List<Object?> get props => [password];
}

class CheckPasswordAgainstBreachedRequested extends SecurityEvent {
  final String password;

  const CheckPasswordAgainstBreachedRequested(this.password);

  @override
  List<Object?> get props => [password];
}

// Rate Limiting Events
class IsRateLimitedRequested extends SecurityEvent {
  final String identifier;
  final RateLimitType type;

  const IsRateLimitedRequested(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class GetRateLimitRequested extends SecurityEvent {
  final String identifier;
  final RateLimitType type;

  const GetRateLimitRequested(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class IncrementRateLimitRequested extends SecurityEvent {
  final String identifier;
  final RateLimitType type;

  const IncrementRateLimitRequested(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class ResetRateLimitRequested extends SecurityEvent {
  final String identifier;
  final RateLimitType type;

  const ResetRateLimitRequested(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class ClearAllRateLimitsRequested extends SecurityEvent {}

// Biometric Authentication Events
class GetBiometricSettingsRequested extends SecurityEvent {}

class UpdateBiometricSettingsRequested extends SecurityEvent {
  final BiometricSettings settings;

  const UpdateBiometricSettingsRequested(this.settings);

  @override
  List<Object?> get props => [settings];
}

class IsBiometricAvailableRequested extends SecurityEvent {}

class AuthenticateWithBiometricRequested extends SecurityEvent {}

class EnableBiometricAuthRequested extends SecurityEvent {}

class DisableBiometricAuthRequested extends SecurityEvent {}

class GetBiometricDataRequested extends SecurityEvent {}

// Security Reports Events
class CreateSecurityReportRequested extends SecurityEvent {
  final SecurityReport report;

  const CreateSecurityReportRequested(this.report);

  @override
  List<Object?> get props => [report];
}

class GetSecurityReportsRequested extends SecurityEvent {
  final SecurityReportType? type;
  final SecurityReportStatus? status;
  final int page;
  final int limit;

  const GetSecurityReportsRequested({
    this.type,
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [type, status, page, limit];
}

class GetSecurityReportByIdRequested extends SecurityEvent {
  final String reportId;

  const GetSecurityReportByIdRequested(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

class UpdateSecurityReportRequested extends SecurityEvent {
  final String reportId;
  final SecurityReport report;

  const UpdateSecurityReportRequested(this.reportId, this.report);

  @override
  List<Object?> get props => [reportId, report];
}

class ResolveSecurityReportRequested extends SecurityEvent {
  final String reportId;
  final String resolution;
  final String resolvedBy;

  const ResolveSecurityReportRequested(this.reportId, this.resolution, this.resolvedBy);

  @override
  List<Object?> get props => [reportId, resolution, resolvedBy];
}

class EscalateSecurityReportRequested extends SecurityEvent {
  final String reportId;

  const EscalateSecurityReportRequested(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

class CloseSecurityReportRequested extends SecurityEvent {
  final String reportId;

  const CloseSecurityReportRequested(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

// Security Configuration Events
class GetSecurityConfigurationRequested extends SecurityEvent {}

class UpdateSecurityConfigurationRequested extends SecurityEvent {
  final SecurityConfiguration config;

  const UpdateSecurityConfigurationRequested(this.config);

  @override
  List<Object?> get props => [config];
}

class ResetSecurityConfigurationRequested extends SecurityEvent {}

// Advanced Security Events
class PerformSecurityScanRequested extends SecurityEvent {}

class GetSecurityScoreRequested extends SecurityEvent {}

class GetSecurityRecommendationsRequested extends SecurityEvent {}

class UpdateSecurityScoreRequested extends SecurityEvent {}

class CheckSuspiciousActivityRequested extends SecurityEvent {
  final String activity;

  const CheckSuspiciousActivityRequested(this.activity);

  @override
  List<Object?> get props => [activity];
}

class BlockSuspiciousIPRequested extends SecurityEvent {
  final String ipAddress;

  const BlockSuspiciousIPRequested(this.ipAddress);

  @override
  List<Object?> get props => [ipAddress];
}

class UnblockIPRequested extends SecurityEvent {
  final String ipAddress;

  const UnblockIPRequested(this.ipAddress);

  @override
  List<Object?> get props => [ipAddress];
}

class GetBlockedIPsRequested extends SecurityEvent {}

class IsIPBlockedRequested extends SecurityEvent {
  final String ipAddress;

  const IsIPBlockedRequested(this.ipAddress);

  @override
  List<Object?> get props => [ipAddress];
}
