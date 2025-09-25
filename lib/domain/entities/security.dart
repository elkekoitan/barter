import 'package:equatable/equatable.dart';

enum TwoFactorMethod {
  sms('SMS'),
  email('Email'),
  authenticator('Authenticator App'),
  backupCodes('Backup Codes');

  const TwoFactorMethod(this.displayName);
  final String displayName;
}

enum SecurityAlertType {
  login('Login'),
  passwordChange('Password Change'),
  twoFactorChange('Two-Factor Authentication Change'),
  deviceChange('Device Change'),
  suspiciousActivity('Suspicious Activity'),
  accountLocked('Account Locked'),
  securityReport('Security Report');

  const SecurityAlertType(this.displayName);
  final String displayName;
}

enum SecurityAlertSeverity {
  low('Low'),
  medium('Medium'),
  high('High'),
  critical('Critical');

  const SecurityAlertSeverity(this.displayName);
  final String displayName;
}

enum AuditAction {
  login('Login'),
  logout('Logout'),
  passwordChange('Password Change'),
  twoFactorEnabled('Two-Factor Authentication Enabled'),
  twoFactorDisabled('Two-Factor Authentication Disabled'),
  deviceAdded('Device Added'),
  deviceRemoved('Device Removed'),
  sessionTerminated('Session Terminated'),
  securitySettingsChanged('Security Settings Changed'),
  auditLogViewed('Audit Log Viewed'),
  securityReportCreated('Security Report Created'),
  securityReportResolved('Security Report Resolved');

  const AuditAction(this.displayName);
  final String displayName;
}

enum RateLimitType {
  loginAttempts('Login Attempts'),
  passwordReset('Password Reset'),
  twoFactorCodes('Two-Factor Authentication Codes'),
  apiCalls('API Calls'),
  fileUploads('File Uploads');

  const RateLimitType(this.displayName);
  final String displayName;
}

enum SecurityReportType {
  vulnerability('Vulnerability'),
  suspiciousActivity('Suspicious Activity'),
  accountCompromise('Account Compromise'),
  policyViolation('Policy Violation'),
  other('Other');

  const SecurityReportType(this.displayName);
  final String displayName;
}

enum SecurityReportStatus {
  open('Open'),
  investigating('Investigating'),
  resolved('Resolved'),
  closed('Closed'),
  escalated('Escalated');

  const SecurityReportStatus(this.displayName);
  final String displayName;
}

class TwoFactorAuth extends Equatable {
  final bool enabled;
  final List<TwoFactorMethod> methods;
  final TwoFactorMethod? primaryMethod;
  final bool backupCodesEnabled;
  final int backupCodesRemaining;
  final bool recoveryOptionsEnabled;
  final List<SecurityQuestion> securityQuestions;
  final String? backupEmail;
  final String? backupPhone;
  final bool temporarilyDisabled;
  final DateTime? temporaryDisableUntil;
  final String? temporaryDisableReason;
  final Map<String, dynamic> methodSettings;

  const TwoFactorAuth({
    this.enabled = false,
    this.methods = const [],
    this.primaryMethod,
    this.backupCodesEnabled = false,
    this.backupCodesRemaining = 0,
    this.recoveryOptionsEnabled = false,
    this.securityQuestions = const [],
    this.backupEmail,
    this.backupPhone,
    this.temporarilyDisabled = false,
    this.temporaryDisableUntil,
    this.temporaryDisableReason,
    this.methodSettings = const {},
  });

  TwoFactorAuth copyWith({
    bool? enabled,
    List<TwoFactorMethod>? methods,
    TwoFactorMethod? primaryMethod,
    bool? backupCodesEnabled,
    int? backupCodesRemaining,
    bool? recoveryOptionsEnabled,
    List<SecurityQuestion>? securityQuestions,
    String? backupEmail,
    String? backupPhone,
    bool? temporarilyDisabled,
    DateTime? temporaryDisableUntil,
    String? temporaryDisableReason,
    Map<String, dynamic>? methodSettings,
  }) {
    return TwoFactorAuth(
      enabled: enabled ?? this.enabled,
      methods: methods ?? this.methods,
      primaryMethod: primaryMethod ?? this.primaryMethod,
      backupCodesEnabled: backupCodesEnabled ?? this.backupCodesEnabled,
      backupCodesRemaining: backupCodesRemaining ?? this.backupCodesRemaining,
      recoveryOptionsEnabled: recoveryOptionsEnabled ?? this.recoveryOptionsEnabled,
      securityQuestions: securityQuestions ?? this.securityQuestions,
      backupEmail: backupEmail ?? this.backupEmail,
      backupPhone: backupPhone ?? this.backupPhone,
      temporarilyDisabled: temporarilyDisabled ?? this.temporarilyDisabled,
      temporaryDisableUntil: temporaryDisableUntil ?? this.temporaryDisableUntil,
      temporaryDisableReason: temporaryDisableReason ?? this.temporaryDisableReason,
      methodSettings: methodSettings ?? this.methodSettings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'methods': methods.map((e) => e.toString()).toList(),
      'primaryMethod': primaryMethod?.toString(),
      'backupCodesEnabled': backupCodesEnabled,
      'backupCodesRemaining': backupCodesRemaining,
      'recoveryOptionsEnabled': recoveryOptionsEnabled,
      'securityQuestions': securityQuestions.map((q) => q.toJson()).toList(),
      'backupEmail': backupEmail,
      'backupPhone': backupPhone,
      'temporarilyDisabled': temporarilyDisabled,
      'temporaryDisableUntil': temporaryDisableUntil?.toIso8601String(),
      'temporaryDisableReason': temporaryDisableReason,
      'methodSettings': methodSettings,
    };
  }

