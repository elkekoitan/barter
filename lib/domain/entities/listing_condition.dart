import 'package:equatable/equatable.dart';

enum ListingCondition {
  brandNew('brand_new', 'Sıfır', 'Ürün hiç kullanılmamış'),
  likeNew('like_new', 'Yeni Gibi', 'Çok az kullanılmış, mükemmel durumda'),
  veryGood('very_good', 'Çok İyi', 'İyi durumda, küçük izler olabilir'),
  good('good', 'İyi', 'Normal kullanım izleri var'),
  fair('fair', 'Orta', 'Belirgin kullanım izleri var'),
  poor('poor', 'Kötü', 'Hasarlı veya çalışmayan durumda'),
  forParts('for_parts', 'Parça İçin', 'Sadece parçaları için uygun');

  const ListingCondition(this.value, this.displayName, this.description);
  final String value;
  final String displayName;
  final String description;

  static ListingCondition fromString(String value) {
    return ListingCondition.values.firstWhere(
      (condition) => condition.value == value,
      orElse: () => ListingCondition.good,
    );
  }

  static ListingCondition fromDisplayName(String displayName) {
    return ListingCondition.values.firstWhere(
      (condition) => condition.displayName == displayName,
      orElse: () => ListingCondition.good,
    );
  }
}

class ListingConditionEntity extends Equatable {
  final ListingCondition condition;
  final String? customDescription;
  final bool verified;
  final DateTime? verifiedAt;

  const ListingConditionEntity({
    required this.condition,
    this.customDescription,
    this.verified = false,
    this.verifiedAt,
  });

  @override
  List<Object?> get props => [condition, customDescription, verified, verifiedAt];

  ListingConditionEntity copyWith({
    ListingCondition? condition,
    String? customDescription,
    bool? verified,
    DateTime? verifiedAt,
  }) {
    return ListingConditionEntity(
      condition: condition ?? this.condition,
      customDescription: customDescription ?? this.customDescription,
      verified: verified ?? this.verified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition.value,
      'customDescription': customDescription,
      'verified': verified,
      'verifiedAt': verifiedAt?.toIso8601String(),
    };
  }

  factory ListingConditionEntity.fromJson(Map<String, dynamic> json) {
    return ListingConditionEntity(
      condition: ListingCondition.fromString(json['condition'] ?? 'good'),
      customDescription: json['customDescription'],
      verified: json['verified'] ?? false,
      verifiedAt: json['verifiedAt'] != null ? DateTime.parse(json['verifiedAt']) : null,
    );
  }
}
