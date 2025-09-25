import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/review.dart';

abstract class ReviewRepository {
  // Review Operations
  Future<Either<Failure, List<ReviewEntity>>> getReviews({
    String? targetId,
    ReviewTargetType? targetType,
    String? reviewerId,
    String? revieweeId,
    ReviewStatus? status,
    ReviewType? type,
    int? minRating,
    int? maxRating,
    bool? isVerified,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 20,
    String? sortBy,
    bool sortDescending = true,
  });

  Future<Either<Failure, ReviewEntity>> getReviewById(String reviewId);

  Future<Either<Failure, ReviewEntity>> createReview(CreateReviewRequest request);

  Future<Either<Failure, ReviewEntity>> updateReview(String reviewId, UpdateReviewRequest request);

  Future<Either<Failure, void>> deleteReview(String reviewId);

  Future<Either<Failure, void>> approveReview(String reviewId, String moderatorNotes);

  Future<Either<Failure, void>> rejectReview(String reviewId, String reason, String moderatorNotes);

  Future<Either<Failure, void>> flagReview(String reviewId, String reason);

  Future<Either<Failure, void>> hideReview(String reviewId, String reason);

  Future<Either<Failure, void>> unhideReview(String reviewId);

  Future<Either<Failure, ReviewEntity>> addReviewResponse(String reviewId, AddReviewResponseRequest request);

  Future<Either<Failure, void>> removeReviewResponse(String reviewId, String responseId);

  Future<Either<Failure, void>> markReviewHelpful(String reviewId);

  Future<Either<Failure, void>> markReviewNotHelpful(String reviewId);

  Future<Either<Failure, void>> reportReview(String reviewId, ReportReviewRequest request);

  // Rating Operations
  Future<Either<Failure, RatingEntity>> getRating({
    required String targetId,
    required ReviewTargetType targetType,
  });

  Future<Either<Failure, RatingEntity>> getOrCreateRating({
    required String targetId,
    required ReviewTargetType targetType,
  });

  Future<Either<Failure, void>> updateRating(String targetId, ReviewTargetType targetType, int rating);

  Future<Either<Failure, List<RatingEntity>>> getRatingsByUser(String userId);

  Future<Either<Failure, List<RatingEntity>>> getTopRated({
    ReviewTargetType? targetType,
    int limit = 10,
  });

  // Reputation Operations
  Future<Either<Failure, ReputationEntity>> getUserReputation(String userId);

  Future<Either<Failure, ReputationEntity>> updateUserReputation(String userId);

  Future<Either<Failure, void>> recalculateUserReputation(String userId);

  Future<Either<Failure, List<ReputationEntity>>> getTopReputations({
    int limit = 20,
    ReputationTier? minTier,
  });

  Future<Either<Failure, void>> awardReputationBadge(String userId, ReputationBadge badge);

  Future<Either<Failure, void>> revokeReputationBadge(String userId, String badgeId);

  // Review Analytics
  Future<Either<Failure, ReviewAnalyticsEntity>> getReviewAnalytics({
    ReviewAnalyticsPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  });

  Future<Either<Failure, List<ReviewAnalyticsEntity>>> getReviewAnalyticsByPeriod(
    DateTime startDate,
    DateTime endDate,
  );

  Future<Either<Failure, Map<String, dynamic>>> getReviewInsights(String targetId, ReviewTargetType targetType);

