import 'package:equatable/equatable.dart';

class ListingEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final CategoryEntity category;
  final ListingCondition condition;
  final String? brand;
  final String? model;
  final int? year;
  final List<ListingMedia> media;
  final ListingPricing pricing;
  final ListingDelivery delivery;
  final ListingLocation location;
  final ListingStatus status;
  final ListingModeration moderation;
  final ListingStats stats;
  final ListingBoost? boost;
  final bool isActive;
  final bool isFeatured;
  final bool isUrgent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;

  const ListingEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
    this.brand,
    this.model,
    this.year,
    required this.media,
    required this.pricing,
    required this.delivery,
    required this.location,
    required this.status,
    required this.moderation,
    required this.stats,
    this.boost,
    this.isActive = true,
    this.isFeatured = false,
    this.isUrgent = false,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
  });

  bool get isExpired => expiresAt?.isBefore(DateTime.now()) == true;

  bool get isAvailable => isActive && !isExpired;

  bool get requiresModeration => moderation.status == ModerationStatus.pending;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        category,
        condition,
        brand,
        model,
        year,
        media,
        pricing,
        delivery,
        location,
        status,
        moderation,
        stats,
        boost,
        isActive,
        isFeatured,
        isUrgent,
        createdAt,
        updatedAt,
        expiresAt,
      ];

  List<String> get images => media.map((m) => m.url).toList();

  String? get primaryImage => media.where((m) => m.isPrimary).isNotEmpty
      ? media.where((m) => m.isPrimary).first.url
      : media.isNotEmpty
          ? media.first.url
          : null;

  double? get price => pricing.cashPrice;

  String get currency => pricing.currency;
}

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final String? imageUrl;
  final CategoryEntity? parent;
  final List<CategoryEntity> subcategories;
  final bool isActive;
  final int sortOrder;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    this.imageUrl,
    this.parent,
    this.subcategories = const [],
    this.isActive = true,
    this.sortOrder = 0,
  });

  String get fullPath {
    if (parent == null) return name;
    return '${parent!.fullPath} > $name';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        iconUrl,
        imageUrl,
        parent,
        subcategories,
        isActive,
        sortOrder,
      ];
}

class ListingMedia extends Equatable {
  final String id;
  final MediaType type;
  final String url;
  final String? thumbnailUrl;
  final int order;
  final bool isPrimary;

  const ListingMedia({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.order = 0,
    this.isPrimary = false,
  });

  @override
  List<Object?> get props => [id, type, url, thumbnailUrl, order, isPrimary];
}

class ListingPricing extends Equatable {
  final double? cashPrice;
  final String currency;
  final bool isNegotiable;
  final BarterOptions barterOptions;

  const ListingPricing({
    this.cashPrice,
    this.currency = 'TRY',
    this.isNegotiable = true,
    required this.barterOptions,
  });

  bool get hasCashPrice => cashPrice != null && cashPrice! > 0;

  bool get acceptsBarter => barterOptions.acceptDirectSwap ||
      barterOptions.acceptSwapWithCash ||
      barterOptions.acceptBarterPool;

  double? get price => cashPrice;

  String get currency => this.currency;

  @override
  List<Object?> get props => [cashPrice, currency, isNegotiable, barterOptions];
}

class BarterOptions extends Equatable {
  final bool acceptDirectSwap;
  final bool acceptSwapWithCash;
  final bool acceptBarterPool;
  final List<String>? preferredItems;
  final double? minCashDifference;
  final double? maxCashDifference;

  const BarterOptions({
    this.acceptDirectSwap = false,
    this.acceptSwapWithCash = false,
    this.acceptBarterPool = false,
    this.preferredItems,
    this.minCashDifference,
    this.maxCashDifference,
  });

  @override
  List<Object?> get props => [
        acceptDirectSwap,
        acceptSwapWithCash,
        acceptBarterPool,
        preferredItems,
        minCashDifference,
        maxCashDifference,
      ];
}

class ListingDelivery extends Equatable {
  final List<DeliveryMethod> methods;
  final List<String>? cargoProviders;
  final double? shippingCost;
  final int? estimatedDays;
  final bool isFreeShipping;

  const ListingDelivery({
    required this.methods,
    this.cargoProviders,
    this.shippingCost,
    this.estimatedDays,
    this.isFreeShipping = false,
  });

  bool get hasShipping => methods.contains(DeliveryMethod.cargo);

