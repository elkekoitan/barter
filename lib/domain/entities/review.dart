import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String reviewerId;
  final String reviewerName;
  final String reviewerAvatar;
  final String revieweeId;
  final String revieweeName;
  final ReviewTargetType targetType;
  final String targetId;
  final String targetTitle;
  final int rating;
  final String title;
  final String content;
  final List<String> images;
  final List<String> videos;
  final Map<String, int> aspectRatings;
  final ReviewStatus status;
  final ReviewType type;
  final bool isVerified;
  final bool isRecommended;
  final int helpfulCount;
  final int notHelpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? verifiedAt;
  final Map<String, dynamic>? metadata;
  final List<ReviewResponse>? responses;
  final List<String>? tags;
  final ReviewContext? context;

  const ReviewEntity({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.revieweeId,
    required this.revieweeName,
    required this.targetType,
    required this.targetId,
    required this.targetTitle,
    required this.rating,
    this.title = '',
    required this.content,
    this.images = const [],
    this.videos = const [],
    this.aspectRatings = const {},
    this.status = ReviewStatus.pending,
    this.type = ReviewType.general,
    this.isVerified = false,
    this.isRecommended = false,
    this.helpfulCount = 0,
    this.notHelpfulCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.verifiedAt,
    this.metadata,
    this.responses,
    this.tags,
    this.context,
  });

  bool get isPositive => rating >= 4;

  bool get isNeutral => rating == 3;

  bool get isNegative => rating <= 2;

  bool get isApproved => status == ReviewStatus.approved;

  bool get isRejected => status == ReviewStatus.rejected;

  bool get isPending => status == ReviewStatus.pending;

  double get helpfulnessRatio => (helpfulCount + notHelpfulCount) > 0
      ? helpfulCount / (helpfulCount + notHelpfulCount)
      : 0.0;

  String get ratingLabel {
    switch (rating) {
      case 5:
        return 'Mükemmel';
      case 4:
        return 'Çok İyi';
      case 3:
        return 'İyi';
      case 2:
        return 'Kötü';
      case 1:
        return 'Çok Kötü';
      default:
        return 'Bilinmiyor';
    }
  }

  @override
  List<Object?> get props => [
        id,
        reviewerId,
        reviewerName,
        reviewerAvatar,
        revieweeId,
        revieweeName,
        targetType,
        targetId,
        targetTitle,
        rating,
        title,
        content,
        images,
        videos,
        aspectRatings,
        status,
        type,
        isVerified,
        isRecommended,
        helpfulCount,
        notHelpfulCount,
        createdAt,
        updatedAt,
        verifiedAt,
        metadata,
        responses,
        tags,
        context,
      ];
}

class ReviewResponse extends Equatable {
  final String id;
  final String reviewerId;
  final String reviewerName;
  final String content;
  final DateTime createdAt;
  final bool isFromBusiness;

  const ReviewResponse({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.content,
    required this.createdAt,
    this.isFromBusiness = false,
  });

  @override
  List<Object?> get props => [id, reviewerId, reviewerName, content, createdAt, isFromBusiness];
}

class ReviewContext extends Equatable {
  final String transactionId;
  final String listingId;
  final String barterId;
  final ReviewContextType contextType;
  final Map<String, dynamic>? contextData;

  const ReviewContext({
    required this.transactionId,
    required this.listingId,
    required this.barterId,
    required this.contextType,
    this.contextData,
  });

  @override
  List<Object?> get props => [transactionId, listingId, barterId, contextType, contextData];
}

enum ReviewTargetType {
  product('product', 'Ürün'),
  user('user', 'Kullanıcı'),
  transaction('transaction', 'İşlem'),
  service('service', 'Hizmet'),
  listing('listing', 'İlan');