  factory TwoFactorAuth.fromJson(Map<String, dynamic> json) {
    return TwoFactorAuth(
      enabled: json['enabled'] ?? false,
      methods: (json['methods'] as List?)?.map((e) => TwoFactorMethod.values.firstWhere((m) => m.toString() == e)).toList() ?? [],
      primaryMethod: json['primaryMethod'] != null ? TwoFactorMethod.values.firstWhere((m) => m.toString() == json['primaryMethod']) : null,
      backupCodesEnabled: json['backupCodesEnabled'] ?? false,
      backupCodesRemaining: json['backupCodesRemaining'] ?? 0,
      recoveryOptionsEnabled: json['recoveryOptionsEnabled'] ?? false,
      securityQuestions: (json['securityQuestions'] as List?)?.map((q) => SecurityQuestion.fromJson(q)).toList() ?? [],
      backupEmail: json['backupEmail'],
      backupPhone: json['backupPhone'],
      temporarilyDisabled: json['temporarilyDisabled'] ?? false,
      temporaryDisableUntil: json['temporaryDisableUntil'] != null ? DateTime.parse(json['temporaryDisableUntil']) : null,
      temporaryDisableReason: json['temporaryDisableReason'],
      methodSettings: json['methodSettings'] ?? {},
    );
  }

  bool isMethodEnabled(TwoFactorMethod method) {
    return methods.contains(method);
  }

  bool canUseMethod(TwoFactorMethod method) {
    return enabled && isMethodEnabled(method) && !temporarilyDisabled;
  }

  @override
  List<Object?> get props => [
        enabled,
        methods,
        primaryMethod,
        backupCodesEnabled,
        backupCodesRemaining,
        recoveryOptionsEnabled,
        securityQuestions,
        backupEmail,
        backupPhone,
        temporarilyDisabled,
        temporaryDisableUntil,
        temporaryDisableReason,
        methodSettings,
      ];
}

class SecurityQuestion extends Equatable {
  final String id;
  final String question;
  final String answer;
  final bool isActive;

  const SecurityQuestion({
    required this.id,
    required this.question,
    required this.answer,
    this.isActive = true,
  });

  SecurityQuestion copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isActive,
  }) {
    return SecurityQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'isActive': isActive,
    };
  }

  factory SecurityQuestion.fromJson(Map<String, dynamic> json) {
    return SecurityQuestion(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  List<Object?> get props => [id, question, answer, isActive];
}

class TwoFactorVerification extends Equatable {
  final String id;
  final TwoFactorMethod method;
  final String identifier;
  final bool successful;
  final String ipAddress;
  final String userAgent;
  final DateTime timestamp;
  final String? location;
  final Map<String, dynamic> metadata;

  const TwoFactorVerification({
    required this.id,
    required this.method,
    required this.identifier,
    required this.successful,
    required this.ipAddress,
    required this.userAgent,
    required this.timestamp,
    this.location,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method.toString(),
      'identifier': identifier,
      'successful': successful,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'metadata': metadata,
    };
  }

  factory TwoFactorVerification.fromJson(Map<String, dynamic> json) {
    return TwoFactorVerification(
      id: json['id'],
      method: TwoFactorMethod.values.firstWhere((m) => m.toString() == json['method']),
      identifier: json['identifier'],
      successful: json['successful'],
      ipAddress: json['ipAddress'],
      userAgent: json['userAgent'],
      timestamp: DateTime.parse(json['timestamp']),
      location: json['location'],
      metadata: json['metadata'] ?? {},
    );
  }

  @override
  List<Object?> get props => [id, method, identifier, successful, ipAddress, userAgent, timestamp, location, metadata];
}

class SecurityAlert extends Equatable {
  final String id;
  final SecurityAlertType type;
  final SecurityAlertSeverity severity;
  final String title;
  final String message;
  final bool read;
  final DateTime timestamp;
  final String? userId;
  final String? ipAddress;
  final String? userAgent;
  final String? deviceId;
  final String? location;
  final Map<String, dynamic> data;
  final List<String> actions;

  const SecurityAlert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    this.read = false,
    required this.timestamp,
    this.userId,
    this.ipAddress,
    this.userAgent,
    this.deviceId,
    this.location,
    this.data = const {},
    this.actions = const [],
  });

  SecurityAlert copyWith({
    String? id,
    SecurityAlertType? type,
    SecurityAlertSeverity? severity,
    String? title,
    String? message,
    bool? read,
    DateTime? timestamp,
    String? userId,
    String? ipAddress,
    String? userAgent,
    String? deviceId,
    String? location,
    Map<String, dynamic>? data,
    List<String>? actions,
  }) {
    return SecurityAlert(
      id: id ?? this.id,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      deviceId: deviceId ?? this.deviceId,
      location: location ?? this.location,
      data: data ?? this.data,
      actions: actions ?? this.actions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'severity': severity.toString(),
      'title': title,
      'message': message,
      'read': read,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'deviceId': deviceId,
      'location': location,
      'data': data,
      'actions': actions,
    };
  }

  factory SecurityAlert.fromJson(Map<String, dynamic> json) {
    return SecurityAlert(
      id: json['id'],
      type: SecurityAlertType.values.firstWhere((t) => t.toString() == json['type']),
      severity: SecurityAlertSeverity.values.firstWhere((s) => s.toString() == json['severity']),
      title: json['title'],
      message: json['message'],
      read: json['read'] ?? false,
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['userId'],
      ipAddress: json['ipAddress'],
      userAgent: json['userAgent'],
      deviceId: json['deviceId'],
      location: json['location'],
      data: json['data'] ?? {},
      actions: List<String>.from(json['actions'] ?? []),
    );
  }

  @override
  List<Object?> get props => [id, type, severity, title, message, read, timestamp, userId, ipAddress, userAgent, deviceId, location, data, actions];
}