  bool get hasPickup => methods.contains(DeliveryMethod.pickup);

  bool get hasInPerson => methods.contains(DeliveryMethod.inPerson);

  @override
  List<Object?> get props => [
        methods,
        cargoProviders,
        shippingCost,
        estimatedDays,
        isFreeShipping,
      ];
}

class ListingLocation extends Equatable {
  final String city;
  final String district;
  final String? neighborhood;
  final double? latitude;
  final double? longitude;
  final String? address;

  const ListingLocation({
    required this.city,
    required this.district,
    this.neighborhood,
    this.latitude,
    this.longitude,
    this.address,
  });

  @override
  List<Object?> get props => [
        city,
        district,
        neighborhood,
        latitude,
        longitude,
        address,
      ];
}

class ListingStats extends Equatable {
  final int viewCount;
  final int favoriteCount;
  final int shareCount;
  final int offerCount;
  final double? averageRating;

  const ListingStats({
    this.viewCount = 0,
    this.favoriteCount = 0,
    this.shareCount = 0,
    this.offerCount = 0,
    this.averageRating,
  });

  @override
  List<Object?> get props => [
        viewCount,
        favoriteCount,
        shareCount,
        offerCount,
        averageRating,
      ];
}

class ListingBoost extends Equatable {
  final BoostType type;
  final DateTime expiresAt;
  final bool isActive;

  const ListingBoost({
    required this.type,
    required this.expiresAt,
    this.isActive = true,
  });

  bool get isExpired => expiresAt.isBefore(DateTime.now());

  @override
  List<Object?> get props => [type, expiresAt, isActive];
}

class ListingModeration extends Equatable {
  final ModerationStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final ModerationLevel level;

  const ListingModeration({
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
    required this.level,
  });

  @override
  List<Object?> get props => [
        status,
        reviewedBy,
        reviewedAt,
        rejectionReason,
        level,
      ];
}

enum ListingCondition {
  brandNew('brand_new', 'Yeni'),
  likeNew('like_new', 'Yeni Gibi'),
  veryGood('very_good', 'Çok İyi'),
  good('good', 'İyi'),
  acceptable('acceptable', 'Kabul Edilebilir'),
  defective('defective', 'Arızalı');

  const ListingCondition(this.value, this.displayName);
  final String value;
  final String displayName;

  static ListingCondition fromString(String value) {
    return ListingCondition.values.firstWhere(
      (condition) => condition.value == value,
      orElse: () => ListingCondition.good,
    );
  }
}

enum MediaType {
  image('image'),
  video('video');

  const MediaType(this.value);
  final String value;

  static MediaType fromString(String value) {
    return MediaType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MediaType.image,
    );
  }
}

enum DeliveryMethod {
  inPerson('in_person', 'Yüz Yüze'),
  pickup('pickup', 'Alış'),
  cargo('cargo', 'Kargo');

  const DeliveryMethod(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum BoostType {
  standard('standard', 'Standart'),
  featured('featured', 'Öne Çıkan'),
  premium('premium', 'Premium'),
  urgent('urgent', 'Acil');

  const BoostType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ListingStatus {
  draft('draft', 'Taslak'),
  pending('pending', 'Bekliyor'),
  active('active', 'Aktif'),
  paused('paused', 'Durduruldu'),
  sold('sold', 'Satıldı'),
  expired('expired', 'Süresi Doldu'),
  rejected('rejected', 'Reddedildi'),
  deleted('deleted', 'Silindi');

  const ListingStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static ListingStatus fromString(String value) {
    return ListingStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ListingStatus.active,
    );
  }
}

enum ModerationStatus {
  pending('pending', 'Bekliyor'),
  approved('approved', 'Onaylandı'),
  rejected('rejected', 'Reddedildi'),
  needsReview('needs_review', 'İnceleme Gerekiyor');

  const ModerationStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static ModerationStatus fromString(String value) {
    return ModerationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ModerationStatus.pending,
    );
  }
}

enum ModerationLevel {
  low('low', 'Düşük'),
  medium('medium', 'Orta'),
  high('high', 'Yüksek'),
  automatic('automatic', 'Otomatik');

  const ModerationLevel(this.value, this.displayName);
  final String value;
  final String displayName;

  static ModerationLevel fromString(String value) {
    return ModerationLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => ModerationLevel.medium,
    );
  }
}
