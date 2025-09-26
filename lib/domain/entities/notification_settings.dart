import 'package:equatable/equatable.dart';

class NotificationSettingsEntity extends Equatable {
  final String userId;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool barterOffers;
  final bool newMessages;
  final bool systemUpdates;
  final bool marketingEmails;
  final Map<String, bool> categorySettings;

  const NotificationSettingsEntity({
    required this.userId,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.barterOffers = true,
    this.newMessages = true,
    this.systemUpdates = true,
    this.marketingEmails = false,
    this.categorySettings = const {},
  });

  @override
  List<Object?> get props => [
        userId,
        pushNotifications,
        emailNotifications,
        barterOffers,
        newMessages,
        systemUpdates,
        marketingEmails,
        categorySettings,
      ];

  NotificationSettingsEntity copyWith({
    String? userId,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? barterOffers,
    bool? newMessages,
    bool? systemUpdates,
    bool? marketingEmails,
    Map<String, bool>? categorySettings,
  }) {
    return NotificationSettingsEntity(
      userId: userId ?? this.userId,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      barterOffers: barterOffers ?? this.barterOffers,
      newMessages: newMessages ?? this.newMessages,
      systemUpdates: systemUpdates ?? this.systemUpdates,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      categorySettings: categorySettings ?? this.categorySettings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'barterOffers': barterOffers,
      'newMessages': newMessages,
      'systemUpdates': systemUpdates,
      'marketingEmails': marketingEmails,
      'categorySettings': categorySettings,
    };
  }

  factory NotificationSettingsEntity.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsEntity(
      userId: json['userId'],
      pushNotifications: json['pushNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      barterOffers: json['barterOffers'] ?? true,
      newMessages: json['newMessages'] ?? true,
      systemUpdates: json['systemUpdates'] ?? true,
      marketingEmails: json['marketingEmails'] ?? false,
      categorySettings: Map<String, bool>.from(json['categorySettings'] ?? {}),
    );
  }
}
