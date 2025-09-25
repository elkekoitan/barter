import 'package:equatable/equatable.dart';
import '../../../domain/entities/security.dart';

abstract class SecurityState extends Equatable {
  const SecurityState();

  @override
  List<Object?> get props => [];
}

class SecurityInitial extends SecurityState {}

class SecurityLoading extends SecurityState {}

class SecurityLoaded extends SecurityState {
  final TwoFactorAuth? twoFactorAuth;
  final List<SecurityAlert> securityAlerts;
  final List<DeviceInfo> trustedDevices;
  final List<LoginSession> activeSessions;
  final SecuritySettings securitySettings;
  final List<AuditLog> auditLogs;
  final SecurityStats securityStats;
  final PasswordPolicy passwordPolicy;
  final BiometricSettings biometricSettings;
  final List<SecurityReport> securityReports;
  final SecurityConfiguration securityConfiguration;
  final Map<String, dynamic> securityScore;

  const SecurityLoaded({
    this.twoFactorAuth,
    this.securityAlerts = const [],
    this.trustedDevices = const [],
    this.activeSessions = const [],
    this.securitySettings = const SecuritySettings(),
    this.auditLogs = const [],
    this.securityStats = const SecurityStats(),
    this.passwordPolicy = const PasswordPolicy(),
    this.biometricSettings = const BiometricSettings(),
    this.securityReports = const [],
    this.securityConfiguration = const SecurityConfiguration(),
    this.securityScore = const {},
  });

  SecurityLoaded copyWith({
    TwoFactorAuth? twoFactorAuth,
    List<SecurityAlert>? securityAlerts,
    List<DeviceInfo>? trustedDevices,
    List<LoginSession>? activeSessions,
    SecuritySettings? securitySettings,
    List<AuditLog>? auditLogs,
    SecurityStats? securityStats,
    PasswordPolicy? passwordPolicy,
    BiometricSettings? biometricSettings,
    List<SecurityReport>? securityReports,
    SecurityConfiguration? securityConfiguration,
    Map<String, dynamic>? securityScore,
  }) {
    return SecurityLoaded(
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      securityAlerts: securityAlerts ?? this.securityAlerts,
      trustedDevices: trustedDevices ?? this.trustedDevices,
      activeSessions: activeSessions ?? this.activeSessions,
      securitySettings: securitySettings ?? this.securitySettings,
      auditLogs: auditLogs ?? this.auditLogs,
      securityStats: securityStats ?? this.securityStats,
      passwordPolicy: passwordPolicy ?? this.passwordPolicy,
      biometricSettings: biometricSettings ?? this.biometricSettings,
      securityReports: securityReports ?? this.securityReports,
      securityConfiguration: securityConfiguration ?? this.securityConfiguration,
      securityScore: securityScore ?? this.securityScore,
    );
  }

  @override
  List<Object?> get props => [
        twoFactorAuth,
        securityAlerts,
        trustedDevices,
        activeSessions,
        securitySettings,
        auditLogs,
        securityStats,
        passwordPolicy,
        biometricSettings,
        securityReports,
        securityConfiguration,
        securityScore,
      ];
}

// Two-Factor Authentication States
class TwoFactorAuthEnabled extends SecurityLoaded {
  const TwoFactorAuthEnabled(TwoFactorAuth twoFactorAuth)
      : super(twoFactorAuth: twoFactorAuth);
}

class TwoFactorAuthDisabled extends SecurityLoaded {}

class TwoFactorCodeSent extends SecurityState {
  final String verificationId;

  const TwoFactorCodeSent(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}

class TwoFactorCodeVerified extends SecurityState {
  final bool trustedDevice;

  const TwoFactorCodeVerified({this.trustedDevice = false});

  @override
  List<Object?> get props => [trustedDevice];
}

class BackupCodesGenerated extends SecurityState {
  final String backupCodes;