  // Moderation Operations
  Future<Either<Failure, List<ReviewEntity>>> getReviewsForModeration({
    ReviewStatus? status,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, ReviewModerationEntity>> getReviewModerationHistory(String reviewId);

  Future<Either<Failure, List<ReviewModerationEntity>>> getModerationHistoryByModerator(String moderatorId);

  Future<Either<Failure, void>> moderateReview(String reviewId, ModerationAction action, String reason, String notes);

  // Bulk Operations
  Future<Either<Failure, void>> bulkApproveReviews(List<String> reviewIds);

  Future<Either<Failure, void>> bulkRejectReviews(List<String> reviewIds, String reason);

  Future<Either<Failure, void>> bulkDeleteReviews(List<String> reviewIds, String reason);

  Future<Either<Failure, void>> bulkHideReviews(List<String> reviewIds, String reason);

  // Settings
  Future<Either<Failure, ReviewSettingsEntity>> getReviewSettings();

  Future<Either<Failure, ReviewSettingsEntity>> updateReviewSettings(UpdateReviewSettingsRequest request);

  // Search & Filter
  Future<Either<Failure, List<ReviewEntity>>> searchReviews(ReviewSearchRequest request);

  Future<Either<Failure, List<ReviewEntity>>> getReviewsByKeyword(String keyword, {
    ReviewTargetType? targetType,
    int page = 1,
    int limit = 20,
  });

  // Statistics
  Future<Either<Failure, ReviewStatsEntity>> getReviewStats({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  });

  Future<Either<Failure, UserReviewStatsEntity>> getUserReviewStats(String userId);

  // Real-time Updates
  Stream<Either<Failure, List<ReviewEntity>>> subscribeToReviews(String targetId, ReviewTargetType targetType);

  Stream<Either<Failure, RatingEntity>> subscribeToRating(String targetId, ReviewTargetType targetType);

  Stream<Either<Failure, ReputationEntity>> subscribeToUserReputation(String userId);

  Stream<Either<Failure, List<ReviewEntity>>> subscribeToModerationQueue();

  // Advanced Features
  Future<Either<Failure, List<String>>> getReviewSuggestions(String userId);

  Future<Either<Failure, void>> importReviews(ImportReviewsRequest request);

  Future<Either<Failure, void>> exportReviews(ExportReviewsRequest request);

  Future<Either<Failure, void>> cleanupOldReviews(int daysOld);

  Future<Either<Failure, void>> refreshReviewCache(String targetId, ReviewTargetType targetType);
}

// Request/Response Models
class CreateReviewRequest {
  final String reviewerId;
  final String revieweeId;
  final ReviewTargetType targetType;
  final String targetId;
  final String targetTitle;
  final int rating;
  final String title;
  final String content;
  final List<String> images;
  final List<String> videos;
  final Map<String, int> aspectRatings;
  final ReviewType type;
  final List<String> tags;
  final ReviewContext? context;
  final Map<String, dynamic>? metadata;

  const CreateReviewRequest({
    required this.reviewerId,
    required this.revieweeId,
    required this.targetType,
    required this.targetId,
    required this.targetTitle,
    required this.rating,
    required this.title,
    required this.content,
    this.images = const [],
    this.videos = const [],
    this.aspectRatings = const {},
    this.type = ReviewType.general,
    this.tags = const [],
    this.context,
    this.metadata,
  });
}

class UpdateReviewRequest {
  final int? rating;
  final String? title;
  final String? content;
  final List<String>? images;
  final List<String>? videos;
  final Map<String, int>? aspectRatings;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;

  const UpdateReviewRequest({
    this.rating,
    this.title,
    this.content,
    this.images,
    this.videos,
    this.aspectRatings,
    this.tags,
    this.metadata,
  });
}

class AddReviewResponseRequest {
  final String reviewerId;
  final String reviewerName;
  final String content;
  final bool isFromBusiness;

  const AddReviewResponseRequest({
    required this.reviewerId,
    required this.reviewerName,
    required this.content,
    this.isFromBusiness = false,
  });
}

class ReportReviewRequest {
  final String reporterId;
  final String reason;
  final String description;
  final ReportCategory category;

  const ReportReviewRequest({
    required this.reporterId,
    required this.reason,
    required this.description,
    required this.category,
  });
}

enum ReportCategory {
  spam('spam', 'Spam'),
  inappropriate('inappropriate', 'Uygunsuz İçerik'),
  fake('fake', 'Sahte İnceleme'),
  harassment('harassment', 'Taciz'),
  misinformation('misinformation', 'Yanlış Bilgi'),
  other('other', 'Diğer');

  const ReportCategory(this.value, this.displayName);
  final String value;
  final String displayName;
}

class UpdateReviewSettingsRequest {
  final bool? requireVerifiedPurchase;
  final bool? allowAnonymousReviews;
  final int? minReviewLength;
  final int? maxReviewLength;
  final int? maxImagesPerReview;
  final int? maxVideosPerReview;
  final bool? enableAspectRatings;
  final List<String>? allowedAspectCategories;
  final bool? requireImagesForNegativeReviews;
  final bool? autoApproveReviews;
  final int? autoApproveThreshold;
  final int? reviewExpirationDays;
  final bool? enableReviewResponses;
  final bool? moderateReviewResponses;
  final Map<String, dynamic>? customSettings;

  const UpdateReviewSettingsRequest({
    this.requireVerifiedPurchase,
    this.allowAnonymousReviews,
    this.minReviewLength,
    this.maxReviewLength,
    this.maxImagesPerReview,
    this.maxVideosPerReview,
    this.enableAspectRatings,
    this.allowedAspectCategories,
    this.requireImagesForNegativeReviews,
    this.autoApproveReviews,
    this.autoApproveThreshold,
    this.reviewExpirationDays,
    this.enableReviewResponses,
    this.moderateReviewResponses,
    this.customSettings,
  });
}

class ReviewSearchRequest {
  final String query;
  final ReviewTargetType? targetType;
  final int? minRating;
  final int? maxRating;
  final ReviewStatus? status;
  final ReviewType? type;
  final bool? isVerified;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? categories;
  final List<String>? tags;
  final int page;
  final int limit;
  final String? sortBy;
  final bool sortDescending;

  const ReviewSearchRequest({
    required this.query,
    this.targetType,
    this.minRating,
    this.maxRating,
    this.status,
    this.type,
    this.isVerified,
    this.startDate,
    this.endDate,
    this.categories,
    this.tags,
    this.page = 1,
    this.limit = 20,
    this.sortBy,
    this.sortDescending = true,
  });
}

class ReviewStatsEntity extends Equatable {
  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final int totalHelpfulVotes;
  final int totalReports;
  final double averageResponseTimeHours;
  final Map<String, int> reviewsByType;
  final Map<String, int> reviewsByStatus;
  final List<ReviewTrend> trends;
  final DateTime generatedAt;

  const ReviewStatsEntity({
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.totalHelpfulVotes,
    required this.totalReports,
    required this.averageResponseTimeHours,
    required this.reviewsByType,
    required this.reviewsByStatus,
    required this.trends,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        totalReviews,
        averageRating,
        ratingDistribution,
        totalHelpfulVotes,
        totalReports,
        averageResponseTimeHours,
        reviewsByType,
        reviewsByStatus,
        trends,
        generatedAt,
      ];
}

class UserReviewStatsEntity extends Equatable {
  final String userId;
  final int totalReviews;
  final int approvedReviews;
  final int rejectedReviews;
  final int pendingReviews;
  final double averageRating;
  final int totalHelpfulVotes;
  final int totalReports;
  final Map<int, int> ratingDistribution;
  final Map<String, int> reviewsByType;
  final Map<String, int> reviewsByTargetType;
  final DateTime lastReviewDate;
  final DateTime generatedAt;

  const UserReviewStatsEntity({
    required this.userId,
    required this.totalReviews,
    required this.approvedReviews,
    required this.rejectedReviews,
    required this.pendingReviews,
    required this.averageRating,
    required this.totalHelpfulVotes,
    required this.totalReports,
    required this.ratingDistribution,
    required this.reviewsByType,
    required this.reviewsByTargetType,
    required this.lastReviewDate,
    required this.generatedAt,
  });

  double get approvalRate => totalReviews > 0
      ? (approvedReviews / totalReviews) * 100
      : 0.0;

  @override
  List<Object?> get props => [
        userId,
        totalReviews,
        approvedReviews,
        rejectedReviews,
        pendingReviews,
        averageRating,
        totalHelpfulVotes,
        totalReports,
        ratingDistribution,
        reviewsByType,
        reviewsByTargetType,
        lastReviewDate,
        generatedAt,
      ];
}

class ImportReviewsRequest {
  final List<ReviewEntity> reviews;
  final bool skipDuplicates;
  final bool updateExisting;
  final String? source;

  const ImportReviewsRequest({
    required this.reviews,
    this.skipDuplicates = true,
    this.updateExisting = false,
    this.source,
  });
}

class ExportReviewsRequest {
  final ReviewTargetType? targetType;
  final String? targetId;
  final ReviewStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String format;
  final List<String> fields;

  const ExportReviewsRequest({
    this.targetType,
    this.targetId,
    this.status,
    this.startDate,
    this.endDate,
    this.format = 'csv',
    this.fields = const [],
  });
}

class ReviewSummaryEntity extends Equatable {
  final String targetId;
  final ReviewTargetType targetType;
  final int totalReviews;
  final double averageRating;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;
  final List<String> topPositiveKeywords;
  final List<String> topNegativeKeywords;
  final List<String> topAspects;
  final DateTime lastUpdated;

  const ReviewSummaryEntity({
    required this.targetId,
    required this.targetType,
    required this.totalReviews,
    required this.averageRating,
    required this.fiveStarCount,
    required this.fourStarCount,
    required this.threeStarCount,
    required this.twoStarCount,
    required this.oneStarCount,
    required this.topPositiveKeywords,
    required this.topNegativeKeywords,
    required this.topAspects,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        targetId,
        targetType,
        totalReviews,
        averageRating,
        fiveStarCount,
        fourStarCount,
        threeStarCount,
        twoStarCount,
        oneStarCount,
        topPositiveKeywords,
        topNegativeKeywords,
        topAspects,
        lastUpdated,
      ];
}