  const ReviewTargetType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ReviewStatus {
  pending('pending', 'Bekliyor'),
  approved('approved', 'Onaylandı'),
  rejected('rejected', 'Reddedildi'),
  flagged('flagged', 'İşaretlendi'),
  hidden('hidden', 'Gizlendi');

  const ReviewStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ReviewType {
  general('general', 'Genel'),
  purchase('purchase', 'Satın Alma'),
  barter('barter', 'Takas'),
  service('service', 'Hizmet'),
  delivery('delivery', 'Teslimat'),
  communication('communication', 'İletişim'),
  packaging('packaging', 'Paketleme');

  const ReviewType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ReviewContextType {
  barterTransaction('barter_transaction', 'Takas İşlemi'),
  productPurchase('product_purchase', 'Ürün Satın Alma'),
  serviceExchange('service_exchange', 'Hizmet Değişimi'),
  listingReview('listing_review', 'İlan İncelemesi');

  const ReviewContextType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class RatingEntity extends Equatable {
  final String id;
  final String targetId;
  final ReviewTargetType targetType;
  final double averageRating;
  final int totalRatings;
  final Map<int, int> ratingDistribution;
  final Map<String, double> aspectAverages;
  final List<RatingTrend> ratingTrends;
  final DateTime lastUpdated;
  final Map<String, dynamic>? metadata;

  const RatingEntity({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.averageRating,
    required this.totalRatings,
    required this.ratingDistribution,
    required this.aspectAverages,
    required this.ratingTrends,
    required this.lastUpdated,
    this.metadata,
  });

  double get ratingPercentage => (averageRating / 5.0) * 100;

  int get fiveStarCount => ratingDistribution[5] ?? 0;

  int get fourStarCount => ratingDistribution[4] ?? 0;

  int get threeStarCount => ratingDistribution[3] ?? 0;

  int get twoStarCount => ratingDistribution[2] ?? 0;

  int get oneStarCount => ratingDistribution[1] ?? 0;

  bool get hasHighRating => averageRating >= 4.0;

  bool get hasMediumRating => averageRating >= 3.0 && averageRating < 4.0;

  bool get hasLowRating => averageRating < 3.0;

  String get ratingCategory {
    if (hasHighRating) return 'Yüksek';
    if (hasMediumRating) return 'Orta';
    return 'Düşük';
  }

  @override
  List<Object?> get props => [
        id,
        targetId,
        targetType,
        averageRating,
        totalRatings,
        ratingDistribution,
        aspectAverages,
        ratingTrends,
        lastUpdated,
        metadata,
      ];
}

class RatingTrend extends Equatable {
  final DateTime date;
  final double averageRating;
  final int totalRatings;
  final Map<int, int> distribution;

  const RatingTrend({
    required this.date,
    required this.averageRating,
    required this.totalRatings,
    required this.distribution,
  });

  @override
  List<Object?> get props => [date, averageRating, totalRatings, distribution];
}

class ReputationEntity extends Equatable {
  final String userId;
  final double overallScore;
  final ReputationTier tier;
  final int totalReviews;
  final int positiveReviews;
  final int neutralReviews;
  final int negativeReviews;
  final double responseRate;
  final double responseTimeHours;
  final int completedTransactions;
  final int successfulBarters;
  final Map<String, double> categoryScores;
  final List<ReputationBadge> badges;
  final DateTime lastUpdated;
  final Map<String, dynamic>? metadata;

  const ReputationEntity({
    required this.userId,
    required this.overallScore,
    this.tier = ReputationTier.bronze,
    required this.totalReviews,
    required this.positiveReviews,
    required this.neutralReviews,
    required this.negativeReviews,
    required this.responseRate,
    required this.responseTimeHours,
    required this.completedTransactions,
    required this.successfulBarters,
    required this.categoryScores,
    this.badges = const [],
    required this.lastUpdated,
    this.metadata,
  });

  double get positiveRatio => totalReviews > 0
      ? positiveReviews / totalReviews
      : 0.0;

  double get successRate => completedTransactions > 0
      ? successfulBarters / completedTransactions
      : 0.0;

  bool get isTrusted => tier != ReputationTier.bronze && positiveRatio >= 0.8;

  bool get isResponsive => responseRate >= 0.8 && responseTimeHours <= 24;

  String get tierDisplayName {
    switch (tier) {
      case ReputationTier.bronze:
        return 'Bronz';
      case ReputationTier.silver:
        return 'Gümüş';
      case ReputationTier.gold:
        return 'Altın';
      case ReputationTier.platinum:
        return 'Platin';
      case ReputationTier.diamond:
        return 'Elmas';
    }
  }

  @override
  List<Object?> get props => [
        userId,
        overallScore,
        tier,
        totalReviews,
        positiveReviews,
        neutralReviews,
        negativeReviews,
        responseRate,
        responseTimeHours,
        completedTransactions,
        successfulBarters,
        categoryScores,
        badges,
        lastUpdated,
        metadata,
      ];
}

enum ReputationTier {
  bronze('bronze', 'Bronz', 0.0, 3.0),
  silver('silver', 'Gümüş', 3.0, 3.5),
  gold('gold', 'Altın', 3.5, 4.0),
  platinum('platinum', 'Platin', 4.0, 4.5),
  diamond('diamond', 'Elmas', 4.5, 5.0);

  const ReputationTier(this.value, this.displayName, this.minScore, this.maxScore);
  final String value;
  final String displayName;
  final double minScore;
  final double maxScore;

  static ReputationTier fromScore(double score) {
    if (score >= ReputationTier.diamond.minScore) return ReputationTier.diamond;
    if (score >= ReputationTier.platinum.minScore) return ReputationTier.platinum;
    if (score >= ReputationTier.gold.minScore) return ReputationTier.gold;
    if (score >= ReputationTier.silver.minScore) return ReputationTier.silver;
    return ReputationTier.bronze;
  }
}

class ReputationBadge extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon;
  final BadgeType type;
  final BadgeRarity rarity;
  final DateTime earnedAt;
  final Map<String, dynamic>? metadata;

  const ReputationBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.rarity,
    required this.earnedAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [id, name, description, icon, type, rarity, earnedAt, metadata];
}

enum BadgeType {
  trust('trust', 'Güven'),
  quality('quality', 'Kalite'),
  responsiveness('responsiveness', 'Cevap Verirlik'),
  experience('experience', 'Deneyim'),
  community('community', 'Topluluk'),
  achievement('achievement', 'Başarım');

  const BadgeType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum BadgeRarity {
  common('common', 'Yaygın'),
  uncommon('uncommon', 'Yaygın Olmayan'),
  rare('rare', 'Nadir'),
  epic('epic', 'Epik'),
  legendary('legendary', 'Efsanevi');

  const BadgeRarity(this.value, this.displayName);
  final String value;
  final String displayName;
}

class ReviewAnalyticsEntity extends Equatable {
  final String id;
  final ReviewAnalyticsPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final Map<String, double> aspectAverages;
  final List<CategoryAnalytics> categoryAnalytics;
  final List<ReviewTrend> trends;
  final Map<String, int> reviewTypes;
  final Map<String, int> reviewStatuses;
  final double responseRate;
  final double averageResponseTimeHours;
  final List<TopReviewer> topReviewers;
  final List<MostReviewedItem> mostReviewedItems;
  final DateTime generatedAt;

  const ReviewAnalyticsEntity({
    required this.id,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.aspectAverages,
    required this.categoryAnalytics,
    required this.trends,
    required this.reviewTypes,
    required this.reviewStatuses,
    required this.responseRate,
    required this.averageResponseTimeHours,
    required this.topReviewers,
    required this.mostReviewedItems,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        period,
        startDate,
        endDate,
        totalReviews,
        averageRating,
        ratingDistribution,
        aspectAverages,
        categoryAnalytics,
        trends,
        reviewTypes,
        reviewStatuses,
        responseRate,
        averageResponseTimeHours,
        topReviewers,
        mostReviewedItems,
        generatedAt,
      ];
}

enum ReviewAnalyticsPeriod {
  daily('daily', 'Günlük'),
  weekly('weekly', 'Haftalık'),
  monthly('monthly', 'Aylık'),
  quarterly('quarterly', 'Çeyreklik'),
  yearly('yearly', 'Yıllık');

  const ReviewAnalyticsPeriod(this.value, this.displayName);
  final String value;
  final String displayName;
}

class CategoryAnalytics extends Equatable {
  final String categoryId;
  final String categoryName;
  final int reviewCount;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final List<String> topAspects;

  const CategoryAnalytics({
    required this.categoryId,
    required this.categoryName,
    required this.reviewCount,
    required this.averageRating,
    required this.ratingDistribution,
    required this.topAspects,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, reviewCount, averageRating, ratingDistribution, topAspects];
}

class ReviewTrend extends Equatable {
  final DateTime date;
  final int reviewCount;
  final double averageRating;
  final Map<int, int> ratingDistribution;

  const ReviewTrend({
    required this.date,
    required this.reviewCount,
    required this.averageRating,
    required this.ratingDistribution,
  });

  @override
  List<Object?> get props => [date, reviewCount, averageRating, ratingDistribution];
}

class TopReviewer extends Equatable {
  final String userId;
  final String userName;
  final String userAvatar;
  final int reviewCount;
  final double averageRating;
  final DateTime lastReviewDate;

  const TopReviewer({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.reviewCount,
    required this.averageRating,
    required this.lastReviewDate,
  });

  @override
  List<Object?> get props => [userId, userName, userAvatar, reviewCount, averageRating, lastReviewDate];
}

class MostReviewedItem extends Equatable {
  final String itemId;
  final String itemName;
  final String itemType;
  final int reviewCount;
  final double averageRating;
  final String? imageUrl;

  const MostReviewedItem({
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.reviewCount,
    required this.averageRating,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [itemId, itemName, itemType, reviewCount, averageRating, imageUrl];
}

class ReviewModerationEntity extends Equatable {
  final String id;
  final String reviewId;
  final String moderatorId;
  final String moderatorName;
  final ModerationAction action;
  final String reason;
  final String notes;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const ReviewModerationEntity({
    required this.id,
    required this.reviewId,
    required this.moderatorId,
    required this.moderatorName,
    required this.action,
    required this.reason,
    required this.notes,
    required this.createdAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [id, reviewId, moderatorId, moderatorName, action, reason, notes, createdAt, metadata];
}

enum ModerationAction {
  approve('approve', 'Onayla'),
  reject('reject', 'Reddet'),
  flag('flag', 'İşaretle'),
  hide('hide', 'Gizle'),
  unhide('unhide', 'Gizliliği Kaldır'),
  edit('edit', 'Düzenle');

  const ModerationAction(this.value, this.displayName);
  final String value;
  final String displayName;
}

class ReviewSettingsEntity extends Equatable {
  final String id;
  final bool requireVerifiedPurchase;
  final bool allowAnonymousReviews;
  final int minReviewLength;
  final int maxReviewLength;
  final int maxImagesPerReview;
  final int maxVideosPerReview;
  final bool enableAspectRatings;
  final List<String> allowedAspectCategories;
  final bool requireImagesForNegativeReviews;
  final bool autoApproveReviews;
  final int autoApproveThreshold;
  final int reviewExpirationDays;
  final bool enableReviewResponses;
  final bool moderateReviewResponses;
  final Map<String, dynamic> customSettings;

  const ReviewSettingsEntity({
    required this.id,
    this.requireVerifiedPurchase = true,
    this.allowAnonymousReviews = false,
    this.minReviewLength = 50,
    this.maxReviewLength = 2000,
    this.maxImagesPerReview = 5,
    this.maxVideosPerReview = 2,
    this.enableAspectRatings = true,
    this.allowedAspectCategories = const [],
    this.requireImagesForNegativeReviews = false,
    this.autoApproveReviews = false,
    this.autoApproveThreshold = 3,
    this.reviewExpirationDays = 365,
    this.enableReviewResponses = true,
    this.moderateReviewResponses = true,
    this.customSettings = const {},
  });

  @override
  List<Object?> get props => [
        id,
        requireVerifiedPurchase,
        allowAnonymousReviews,
        minReviewLength,
        maxReviewLength,
        maxImagesPerReview,
        maxVideosPerReview,
        enableAspectRatings,
        allowedAspectCategories,
        requireImagesForNegativeReviews,
        autoApproveReviews,
        autoApproveThreshold,
        reviewExpirationDays,
        enableReviewResponses,
        moderateReviewResponses,
        customSettings,
      ];
}