  const BackupCodesGenerated(this.backupCodes);

  @override
  List<Object?> get props => [backupCodes];
}

class BackupCodeVerified extends SecurityState {
  const BackupCodeVerified();
}

class TwoFactorSettingsUpdated extends SecurityLoaded {
  const TwoFactorSettingsUpdated(TwoFactorAuth twoFactorAuth)
      : super(twoFactorAuth: twoFactorAuth);
}

class TwoFactorRecoveryOptionsLoaded extends SecurityState {
  final List<TwoFactorMethod> options;

  const TwoFactorRecoveryOptionsLoaded(this.options);

  @override
  List<Object?> get props => [options];
}

class TwoFactorRecoverySetupCompleted extends SecurityState {}

class TwoFactorRecoveryVerified extends SecurityState {}

class TwoFactorTemporarilyDisabled extends SecurityState {}

class TwoFactorStatsLoaded extends SecurityState {
  final Map<String, dynamic> stats;

  const TwoFactorStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class TwoFactorMethodConfigured extends SecurityState {
  final TwoFactorMethod method;

  const TwoFactorMethodConfigured(this.method);

  @override
  List<Object?> get props => [method];
}

class TwoFactorMethodUnconfigured extends SecurityState {
  final TwoFactorMethod method;

  const TwoFactorMethodUnconfigured(this.method);

  @override
  List<Object?> get props => [method];
}

class TwoFactorVerificationHistoryLoaded extends SecurityState {
  final List<TwoFactorVerification> history;

  const TwoFactorVerificationHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class TwoFactorPrimaryMethodSet extends SecurityLoaded {
  const TwoFactorPrimaryMethodSet(TwoFactorAuth twoFactorAuth)
      : super(twoFactorAuth: twoFactorAuth);
}

class TwoFactorMethodsLoaded extends SecurityState {
  final List<TwoFactorMethod> methods;

  const TwoFactorMethodsLoaded(this.methods);

  @override
  List<Object?> get props => [methods];
}

class TwoFactorSetupTested extends SecurityState {
  final bool success;
  final TwoFactorMethod method;

  const TwoFactorSetupTested(this.method, {this.success = true});

  @override
  List<Object?> get props => [method, success];
}

class TwoFactorRecoveryCodesLoaded extends SecurityState {
  final List<String> recoveryCodes;

  const TwoFactorRecoveryCodesLoaded(this.recoveryCodes);

  @override
  List<Object?> get props => [recoveryCodes];
}

class TwoFactorRecoveryCodesRevoked extends SecurityState {}

class TwoFactorSecurityQuestionsLoaded extends SecurityState {
  final List<SecurityQuestion> questions;

  const TwoFactorSecurityQuestionsLoaded(this.questions);

  @override
  List<Object?> get props => [questions];
}

class TwoFactorSecurityQuestionsSet extends SecurityState {}

class SecurityQuestionAnswersVerified extends SecurityState {}

class TwoFactorMethodOrderChanged extends SecurityLoaded {
  const TwoFactorMethodOrderChanged(TwoFactorAuth twoFactorAuth)
      : super(twoFactorAuth: twoFactorAuth);
}

class TwoFactorMethodSettingsLoaded extends SecurityState {
  final TwoFactorMethod method;
  final Map<String, dynamic> settings;

  const TwoFactorMethodSettingsLoaded(this.method, this.settings);

  @override
  List<Object?> get props => [method, settings];
}

class TwoFactorMethodSettingsUpdated extends SecurityState {}

class TwoFactorBackupEmailLoaded extends SecurityState {
  final String? backupEmail;

  const TwoFactorBackupEmailLoaded(this.backupEmail);

  @override
  List<Object?> get props => [backupEmail];
}

class TwoFactorBackupEmailSet extends SecurityState {}

class TwoFactorBackupPhoneLoaded extends SecurityState {
  final String? backupPhone;