class DeviceInfo extends Equatable {
  final String id;
  final String name;
  final String type;
  final String os;
  final String osVersion;
  final String browser;
  final String browserVersion;
  final String ipAddress;
  final String? location;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final bool trusted;
  final Map<String, dynamic> metadata;

  const DeviceInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.os,
    required this.osVersion,
    required this.browser,
    required this.browserVersion,
    required this.ipAddress,
    this.location,
    required this.firstSeen,
    required this.lastSeen,
    this.trusted = false,
    this.metadata = const {},
  });

  DeviceInfo copyWith({
    String? id,
    String? name,
    String? type,
    String? os,
    String? osVersion,
    String? browser,
    String? browserVersion,
    String? ipAddress,
    String? location,
    DateTime? firstSeen,
    DateTime? lastSeen,
    bool? trusted,
    Map<String, dynamic>? metadata,
  }) {
    return DeviceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      os: os ?? this.os,
      osVersion: osVersion ?? this.osVersion,
      browser: browser ?? this.browser,
      browserVersion: browserVersion ?? this.browserVersion,
      ipAddress: ipAddress ?? this.ipAddress,
      location: location ?? this.location,
      firstSeen: firstSeen ?? this.firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      trusted: trusted ?? this.trusted,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'os': os,
      'osVersion': osVersion,
      'browser': browser,
      'browserVersion': browserVersion,
      'ipAddress': ipAddress,
      'location': location,
      'firstSeen': firstSeen.toIso8601String(),
      'lastSeen': lastSeen.toIso8601String(),
      'trusted': trusted,
      'metadata': metadata,
    };
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      os: json['os'],
      osVersion: json['osVersion'],
      browser: json['browser'],
      browserVersion: json['browserVersion'],
      ipAddress: json['ipAddress'],
      location: json['location'],
      firstSeen: DateTime.parse(json['firstSeen']),
      lastSeen: DateTime.parse(json['lastSeen']),
      trusted: json['trusted'] ?? false,
      metadata: json['metadata'] ?? {},
    );
  }

  @override
  List<Object?> get props => [id, name, type, os, osVersion, browser, browserVersion, ipAddress, location, firstSeen, lastSeen, trusted, metadata];
}

class LoginSession extends Equatable {
  final String id;
  final String userId;
  final String deviceId;
  final String ipAddress;
  final String userAgent;
  final DateTime loginTime;
  final DateTime? lastActivity;
  final DateTime? expiresAt;
  final bool active;
  final String? location;
  final Map<String, dynamic> metadata;

  const LoginSession({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.ipAddress,
    required this.userAgent,
    required this.loginTime,
    this.lastActivity,
    this.expiresAt,
    this.active = true,
    this.location,
    this.metadata = const {},
  });

  LoginSession copyWith({
    String? id,
    String? userId,
    String? deviceId,
    String? ipAddress,
    String? userAgent,
    DateTime? loginTime,
    DateTime? lastActivity,
    DateTime? expiresAt,
    bool? active,
    String? location,
    Map<String, dynamic>? metadata,
  }) {
    return LoginSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      loginTime: loginTime ?? this.loginTime,
      lastActivity: lastActivity ?? this.lastActivity,
      expiresAt: expiresAt ?? this.expiresAt,
      active: active ?? this.active,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'deviceId': deviceId,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'loginTime': loginTime.toIso8601String(),
      'lastActivity': lastActivity?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'active': active,
      'location': location,
      'metadata': metadata,
    };
  }

  factory LoginSession.fromJson(Map<String, dynamic> json) {
    return LoginSession(
      id: json['id'],
      userId: json['userId'],
      deviceId: json['deviceId'],
      ipAddress: json['ipAddress'],
      userAgent: json['userAgent'],
      loginTime: DateTime.parse(json['loginTime']),
      lastActivity: json['lastActivity'] != null ? DateTime.parse(json['lastActivity']) : null,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      active: json['active'] ?? true,
      location: json['location'],
      metadata: json['metadata'] ?? {},
    );
  }

  bool isExpired() {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  List<Object?> get props => [id, userId, deviceId, ipAddress, userAgent, loginTime, lastActivity, expiresAt, active, location, metadata];
}

class SecuritySettings extends Equatable {
  final bool enableTwoFactorAuth;
  final bool requirePasswordChange;
  final int passwordChangeIntervalDays;
  final bool enableSessionTimeout;
  final int sessionTimeoutMinutes;
  final bool enableDeviceTracking;
  final int maxDevicesPerUser;
  final bool enableLoginNotifications;
  final bool enableSuspiciousActivityAlerts;
  final bool enableIPBlocking;
  final List<String> allowedIPs;
  final List<String> blockedIPs;
  final bool enableAuditLogging;
  final int auditLogRetentionDays;
  final bool enableBiometricAuth;
  final bool enableLocationServices;
  final bool enableSecurityReports;
  final Map<String, dynamic> customSettings;

