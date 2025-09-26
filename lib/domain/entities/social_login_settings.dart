import 'package:equatable/equatable.dart';

class SocialLoginSettings extends Equatable {
  final bool googleEnabled;
  final bool facebookEnabled;
  final bool appleEnabled;
  final Map<String, bool> providerSettings;
  final Map<String, List<String>> providerScopes;
  final bool requireEmailVerification;
  final bool autoLinkExistingAccounts;

  const SocialLoginSettings({
    this.googleEnabled = false,
    this.facebookEnabled = false,
    this.appleEnabled = false,
    this.providerSettings = const {},
    this.providerScopes = const {},
    this.requireEmailVerification = true,
    this.autoLinkExistingAccounts = false,
  });

  @override
  List<Object?> get props => [
        googleEnabled,
        facebookEnabled,
        appleEnabled,
        providerSettings,
        providerScopes,
        requireEmailVerification,
        autoLinkExistingAccounts,
      ];

  SocialLoginSettings copyWith({
    bool? googleEnabled,
    bool? facebookEnabled,
    bool? appleEnabled,
    Map<String, bool>? providerSettings,
    Map<String, List<String>>? providerScopes,
    bool? requireEmailVerification,
    bool? autoLinkExistingAccounts,
  }) {
    return SocialLoginSettings(
      googleEnabled: googleEnabled ?? this.googleEnabled,
      facebookEnabled: facebookEnabled ?? this.facebookEnabled,
      appleEnabled: appleEnabled ?? this.appleEnabled,
      providerSettings: providerSettings ?? this.providerSettings,
      providerScopes: providerScopes ?? this.providerScopes,
      requireEmailVerification: requireEmailVerification ?? this.requireEmailVerification,
      autoLinkExistingAccounts: autoLinkExistingAccounts ?? this.autoLinkExistingAccounts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'googleEnabled': googleEnabled,
      'facebookEnabled': facebookEnabled,
      'appleEnabled': appleEnabled,
      'providerSettings': providerSettings,
      'providerScopes': providerScopes,
      'requireEmailVerification': requireEmailVerification,
      'autoLinkExistingAccounts': autoLinkExistingAccounts,
    };
  }

  factory SocialLoginSettings.fromJson(Map<String, dynamic> json) {
    return SocialLoginSettings(
      googleEnabled: json['googleEnabled'] ?? false,
      facebookEnabled: json['facebookEnabled'] ?? false,
      appleEnabled: json['appleEnabled'] ?? false,
      providerSettings: Map<String, bool>.from(json['providerSettings'] ?? {}),
      providerScopes: Map<String, List<String>>.from(
        (json['providerScopes'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value ?? [])),
        ),
      ),
      requireEmailVerification: json['requireEmailVerification'] ?? true,
      autoLinkExistingAccounts: json['autoLinkExistingAccounts'] ?? false,
    );
  }
}
