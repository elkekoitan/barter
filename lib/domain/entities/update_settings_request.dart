import 'package:equatable/equatable.dart';

class UpdateSettingsRequest extends Equatable {
  final String userId;
  final bool? pushEnabled;
  final bool? emailEnabled;
  final bool? smsEnabled;
  final bool? inAppEnabled;
  final Map<String, bool>? categorySettings;
  final List<String>? allowedTypes;
  final List<String>? blockedTypes;

  const UpdateSettingsRequest({
    required this.userId,
    this.pushEnabled,
    this.emailEnabled,
    this.smsEnabled,
    this.inAppEnabled,
    this.categorySettings,
    this.allowedTypes,
    this.blockedTypes,
  });

  @override
  List<Object?> get props => [
        userId,
        pushEnabled,
        emailEnabled,
        smsEnabled,
        inAppEnabled,
        categorySettings,
        allowedTypes,
        blockedTypes,
      ];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'pushEnabled': pushEnabled,
      'emailEnabled': emailEnabled,
      'smsEnabled': smsEnabled,
      'inAppEnabled': inAppEnabled,
      'categorySettings': categorySettings,
      'allowedTypes': allowedTypes,
      'blockedTypes': blockedTypes,
    };
  }

  factory UpdateSettingsRequest.fromJson(Map<String, dynamic> json) {
    return UpdateSettingsRequest(
      userId: json['userId'],
      pushEnabled: json['pushEnabled'],
      emailEnabled: json['emailEnabled'],
      smsEnabled: json['smsEnabled'],
      inAppEnabled: json['inAppEnabled'],
      categorySettings: Map<String, bool>.from(json['categorySettings'] ?? {}),
      allowedTypes: List<String>.from(json['allowedTypes'] ?? []),
      blockedTypes: List<String>.from(json['blockedTypes'] ?? []),
    );
  }
}