  const SecuritySettings({
    this.enableTwoFactorAuth = false,
    this.requirePasswordChange = false,
    this.passwordChangeIntervalDays = 90,
    this.enableSessionTimeout = true,
    this.sessionTimeoutMinutes = 60,
    this.enableDeviceTracking = true,
    this.maxDevicesPerUser = 5,
    this.enableLoginNotifications = true,
    this.enableSuspiciousActivityAlerts = true,
    this.enableIPBlocking = false,
    this.allowedIPs = const [],
    this.blockedIPs = const [],
    this.enableAuditLogging = true,
    this.auditLogRetentionDays = 365,
    this.enableBiometricAuth = false,
    this.enableLocationServices = false,
    this.enableSecurityReports = true,
    this.customSettings = const {},
  });

  SecuritySettings copyWith({
    bool? enableTwoFactorAuth,
    bool? requirePasswordChange,
    int? passwordChangeIntervalDays,
    bool? enableSessionTimeout,
    int? sessionTimeoutMinutes,
    bool? enableDeviceTracking,
    int? maxDevicesPerUser,
    bool? enableLoginNotifications,
    bool? enableSuspiciousActivityAlerts,
    bool? enableIPBlocking,
    List<String>? allowedIPs,
    List<String>? blockedIPs,
    bool? enableAuditLogging,
    int? auditLogRetentionDays,
    bool? enableBiometricAuth,
    bool? enableLocationServices,
    bool? enableSecurityReports,
    Map<String, dynamic>? customSettings,
  }) {
    return SecuritySettings(
      enableTwoFactorAuth: enableTwoFactorAuth ?? this.enableTwoFactorAuth,
      requirePasswordChange: requirePasswordChange ?? this.requirePasswordChange,
      passwordChangeIntervalDays: passwordChangeIntervalDays ?? this.passwordChangeIntervalDays,
      enableSessionTimeout: enableSessionTimeout ?? this.enableSessionTimeout,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      enableDeviceTracking: enableDeviceTracking ?? this.enableDeviceTracking,
      maxDevicesPerUser: maxDevicesPerUser ?? this.maxDevicesPerUser,
      enableLoginNotifications: enableLoginNotifications ?? this.enableLoginNotifications,
      enableSuspiciousActivityAlerts: enableSuspiciousActivityAlerts ?? this.enableSuspiciousActivityAlerts,
      enableIPBlocking: enableIPBlocking ?? this.enableIPBlocking,
      allowedIPs: allowedIPs ?? this.allowedIPs,
      blockedIPs: blockedIPs ?? this.blockedIPs,
      enableAuditLogging: enableAuditLogging ?? this.enableAuditLogging,
      auditLogRetentionDays: auditLogRetentionDays ?? this.auditLogRetentionDays,
      enableBiometricAuth: enableBiometricAuth ?? this.enableBiometricAuth,
      enableLocationServices: enableLocationServices ?? this.enableLocationServices,
      enableSecurityReports: enableSecurityReports ?? this.enableSecurityReports,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableTwoFactorAuth': enableTwoFactorAuth,
      'requirePasswordChange': requirePasswordChange,
      'passwordChangeIntervalDays': passwordChangeIntervalDays,
      'enableSessionTimeout': enableSessionTimeout,
      'sessionTimeoutMinutes': sessionTimeoutMinutes,
      'enableDeviceTracking': enableDeviceTracking,
      'maxDevicesPerUser': maxDevicesPerUser,
      'enableLoginNotifications': enableLoginNotifications,
      'enableSuspiciousActivityAlerts': enableSuspiciousActivityAlerts,
      'enableIPBlocking': enableIPBlocking,
      'allowedIPs': allowedIPs,
      'blockedIPs': blockedIPs,
      'enableAuditLogging': enableAuditLogging,
      'auditLogRetentionDays': auditLogRetentionDays,
      'enableBiometricAuth': enableBiometricAuth,
      'enableLocationServices': enableLocationServices,
      'enableSecurityReports': enableSecurityReports,
      'customSettings': customSettings,
    };
  }

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      enableTwoFactorAuth: json['enableTwoFactorAuth'] ?? false,
      requirePasswordChange: json['requirePasswordChange'] ?? false,
      passwordChangeIntervalDays: json['passwordChangeIntervalDays'] ?? 90,
      enableSessionTimeout: json['enableSessionTimeout'] ?? true,
      sessionTimeoutMinutes: json['sessionTimeoutMinutes'] ?? 60,
      enableDeviceTracking: json['enableDeviceTracking'] ?? true,
      maxDevicesPerUser: json['maxDevicesPerUser'] ?? 5,
      enableLoginNotifications: json['enableLoginNotifications'] ?? true,
      enableSuspiciousActivityAlerts: json['enableSuspiciousActivityAlerts'] ?? true,
      enableIPBlocking: json['enableIPBlocking'] ?? false,
      allowedIPs: List<String>.from(json['allowedIPs'] ?? []),
      blockedIPs: List<String>.from(json['blockedIPs'] ?? []),
      enableAuditLogging: json['enableAuditLogging'] ?? true,
      auditLogRetentionDays: json['auditLogRetentionDays'] ?? 365,
      enableBiometricAuth: json['enableBiometricAuth'] ?? false,
      enableLocationServices: json['enableLocationServices'] ?? false,
      enableSecurityReports: json['enableSecurityReports'] ?? true,
      customSettings: json['customSettings'] ?? {},
    );
  }

  @override
  List<Object?> get props => [
        enableTwoFactorAuth,
        requirePasswordChange,
        passwordChangeIntervalDays,
        enableSessionTimeout,
        sessionTimeoutMinutes,
        enableDeviceTracking,
        maxDevicesPerUser,
        enableLoginNotifications,
        enableSuspiciousActivityAlerts,
        enableIPBlocking,
        allowedIPs,
        blockedIPs,
        enableAuditLogging,
        auditLogRetentionDays,
        enableBiometricAuth,
        enableLocationServices,
        enableSecurityReports,
        customSettings,
      ];
}

