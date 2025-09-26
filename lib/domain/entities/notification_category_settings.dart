import 'package:equatable/equatable.dart';
import 'notification_type.dart';

class NotificationCategorySettings extends Equatable {
  final NotificationCategory category;
  final bool enabled;
  final bool emailEnabled;
  final bool pushEnabled;
  final bool inAppEnabled;
  final List<String> allowedTypes;
  final List<String> blockedTypes;
  final Map<String, dynamic> customSettings;

  const NotificationCategorySettings({
    required this.category,
    this.enabled = true,
    this.emailEnabled = true,
    this.pushEnabled = true,
    this.inAppEnabled = true,
    this.allowedTypes = const [],
    this.blockedTypes = const [],
    this.customSettings = const {},
  });

  @override
  List<Object?> get props => [
        category,
        enabled,
        emailEnabled,
        pushEnabled,
        inAppEnabled,
        allowedTypes,
        blockedTypes,
        customSettings,
      ];

  NotificationCategorySettings copyWith({
    NotificationCategory? category,
    bool? enabled,
    bool? emailEnabled,
    bool? pushEnabled,
    bool? inAppEnabled,
    List<String>? allowedTypes,
    List<String>? blockedTypes,
    Map<String, dynamic>? customSettings,
  }) {
    return NotificationCategorySettings(
      category: category ?? this.category,
      enabled: enabled ?? this.enabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      allowedTypes: allowedTypes ?? this.allowedTypes,
      blockedTypes: blockedTypes ?? this.blockedTypes,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  bool canSendNotification(NotificationType type) {
    if (!enabled) return false;
    if (blockedTypes.contains(type.id)) return false;
    if (allowedTypes.isNotEmpty && !allowedTypes.contains(type.id)) return false;
    return true;
  }

  bool canSendEmail(NotificationType type) {
    return canSendNotification(type) && emailEnabled;
  }

  bool canSendPush(NotificationType type) {
    return canSendNotification(type) && pushEnabled;
  }

  bool canSendInApp(NotificationType type) {
    return canSendNotification(type) && inAppEnabled;
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.value,
      'enabled': enabled,
      'emailEnabled': emailEnabled,
      'pushEnabled': pushEnabled,
      'inAppEnabled': inAppEnabled,
      'allowedTypes': allowedTypes,
      'blockedTypes': blockedTypes,
      'customSettings': customSettings,
    };
  }

  factory NotificationCategorySettings.fromJson(Map<String, dynamic> json) {
    return NotificationCategorySettings(
      category: NotificationCategory.values.firstWhere(
        (e) => e.value == json['category'],
        orElse: () => NotificationCategory.system,
      ),
      enabled: json['enabled'] ?? true,
      emailEnabled: json['emailEnabled'] ?? true,
      pushEnabled: json['pushEnabled'] ?? true,
      inAppEnabled: json['inAppEnabled'] ?? true,
      allowedTypes: List<String>.from(json['allowedTypes'] ?? []),
      blockedTypes: List<String>.from(json['blockedTypes'] ?? []),
      customSettings: Map<String, dynamic>.from(json['customSettings'] ?? {}),
    );
  }

  // Predefined category settings
  static const barterSettings = NotificationCategorySettings(
    category: NotificationCategory.barter,
    enabled: true,
    emailEnabled: true,
    pushEnabled: true,
    inAppEnabled: true,
    allowedTypes: ['barter_offer', 'barter_accepted', 'barter_rejected'],
  );

  static const messageSettings = NotificationCategorySettings(
    category: NotificationCategory.message,
    enabled: true,
    emailEnabled: true,
    pushEnabled: true,
    inAppEnabled: true,
    allowedTypes: ['new_message'],
  );

  static const systemSettings = NotificationCategorySettings(
    category: NotificationCategory.system,
    enabled: true,
    emailEnabled: false,
    pushEnabled: true,
    inAppEnabled: true,
    allowedTypes: ['system_update'],
  );

  static const marketingSettings = NotificationCategorySettings(
    category: NotificationCategory.marketing,
    enabled: false,
    emailEnabled: true,
    pushEnabled: false,
    inAppEnabled: false,
    allowedTypes: ['marketing'],
  );

  static const securitySettings = NotificationCategorySettings(
    category: NotificationCategory.security,
    enabled: true,
    emailEnabled: true,
    pushEnabled: true,
    inAppEnabled: true,
    allowedTypes: ['security_alert'],
  );
}