  const TwoFactorBackupPhoneLoaded(this.backupPhone);

  @override
  List<Object?> get props => [backupPhone];
}

class TwoFactorBackupPhoneSet extends SecurityState {}

// Security Alert States
class SecurityAlertCreated extends SecurityState {}

class SecurityAlertsLoaded extends SecurityState {
  final List<SecurityAlert> alerts;
  final SecurityAlertType? type;
  final SecurityAlertSeverity? severity;
  final bool unreadOnly;

  const SecurityAlertsLoaded({
    required this.alerts,
    this.type,
    this.severity,
    this.unreadOnly = false,
  });

  @override
  List<Object?> get props => [alerts, type, severity, unreadOnly];
}

class SecurityAlertLoaded extends SecurityState {
  final SecurityAlert alert;

  const SecurityAlertLoaded(this.alert);

  @override
  List<Object?> get props => [alert];
}

class SecurityAlertMarkedAsRead extends SecurityState {
  final String alertId;

  const SecurityAlertMarkedAsRead(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class AllSecurityAlertsMarkedAsRead extends SecurityState {}

class SecurityAlertDeleted extends SecurityState {
  final String alertId;

  const SecurityAlertDeleted(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class UnreadSecurityAlertsCountLoaded extends SecurityState {
  final int count;

  const UnreadSecurityAlertsCountLoaded(this.count);

  @override
  List<Object?> get props => [count];
}

// Device Management States
class TrustedDevicesLoaded extends SecurityState {
  final List<DeviceInfo> devices;

  const TrustedDevicesLoaded(this.devices);

  @override
  List<Object?> get props => [devices];
}

class CurrentDeviceInfoLoaded extends SecurityState {
  final DeviceInfo device;

  const CurrentDeviceInfoLoaded(this.device);

  @override
  List<Object?> get props => [device];
}

class TrustedDeviceAdded extends SecurityState {
  final DeviceInfo device;

  const TrustedDeviceAdded(this.device);

  @override
  List<Object?> get props => [device];
}

class TrustedDeviceRemoved extends SecurityState {
  final String deviceId;

  const TrustedDeviceRemoved(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class CurrentDeviceTrusted extends SecurityState {}

class CurrentDeviceUntrusted extends SecurityState {}

class DeviceInfoUpdated extends SecurityState {}

class DeviceTrustedStatusLoaded extends SecurityState {
  final String deviceId;
  final bool trusted;

  const DeviceTrustedStatusLoaded(this.deviceId, this.trusted);

  @override
  List<Object?> get props => [deviceId, trusted];
}

// Session Management States
class ActiveSessionsLoaded extends SecurityState {
  final List<LoginSession> sessions;

  const ActiveSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class CurrentSessionLoaded extends SecurityState {
  final LoginSession session;

  const CurrentSessionLoaded(this.session);

  @override
  List<Object?> get props => [session];
}

class SessionTerminated extends SecurityState {
  final String sessionId;

  const SessionTerminated(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class AllSessionsTerminated extends SecurityState {}

class OtherSessionsTerminated extends SecurityState {}

class SessionExtended extends SecurityState {
  final String sessionId;

  const SessionExtended(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class SessionMetadataUpdated extends SecurityState {}

// Security Settings States
class SecuritySettingsLoaded extends SecurityState {
  final SecuritySettings settings;

  const SecuritySettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SecuritySettingsUpdated extends SecurityState {
  final SecuritySettings settings;

  const SecuritySettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SecuritySettingsReset extends SecurityState {}

// Audit Log States
class AuditLogsLoaded extends SecurityState {
  final List<AuditLog> logs;
  final AuditAction? action;
  final String? resource;

  const AuditLogsLoaded({
    required this.logs,
    this.action,
    this.resource,
  });

  @override
  List<Object?> get props => [logs, action, resource];
}

class AuditLogLoaded extends SecurityState {
  final AuditLog log;

  const AuditLogLoaded(this.log);

  @override
  List<Object?> get props => [log];
}

class AuditLogCreated extends SecurityState {}

class AuditLogsByActionLoaded extends SecurityState {
  final Map<String, int> logsByAction;

  const AuditLogsByActionLoaded(this.logsByAction);

  @override
  List<Object?> get props => [logsByAction];
}

class AuditLogsByResourceLoaded extends SecurityState {
  final Map<String, int> logsByResource;

  const AuditLogsByResourceLoaded(this.logsByResource);

  @override
  List<Object?> get props => [logsByResource];
}

class AuditLogsPurged extends SecurityState {}

// Security Stats States
class SecurityStatsLoaded extends SecurityState {
  final SecurityStats stats;

  const SecurityStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class LoginAttemptsByMethodLoaded extends SecurityState {
  final Map<String, int> attemptsByMethod;

  const LoginAttemptsByMethodLoaded(this.attemptsByMethod);

  @override
  List<Object?> get props => [attemptsByMethod];
}

class FailedLoginAttemptsByReasonLoaded extends SecurityState {
  final Map<String, int> attemptsByReason;

  const FailedLoginAttemptsByReasonLoaded(this.attemptsByReason);

  @override
  List<Object?> get props => [attemptsByReason];
}

class RecentSuspiciousIPsLoaded extends SecurityState {
  final List<String> ips;

  const RecentSuspiciousIPsLoaded(this.ips);

  @override
  List<Object?> get props => [ips];
}

class RecentSuspiciousDevicesLoaded extends SecurityState {
  final List<String> devices;

  const RecentSuspiciousDevicesLoaded(this.devices);

  @override
  List<Object?> get props => [devices];
}

// Password Policy States
class PasswordPolicyLoaded extends SecurityState {
  final PasswordPolicy policy;

  const PasswordPolicyLoaded(this.policy);

  @override
  List<Object?> get props => [policy];
}

class PasswordPolicyUpdated extends SecurityState {
  final PasswordPolicy policy;

  const PasswordPolicyUpdated(this.policy);

  @override
  List<Object?> get props => [policy];
}

class PasswordStrengthValidated extends SecurityState {
  final bool valid;
  final String password;

  const PasswordStrengthValidated(this.password, {this.valid = true});

  @override
  List<Object?> get props => [password, valid];
}

class PasswordStrengthLoaded extends SecurityState {
  final int strength;
  final String password;

  const PasswordStrengthLoaded(this.password, this.strength);

  @override
  List<Object?> get props => [password, strength];
}

class PasswordBreachedCheckLoaded extends SecurityState {
  final List<String> breaches;
  final String password;

  const PasswordBreachedCheckLoaded(this.password, this.breaches);

  @override
  List<Object?> get props => [password, breaches];
}

// Rate Limiting States
class RateLimitedStatusLoaded extends SecurityState {
  final bool limited;
  final String identifier;
  final RateLimitType type;

  const RateLimitedStatusLoaded(this.identifier, this.type, {this.limited = true});

  @override
  List<Object?> get props => [identifier, type, limited];
}

class RateLimitLoaded extends SecurityState {
  final RateLimit rateLimit;
  final String identifier;
  final RateLimitType type;

  const RateLimitLoaded(this.identifier, this.type, this.rateLimit);

  @override
  List<Object?> get props => [identifier, type, rateLimit];
}

class RateLimitIncremented extends SecurityState {
  final String identifier;
  final RateLimitType type;

  const RateLimitIncremented(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class RateLimitReset extends SecurityState {
  final String identifier;
  final RateLimitType type;

  const RateLimitReset(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class AllRateLimitsCleared extends SecurityState {}

// Biometric Authentication States
class BiometricSettingsLoaded extends SecurityState {
  final BiometricSettings settings;

  const BiometricSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class BiometricSettingsUpdated extends SecurityState {
  final BiometricSettings settings;

  const BiometricSettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}

class BiometricAvailableStatusLoaded extends SecurityState {
  final bool available;

  const BiometricAvailableStatusLoaded({this.available = true});

  @override
  List<Object?> get props => [available];
}

class BiometricAuthenticated extends SecurityState {}

class BiometricAuthEnabled extends SecurityState {}

class BiometricAuthDisabled extends SecurityState {}

class BiometricDataLoaded extends SecurityState {
  final Map<String, dynamic> data;

  const BiometricDataLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

// Security Reports States
class SecurityReportCreated extends SecurityState {
  final SecurityReport report;

  const SecurityReportCreated(this.report);

  @override
  List<Object?> get props => [report];
}

class SecurityReportsLoaded extends SecurityState {
  final List<SecurityReport> reports;
  final SecurityReportType? type;
  final SecurityReportStatus? status;

  const SecurityReportsLoaded({
    required this.reports,
    this.type,
    this.status,
  });

  @override
  List<Object?> get props => [reports, type, status];
}

class SecurityReportLoaded extends SecurityState {
  final SecurityReport report;

  const SecurityReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class SecurityReportUpdated extends SecurityState {
  final SecurityReport report;

  const SecurityReportUpdated(this.report);

  @override
  List<Object?> get props => [report];
}

class SecurityReportResolved extends SecurityState {
  final String reportId;

  const SecurityReportResolved(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

class SecurityReportEscalated extends SecurityState {
  final String reportId;

  const SecurityReportEscalated(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

class SecurityReportClosed extends SecurityState {
  final String reportId;

  const SecurityReportClosed(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

// Security Configuration States
class SecurityConfigurationLoaded extends SecurityState {
  final SecurityConfiguration config;

  const SecurityConfigurationLoaded(this.config);

  @override
  List<Object?> get props => [config];
}

class SecurityConfigurationUpdated extends SecurityState {
  final SecurityConfiguration config;

  const SecurityConfigurationUpdated(this.config);

  @override
  List<Object?> get props => [config];
}

class SecurityConfigurationReset extends SecurityState {}

// Advanced Security States
class SecurityScanCompleted extends SecurityState {}

class SecurityScoreLoaded extends SecurityState {
  final Map<String, dynamic> score;

  const SecurityScoreLoaded(this.score);

  @override
  List<Object?> get props => [score];
}

class SecurityRecommendationsLoaded extends SecurityState {
  final List<String> recommendations;

  const SecurityRecommendationsLoaded(this.recommendations);

  @override
  List<Object?> get props => [recommendations];
}

class SecurityScoreUpdated extends SecurityState {}

class SuspiciousActivityChecked extends SecurityState {
  final bool suspicious;
  final String activity;

  const SuspiciousActivityChecked(this.activity, {this.suspicious = true});

  @override
  List<Object?> get props => [activity, suspicious];
}

class SuspiciousIPBlocked extends SecurityState {
  final String ipAddress;

  const SuspiciousIPBlocked(this.ipAddress);

  @override
  List<Object?> get props => [ipAddress];
}

class IPUnblocked extends SecurityState {
  final String ipAddress;

  const IPUnblocked(this.ipAddress);

  @override
  List<Object?> get props => [ipAddress];
}

class BlockedIPsLoaded extends SecurityState {
  final List<String> ips;

  const BlockedIPsLoaded(this.ips);

  @override
  List<Object?> get props => [ips];
}

class IPBlockedStatusLoaded extends SecurityState {
  final String ipAddress;
  final bool blocked;

  const IPBlockedStatusLoaded(this.ipAddress, this.blocked);

  @override
  List<Object?> get props => [ipAddress, blocked];
}

// Error State
class SecurityError extends SecurityState {
  final String message;
  final SecurityEvent? event;

  const SecurityError(this.message, {this.event});

  @override
  List<Object?> get props => [message, event];
}