class AuditLog extends Equatable {
  final String id;
  final AuditAction action;
  final String userId;
  final String resource;
  final String resourceId;
  final String description;
  final String ipAddress;
  final String userAgent;
  final String? deviceId;
  final String? location;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final bool success;
  final String? errorMessage;

  const AuditLog({
    required this.id,
    required this.action,
    required this.userId,
    required this.resource,
    required this.resourceId,
    required this.description,
    required this.ipAddress,
    required this.userAgent,
    this.deviceId,
    this.location,
    required this.timestamp,
    this.metadata = const {},
    this.success = true,
    this.errorMessage,
  });

  AuditLog copyWith({
    String? id,
    AuditAction? action,
    String? userId,
    String? resource,
    String? resourceId,
    String? description,
    String? ipAddress,
    String? userAgent,
    String? deviceId,
    String? location,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    bool? success,
    String? errorMessage,
  }) {
    return AuditLog(
      id: id ?? this.id,
      action: action ?? this.action,
      userId: userId ?? this.userId,
      resource: resource ?? this.resource,
      resourceId: resourceId ?? this.resourceId,
      description: description ?? this.description,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      deviceId: deviceId ?? this.deviceId,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action.toString(),
      'userId': userId,
      'resource': resource,
      'resourceId': resourceId,
      'description': description,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'deviceId': deviceId,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'success': success,
      'errorMessage': errorMessage,
    };
  }

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'],
      action: AuditAction.values.firstWhere((a) => a.toString() == json['action']),
      userId: json['userId'],
      resource: json['resource'],
      resourceId: json['resourceId'],
      description: json['description'],
      ipAddress: json['ipAddress'],
      userAgent: json['userAgent'],
      deviceId: json['deviceId'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'] ?? {},
      success: json['success'] ?? true,
      errorMessage: json['errorMessage'],
    );
  }

  @override
  List<Object?> get props => [id, action, userId, resource, resourceId, description, ipAddress, userAgent, deviceId, location, timestamp, metadata, success, errorMessage];
}

class SecurityStats extends Equatable {
  final int totalLogins;
  final int failedLogins;
  final int successfulLogins;
  final int twoFactorEnabledUsers;
  final int totalDevices;
  final int blockedDevices;
  final int activeSessions;
  final int securityAlerts;
  final int unresolvedReports;
  final Map<String, int> loginAttemptsByMethod;
  final Map<String, int> failedLoginAttemptsByReason;
  final List<String> topSuspiciousIPs;
  final List<String> topSuspiciousDevices;
  final DateTime lastUpdated;

  const SecurityStats({
    this.totalLogins = 0,
    this.failedLogins = 0,
    this.successfulLogins = 0,
    this.twoFactorEnabledUsers = 0,
    this.totalDevices = 0,
    this.blockedDevices = 0,
    this.activeSessions = 0,
    this.securityAlerts = 0,
    this.unresolvedReports = 0,
    this.loginAttemptsByMethod = const {},
    this.failedLoginAttemptsByReason = const {},
    this.topSuspiciousIPs = const [],
    this.topSuspiciousDevices = const [],
    required this.lastUpdated,
  });

