import 'package:equatable/equatable.dart';

enum NotificationCategory {
  barter('barter', 'Takas'),
  message('message', 'Mesaj'),
  system('system', 'Sistem'),
  marketing('marketing', 'Pazarlama'),
  security('security', 'Güvenlik');

  const NotificationCategory(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum NotificationPriority {
  low('low', 'Düşük'),
  normal('normal', 'Normal'),
  high('high', 'Yüksek'),
  urgent('urgent', 'Acil');

  const NotificationPriority(this.value, this.displayName);
  final String value;
  final String displayName;
}

class NotificationType extends Equatable {
  final String id;
  final String name;
  final String description;
  final NotificationCategory category;
  final NotificationPriority priority;
  final bool requiresAction;
  final bool emailEnabled;
  final bool pushEnabled;
  final bool inAppEnabled;
  final Map<String, dynamic> metadata;

  const NotificationType({
    required this.id,
    required this.name,
    this.description = '',
    required this.category,
    this.priority = NotificationPriority.normal,
    this.requiresAction = false,
    this.emailEnabled = true,
    this.pushEnabled = true,
    this.inAppEnabled = true,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        priority,
        requiresAction,
        emailEnabled,
        pushEnabled,
        inAppEnabled,
        metadata,
      ];

  NotificationType copyWith({
    String? id,
    String? name,
    String? description,
    NotificationCategory? category,
    NotificationPriority? priority,
    bool? requiresAction,
    bool? emailEnabled,
    bool? pushEnabled,
    bool? inAppEnabled,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      requiresAction: requiresAction ?? this.requiresAction,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.value,
      'priority': priority.value,
      'requiresAction': requiresAction,
      'emailEnabled': emailEnabled,
      'pushEnabled': pushEnabled,
      'inAppEnabled': inAppEnabled,
      'metadata': metadata,
    };
  }

  factory NotificationType.fromJson(Map<String, dynamic> json) {
    return NotificationType(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      category: NotificationCategory.values.firstWhere(
        (e) => e.value == json['category'],
        orElse: () => NotificationCategory.system,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.value == json['priority'],
        orElse: () => NotificationPriority.normal,
      ),
      requiresAction: json['requiresAction'] ?? false,
      emailEnabled: json['emailEnabled'] ?? true,
      pushEnabled: json['pushEnabled'] ?? true,
      inAppEnabled: json['inAppEnabled'] ?? true,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  // Predefined notification types
  static const barterOffer = NotificationType(
    id: 'barter_offer',
    name: 'Takas Teklifi',
    description: 'Yeni takas teklifi alındı',
    category: NotificationCategory.barter,
    requiresAction: true,
  );

  static const barterAccepted = NotificationType(
    id: 'barter_accepted',
    name: 'Takas Kabul Edildi',
    description: 'Takas teklifiniz kabul edildi',
    category: NotificationCategory.barter,
  );

  static const barterRejected = NotificationType(
    id: 'barter_rejected',
    name: 'Takas Reddedildi',
    description: 'Takas teklifiniz reddedildi',
    category: NotificationCategory.barter,
  );

  static const newMessage = NotificationType(
    id: 'new_message',
    name: 'Yeni Mesaj',
    description: 'Yeni mesaj aldınız',
    category: NotificationCategory.message,
    requiresAction: true,
  );

  static const systemUpdate = NotificationType(
    id: 'system_update',
    name: 'Sistem Güncellemesi',
    description: 'Sistem güncellemesi mevcut',
    category: NotificationCategory.system,
  );

  static const securityAlert = NotificationType(
    id: 'security_alert',
    name: 'Güvenlik Uyarısı',
    description: 'Hesabınızla ilgili güvenlik uyarısı',
    category: NotificationCategory.security,
    priority: NotificationPriority.high,
  );

  static const marketing = NotificationType(
    id: 'marketing',
    name: 'Pazarlama',
    description: 'Pazarlama ve kampanya bilgileri',
    category: NotificationCategory.marketing,
    priority: NotificationPriority.low,
  );
}