  SecurityStats copyWith({
    int? totalLogins,
    int? failedLogins,
    int? successfulLogins,
    int? twoFactorEnabledUsers,
    int? totalDevices,
    int? blockedDevices,
    int? activeSessions,
    int? securityAlerts,
    int? unresolvedReports,
    Map<String, int>? loginAttemptsByMethod,
    Map<String, int>? failedLoginAttemptsByReason,
    List<String>? topSuspiciousIPs,
    List<String>? topSuspiciousDevices,
    DateTime? lastUpdated,
  }) {
    return SecurityStats(
      totalLogins: totalLogins ?? this.totalLogins,
      failedLogins: failedLogins ?? this.failedLogins,
      successfulLogins: successfulLogins ?? this.successfulLogins,
      twoFactorEnabledUsers: twoFactorEnabledUsers ?? this.twoFactorEnabledUsers,
      totalDevices: totalDevices ?? this.totalDevices,
      blockedDevices: blockedDevices ?? this.blockedDevices,
      activeSessions: activeSessions ?? this.activeSessions,
      securityAlerts: securityAlerts ?? this.securityAlerts,
      unresolvedReports: unresolvedReports ?? this.unresolvedReports,
      loginAttemptsByMethod: loginAttemptsByMethod ?? this.loginAttemptsByMethod,
      failedLoginAttemptsByReason: failedLoginAttemptsByReason ?? this.failedLoginAttemptsByReason,
      topSuspiciousIPs: topSuspiciousIPs ?? this.topSuspiciousIPs,
      topSuspiciousDevices: topSuspiciousDevices ?? this.topSuspiciousDevices,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLogins': totalLogins,
      'failedLogins': failedLogins,
      'successfulLogins': successfulLogins,
      'twoFactorEnabledUsers': twoFactorEnabledUsers,
      'totalDevices': totalDevices,
      'blockedDevices': blockedDevices,
      'activeSessions': activeSessions,
      'securityAlerts': securityAlerts,
      'unresolvedReports': unresolvedReports,
      'loginAttemptsByMethod': loginAttemptsByMethod,
      'failedLoginAttemptsByReason': failedLoginAttemptsByReason,
      'topSuspiciousIPs': topSuspiciousIPs,
      'topSuspiciousDevices': topSuspiciousDevices,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory SecurityStats.fromJson(Map<String, dynamic> json) {
    return SecurityStats(
      totalLogins: json['totalLogins'] ?? 0,
      failedLogins: json['failedLogins'] ?? 0,
      successfulLogins: json['successfulLogins'] ?? 0,
      twoFactorEnabledUsers: json['twoFactorEnabledUsers'] ?? 0,
      totalDevices: json['totalDevices'] ?? 0,
      blockedDevices: json['blockedDevices'] ?? 0,
      activeSessions: json['activeSessions'] ?? 0,
      securityAlerts: json['securityAlerts'] ?? 0,
      unresolvedReports: json['unresolvedReports'] ?? 0,
      loginAttemptsByMethod: Map<String, int>.from(json['loginAttemptsByMethod'] ?? {}),
      failedLoginAttemptsByReason: Map<String, int>.from(json['failedLoginAttemptsByReason'] ?? {}),
      topSuspiciousIPs: List<String>.from(json['topSuspiciousIPs'] ?? []),
      topSuspiciousDevices: List<String>.from(json['topSuspiciousDevices'] ?? []),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  @override
  List<Object?> get props => [
        totalLogins,
        failedLogins,
        successfulLogins,
        twoFactorEnabledUsers,
        totalDevices,
        blockedDevices,
        activeSessions,
        securityAlerts,
        unresolvedReports,
        loginAttemptsByMethod,
        failedLoginAttemptsByReason,
        topSuspiciousIPs,
        topSuspiciousDevices,
        lastUpdated,
      ];
}

class PasswordPolicy extends Equatable {
  final int minLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumbers;
  final bool requireSpecialCharacters;
  final int maxAgeDays;
  final bool preventCommonPasswords;
  final bool preventPasswordReuse;
  final int historyCount;
  final bool requireComplexityCheck;
  final Map<String, dynamic> customRules;

  const PasswordPolicy({
    this.minLength = 8,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireNumbers = true,
    this.requireSpecialCharacters = true,
    this.maxAgeDays = 90,
    this.preventCommonPasswords = true,
    this.preventPasswordReuse = true,
    this.historyCount = 5,
    this.requireComplexityCheck = true,
    this.customRules = const {},
  });

  PasswordPolicy copyWith({
    int? minLength,
    bool? requireUppercase,
    bool? requireLowercase,
    bool? requireNumbers,
    bool? requireSpecialCharacters,
    int? maxAgeDays,
    bool? preventCommonPasswords,
    bool? preventPasswordReuse,
    int? historyCount,
    bool? requireComplexityCheck,
    Map<String, dynamic>? customRules,
  }) {
    return PasswordPolicy(
      minLength: minLength ?? this.minLength,
      requireUppercase: requireUppercase ?? this.requireUppercase,
      requireLowercase: requireLowercase ?? this.requireLowercase,
      requireNumbers: requireNumbers ?? this.requireNumbers,
      requireSpecialCharacters: requireSpecialCharacters ?? this.requireSpecialCharacters,
      maxAgeDays: maxAgeDays ?? this.maxAgeDays,
      preventCommonPasswords: preventCommonPasswords ?? this.preventCommonPasswords,
      preventPasswordReuse: preventPasswordReuse ?? this.preventPasswordReuse,
      historyCount: historyCount ?? this.historyCount,
      requireComplexityCheck: requireComplexityCheck ?? this.requireComplexityCheck,
      customRules: customRules ?? this.customRules,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minLength': minLength,
      'requireUppercase': requireUppercase,
      'requireLowercase': requireLowercase,
      'requireNumbers': requireNumbers,
      'requireSpecialCharacters': requireSpecialCharacters,
      'maxAgeDays': maxAgeDays,
      'preventCommonPasswords': preventCommonPasswords,
      'preventPasswordReuse': preventPasswordReuse,
      'historyCount': historyCount,
      'requireComplexityCheck': requireComplexityCheck,
      'customRules': customRules,
    };
  }

  factory PasswordPolicy.fromJson(Map<String, dynamic> json) {
    return PasswordPolicy(
      minLength: json['minLength'] ?? 8,
      requireUppercase: json['requireUppercase'] ?? true,
      requireLowercase: json['requireLowercase'] ?? true,
      requireNumbers: json['requireNumbers'] ?? true,
      requireSpecialCharacters: json['requireSpecialCharacters'] ?? true,
      maxAgeDays: json['maxAgeDays'] ?? 90,
      preventCommonPasswords: json['preventCommonPasswords'] ?? true,
      preventPasswordReuse: json['preventPasswordReuse'] ?? true,
      historyCount: json['historyCount'] ?? 5,
      requireComplexityCheck: json['requireComplexityCheck'] ?? true,
      customRules: json['customRules'] ?? {},
    );
  }

  bool validatePassword(String password) {
    if (password.length < minLength) return false;
    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(password)) return false;
    if (requireNumbers && !RegExp(r'[0-9]').hasMatch(password)) return false;
    if (requireSpecialCharacters && !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return false;
    return true;
  }

  @override
  List<Object?> get props => [
        minLength,
        requireUppercase,
        requireLowercase,
        requireNumbers,
        requireSpecialCharacters,
        maxAgeDays,
        preventCommonPasswords,
        preventPasswordReuse,
        historyCount,
        requireComplexityCheck,
        customRules,
      ];
}

class RateLimit extends Equatable {
  final String identifier;
  final RateLimitType type;
  final int limit;
  final int remaining;
  final int resetInSeconds;
  final DateTime resetTime;
  final int attempts;

  const RateLimit({
    required this.identifier,
    required this.type,
    required this.limit,
    required this.remaining,
    required this.resetInSeconds,
    required this.resetTime,
    required this.attempts,
  });

  RateLimit copyWith({
    String? identifier,
    RateLimitType? type,
    int? limit,
    int? remaining,
    int? resetInSeconds,
    DateTime? resetTime,
    int? attempts,
  }) {
    return RateLimit(
      identifier: identifier ?? this.identifier,
      type: type ?? this.type,
      limit: limit ?? this.limit,
      remaining: remaining ?? this.remaining,
      resetInSeconds: resetInSeconds ?? this.resetInSeconds,
      resetTime: resetTime ?? this.resetTime,
      attempts: attempts ?? this.attempts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'type': type.toString(),
      'limit': limit,
      'remaining': remaining,
      'resetInSeconds': resetInSeconds,
      'resetTime': resetTime.toIso8601String(),
      'attempts': attempts,
    };
  }

  factory RateLimit.fromJson(Map<String, dynamic> json) {
    return RateLimit(
      identifier: json['identifier'],
      type: RateLimitType.values.firstWhere((t) => t.toString() == json['type']),
      limit: json['limit'],
      remaining: json['remaining'],
      resetInSeconds: json['resetInSeconds'],
      resetTime: DateTime.parse(json['resetTime']),
      attempts: json['attempts'],
    );
  }

  bool isExceeded() {
    return remaining <= 0;
  }

  bool isNearLimit() {
    return remaining <= limit * 0.2;
  }

  @override
  List<Object?> get props => [identifier, type, limit, remaining, resetInSeconds, resetTime, attempts];
}

class BiometricSettings extends Equatable {
  final bool enabled;
  final bool available;
  final List<String> supportedTypes;
  final bool requireAuthentication;
  final int maxAttempts;
  final bool allowFallback;
  final int lockoutDurationMinutes;
  final Map<String, dynamic> customSettings;

  const BiometricSettings({
    this.enabled = false,
    this.available = false,
    this.supportedTypes = const [],
    this.requireAuthentication = true,
    this.maxAttempts = 3,
    this.allowFallback = true,
    this.lockoutDurationMinutes = 5,
    this.customSettings = const {},
  });

  BiometricSettings copyWith({
    bool? enabled,
    bool? available,
    List<String>? supportedTypes,
    bool? requireAuthentication,
    int? maxAttempts,
    bool? allowFallback,
    int? lockoutDurationMinutes,
    Map<String, dynamic>? customSettings,
  }) {
    return BiometricSettings(
      enabled: enabled ?? this.enabled,
      available: available ?? this.available,
      supportedTypes: supportedTypes ?? this.supportedTypes,
      requireAuthentication: requireAuthentication ?? this.requireAuthentication,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      allowFallback: allowFallback ?? this.allowFallback,
      lockoutDurationMinutes: lockoutDurationMinutes ?? this.lockoutDurationMinutes,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'available': available,
      'supportedTypes': supportedTypes,
      'requireAuthentication': requireAuthentication,
      'maxAttempts': maxAttempts,
      'allowFallback': allowFallback,
      'lockoutDurationMinutes': lockoutDurationMinutes,
      'customSettings': customSettings,
    };
  }

  factory BiometricSettings.fromJson(Map<String, dynamic> json) {
    return BiometricSettings(
      enabled: json['enabled'] ?? false,
      available: json['available'] ?? false,
      supportedTypes: List<String>.from(json['supportedTypes'] ?? []),
      requireAuthentication: json['requireAuthentication'] ?? true,
      maxAttempts: json['maxAttempts'] ?? 3,
      allowFallback: json['allowFallback'] ?? true,
      lockoutDurationMinutes: json['lockoutDurationMinutes'] ?? 5,
      customSettings: json['customSettings'] ?? {},
    );
  }

  @override
  List<Object?> get props => [
        enabled,
        available,
        supportedTypes,
        requireAuthentication,
        maxAttempts,
        allowFallback,
        lockoutDurationMinutes,
        customSettings,
      ];
}

class SecurityReport extends Equatable {
  final String id;
  final SecurityReportType type;
  final SecurityReportStatus status;
  final String title;
  final String description;
  final String reportedBy;
  final String? assignedTo;
  final int priority;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? resolution;
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final Map<String, dynamic> evidence;
  final Map<String, dynamic> metadata;

  const SecurityReport({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.description,
    required this.reportedBy,
    this.assignedTo,
    this.priority = 3,
    required this.createdAt,
    this.updatedAt,
    this.resolution,
    this.resolvedBy,
    this.resolvedAt,
    this.evidence = const {},
    this.metadata = const {},
  });

  SecurityReport copyWith({
    String? id,
    SecurityReportType? type,
    SecurityReportStatus? status,
    String? title,
    String? description,
    String? reportedBy,
    String? assignedTo,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? resolution,
    String? resolvedBy,
    DateTime? resolvedAt,
    Map<String, dynamic>? evidence,
    Map<String, dynamic>? metadata,
  }) {
    return SecurityReport(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      reportedBy: reportedBy ?? this.reportedBy,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolution: resolution ?? this.resolution,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      evidence: evidence ?? this.evidence,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'status': status.toString(),
      'title': title,
      'description': description,
      'reportedBy': reportedBy,
      'assignedTo': assignedTo,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'resolution': resolution,
      'resolvedBy': resolvedBy,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'evidence': evidence,
      'metadata': metadata,
    };
  }

  factory SecurityReport.fromJson(Map<String, dynamic> json) {
    return SecurityReport(
      id: json['id'],
      type: SecurityReportType.values.firstWhere((t) => t.toString() == json['type']),
      status: SecurityReportStatus.values.firstWhere((s) => s.toString() == json['status']),
      title: json['title'],
      description: json['description'],
      reportedBy: json['reportedBy'],
      assignedTo: json['assignedTo'],
      priority: json['priority'] ?? 3,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      resolution: json['resolution'],
      resolvedBy: json['resolvedBy'],
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
      evidence: json['evidence'] ?? {},
      metadata: json['metadata'] ?? {},
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        status,
        title,
        description,
        reportedBy,
        assignedTo,
        priority,
        createdAt,
        updatedAt,
        resolution,
        resolvedBy,
        resolvedAt,
        evidence,
        metadata,
      ];
}

class SecurityConfiguration extends Equatable {
  final bool enableAdvancedSecurity;
  final bool enableRateLimiting;
  final bool enableIPBlocking;
  final bool enableDeviceFingerprinting;
  final bool enableBehavioralAnalysis;
  final bool enableAnomalyDetection;
  final bool enableAutomatedResponse;
  final int securityScoreThreshold;
  final List<String> monitoredActivities;
  final Map<String, dynamic> riskFactors;
  final Map<String, dynamic> responseRules;
  final Map<String, dynamic> customConfiguration;

  const SecurityConfiguration({
    this.enableAdvancedSecurity = true,
    this.enableRateLimiting = true,
    this.enableIPBlocking = false,
    this.enableDeviceFingerprinting = true,
    this.enableBehavioralAnalysis = true,
    this.enableAnomalyDetection = true,
    this.enableAutomatedResponse = false,
    this.securityScoreThreshold = 70,
    this.monitoredActivities = const [],
    this.riskFactors = const {},
    this.responseRules = const {},
    this.customConfiguration = const {},
  });

  SecurityConfiguration copyWith({
    bool? enableAdvancedSecurity,
    bool? enableRateLimiting,
    bool? enableIPBlocking,
    bool? enableDeviceFingerprinting,
    bool? enableBehavioralAnalysis,
    bool? enableAnomalyDetection,
    bool? enableAutomatedResponse,
    int? securityScoreThreshold,
    List<String>? monitoredActivities,
    Map<String, dynamic>? riskFactors,
    Map<String, dynamic>? responseRules,
    Map<String, dynamic>? customConfiguration,
  }) {
    return SecurityConfiguration(
      enableAdvancedSecurity: enableAdvancedSecurity ?? this.enableAdvancedSecurity,
      enableRateLimiting: enableRateLimiting ?? this.enableRateLimiting,
      enableIPBlocking: enableIPBlocking ?? this.enableIPBlocking,
      enableDeviceFingerprinting: enableDeviceFingerprinting ?? this.enableDeviceFingerprinting,
      enableBehavioralAnalysis: enableBehavioralAnalysis ?? this.enableBehavioralAnalysis,
      enableAnomalyDetection: enableAnomalyDetection ?? this.enableAnomalyDetection,
      enableAutomatedResponse: enableAutomatedResponse ?? this.enableAutomatedResponse,
      securityScoreThreshold: securityScoreThreshold ?? this.securityScoreThreshold,
      monitoredActivities: monitoredActivities ?? this.monitoredActivities,
      riskFactors: riskFactors ?? this.riskFactors,
      responseRules: responseRules ?? this.responseRules,
      customConfiguration: customConfiguration ?? this.customConfiguration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableAdvancedSecurity': enableAdvancedSecurity,
      'enableRateLimiting': enableRateLimiting,
      'enableIPBlocking': enableIPBlocking,
      'enableDeviceFingerprinting': enableDeviceFingerprinting,
      'enableBehavioralAnalysis': enableBehavioralAnalysis,
      'enableAnomalyDetection': enableAnomalyDetection,
      'enableAutomatedResponse': enableAutomatedResponse,
      'securityScoreThreshold': securityScoreThreshold,
      'monitoredActivities': monitoredActivities,
      'riskFactors': riskFactors,
      'responseRules': responseRules,
      'customConfiguration': customConfiguration,
    };
  }

  factory SecurityConfiguration.fromJson(Map<String, dynamic> json) {
    return SecurityConfiguration(
      enableAdvancedSecurity: json['enableAdvancedSecurity'] ?? true,
      enableRateLimiting: json['enableRateLimiting'] ?? true,
      enableIPBlocking: json['enableIPBlocking'] ?? false,
      enableDeviceFingerprinting: json['enableDeviceFingerprinting'] ?? true,
      enableBehavioralAnalysis: json['enableBehavioralAnalysis'] ?? true,
      enableAnomalyDetection: json['enableAnomalyDetection'] ?? true,
      enableAutomatedResponse: json['enableAutomatedResponse'] ?? false,
      securityScoreThreshold: json['securityScoreThreshold'] ?? 70,
      monitoredActivities: List<String>.from(json['monitoredActivities'] ?? []),
      riskFactors: json['riskFactors'] ?? {},
      responseRules: json['responseRules'] ?? {},
      customConfiguration: json['customConfiguration'] ?? {},
    );
  }

  @override
  List<Object?> get props => [
        enableAdvancedSecurity,
        enableRateLimiting,
        enableIPBlocking,
        enableDeviceFingerprinting,
        enableBehavioralAnalysis,
        enableAnomalyDetection,
        enableAutomatedResponse,
        securityScoreThreshold,
        monitoredActivities,
        riskFactors,
        responseRules,
        customConfiguration,
      ];
}