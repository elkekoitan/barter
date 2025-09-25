import 'package:equatable/equatable.dart';
import '../../../domain/repositories/review_repository.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

// Review Events
class GetReviewsRequested extends ReviewEvent {
  final String? targetId;
  final ReviewTargetType? targetType;
  final String? reviewerId;
  final String? revieweeId;
  final ReviewStatus? status;
  final ReviewType? type;
  final int? minRating;
  final int? maxRating;
  final bool? isVerified;
  final DateTime? startDate;
  final DateTime? endDate;
  final int page;
  final int limit;
  final String? sortBy;
  final bool sortDescending;

  const GetReviewsRequested({
    this.targetId,
    this.targetType,
    this.reviewerId,
    this.revieweeId,
    this.status,
    this.type,
    this.minRating,
    this.maxRating,
    this.isVerified,
    this.startDate,
    this.endDate,
    this.page = 1,
    this.limit = 20,
    this.sortBy,
    this.sortDescending = true,
  });

  @override
  List<Object?> get props => [
        targetId,
        targetType,
        reviewerId,
        revieweeId,
        status,
        type,
        minRating,
        maxRating,
        isVerified,
        startDate,
        endDate,
        page,
        limit,
        sortBy,
        sortDescending,
      ];
}

class GetReviewByIdRequested extends ReviewEvent {
  final String reviewId;

  const GetReviewByIdRequested(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class CreateReviewRequested extends ReviewEvent {
  final CreateReviewRequest request;

  const CreateReviewRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateReviewRequested extends ReviewEvent {
  final String reviewId;
  final UpdateReviewRequest request;

  const UpdateReviewRequested(this.reviewId, this.request);

  @override
  List<Object?> get props => [reviewId, request];
}

class DeleteReviewRequested extends ReviewEvent {
  final String reviewId;

  const DeleteReviewRequested(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ApproveReviewRequested extends ReviewEvent {
  final String reviewId;
  final String moderatorNotes;

  const ApproveReviewRequested(this.reviewId, this.moderatorNotes);

  @override
  List<Object?> get props => [reviewId, moderatorNotes];
}

class RejectReviewRequested extends ReviewEvent {
  final String reviewId;
  final String reason;
  final String moderatorNotes;

  const RejectReviewRequested(this.reviewId, this.reason, this.moderatorNotes);

  @override
  List<Object?> get props => [reviewId, reason, moderatorNotes];
}

class FlagReviewRequested extends ReviewEvent {
  final String reviewId;
  final String reason;

  const FlagReviewRequested(this.reviewId, this.reason);

  @override
  List<Object?> get props => [reviewId, reason];
}

class HideReviewRequested extends ReviewEvent {
  final String reviewId;
  final String reason;

  const HideReviewRequested(this.reviewId, this.reason);

  @override
  List<Object?> get props => [reviewId, reason];
}

class UnhideReviewRequested extends ReviewEvent {
  final String reviewId;

  const UnhideReviewRequested(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class AddReviewResponseRequested extends ReviewEvent {
  final String reviewId;
  final AddReviewResponseRequest request;

  const AddReviewResponseRequested(this.reviewId, this.request);

  @override
  List<Object?> get props => [reviewId, request];
}

class RemoveReviewResponseRequested extends ReviewEvent {
  final String reviewId;
  final String responseId;

  const RemoveReviewResponseRequested(this.reviewId, this.responseId);

  @override
  List<Object?> get props => [reviewId, responseId];
}

class MarkReviewHelpfulRequested extends ReviewEvent {
  final String reviewId;

  const MarkReviewHelpfulRequested(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class MarkReviewNotHelpfulRequested extends ReviewEvent {
  final String reviewId;

  const MarkReviewNotHelpfulRequested(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReportReviewRequested extends ReviewEvent {
  final String reviewId;
  final ReportReviewRequest request;

  const ReportReviewRequested(this.reviewId, this.request);

  @override
  List<Object?> get props => [reviewId, request];
}

// Rating Events
class GetRatingRequested extends ReviewEvent {
  final String targetId;
  final ReviewTargetType targetType;

  const GetRatingRequested(this.targetId, this.targetType);

  @override
  List<Object?> get props => [targetId, targetType];
}

class GetOrCreateRatingRequested extends ReviewEvent {
  final String targetId;
  final ReviewTargetType targetType;

  const GetOrCreateRatingRequested(this.targetId, this.targetType);

  @override
  List<Object?> get props => [targetId, targetType];
}

class UpdateRatingRequested extends ReviewEvent {
  final String targetId;
  final ReviewTargetType targetType;
  final int rating;

  const UpdateRatingRequested(this.targetId, this.targetType, this.rating);

  @override
  List<Object?> get props => [targetId, targetType, rating];
}

class GetRatingsByUserRequested extends ReviewEvent {
  final String userId;

  const GetRatingsByUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetTopRatedRequested extends ReviewEvent {
  final ReviewTargetType? targetType;
  final int limit;

  const GetTopRatedRequested({this.targetType, this.limit = 10});

  @override
  List<Object?> get props => [targetType, limit];
}

// Reputation Events
class GetUserReputationRequested extends ReviewEvent {
  final String userId;

  const GetUserReputationRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserReputationRequested extends ReviewEvent {
  final String userId;

  const UpdateUserReputationRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RecalculateUserReputationRequested extends ReviewEvent {
  final String userId;

  const RecalculateUserReputationRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetTopReputationsRequested extends ReviewEvent {
  final int limit;
  final ReputationTier? minTier;

  const GetTopReputationsRequested({this.limit = 20, this.minTier});

  @override
  List<Object?> get props => [limit, minTier];
}

class AwardReputationBadgeRequested extends ReviewEvent {
  final String userId;
  final ReputationBadge badge;

  const AwardReputationBadgeRequested(this.userId, this.badge);

  @override
  List<Object?> get props => [userId, badge];
}

class RevokeReputationBadgeRequested extends ReviewEvent {
  final String userId;
  final String badgeId;

  const RevokeReputationBadgeRequested(this.userId, this.badgeId);

  @override
  List<Object?> get props => [userId, badgeId];
}

// Analytics Events
class GetReviewAnalyticsRequested extends ReviewEvent {
  final ReviewAnalyticsPeriod? period;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? category;

  const GetReviewAnalyticsRequested({
    this.period,
    this.startDate,
    this.endDate,
    this.category,
  });

  @override
  List<Object?> get props => [period, startDate, endDate, category];
}

class GetReviewAnalyticsByPeriodRequested extends ReviewEvent {
  final DateTime startDate;
  final DateTime endDate;

  const GetReviewAnalyticsByPeriodRequested(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetReviewInsightsRequested extends ReviewEvent {
  final String targetId;
  final ReviewTargetType targetType;

  const GetReviewInsightsRequested(this.targetId, this.targetType);

  @override
  List<Object?> get props => [targetId, targetType];
}

// Moderation Events
class GetReviewsForModerationRequested extends ReviewEvent {
  final ReviewStatus? status;
  final int page;
  final int limit;

  const GetReviewsForModerationRequested({
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [status, page, limit];
}

class GetReviewModerationHistoryRequested extends ReviewEvent {
  final String reviewId;

  const GetReviewModerationHistoryRequested(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class GetModerationHistoryByModeratorRequested extends ReviewEvent {
  final String moderatorId;

  const GetModerationHistoryByModeratorRequested(this.moderatorId);

  @override
  List<Object?> get props => [moderatorId];
}

class ModerateReviewRequested extends ReviewEvent {
  final String reviewId;
  final ModerationAction action;
  final String reason;
  final String notes;

  const ModerateReviewRequested(this.reviewId, this.action, this.reason, this.notes);

  @override
  List<Object?> get props => [reviewId, action, reason, notes];
}

// Bulk Operations Events
class BulkApproveReviewsRequested extends ReviewEvent {
  final List<String> reviewIds;

  const BulkApproveReviewsRequested(this.reviewIds);

  @override
  List<Object?> get props => [reviewIds];
}

class BulkRejectReviewsRequested extends ReviewEvent {
  final List<String> reviewIds;
  final String reason;

  const BulkRejectReviewsRequested(this.reviewIds, this.reason);

  @override
  List<Object?> get props => [reviewIds, reason];
}

class BulkDeleteReviewsRequested extends ReviewEvent {
  final List<String> reviewIds;
  final String reason;

  const BulkDeleteReviewsRequested(this.reviewIds, this.reason);

  @override
  List<Object?> get props => [reviewIds, reason];
}

class BulkHideReviewsRequested extends ReviewEvent {
  final List<String> reviewIds;
  final String reason;

  const BulkHideReviewsRequested(this.reviewIds, this.reason);

  @override
  List<Object?> get props => [reviewIds, reason];
}

// Settings Events
class GetReviewSettingsRequested extends ReviewEvent {}

class UpdateReviewSettingsRequested extends ReviewEvent {
  final UpdateReviewSettingsRequest request;

  const UpdateReviewSettingsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// Search Events
class SearchReviewsRequested extends ReviewEvent {
  final ReviewSearchRequest request;

  const SearchReviewsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetReviewsByKeywordRequested extends ReviewEvent {
  final String keyword;
  final ReviewTargetType? targetType;
  final int page;
  final int limit;

  const GetReviewsByKeywordRequested({
    required this.keyword,
    this.targetType,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [keyword, targetType, page, limit];
}

// Statistics Events
class GetReviewStatsRequested extends ReviewEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? category;

  const GetReviewStatsRequested({
    this.startDate,
    this.endDate,
    this.category,
  });

  @override
  List<Object?> get props => [startDate, endDate, category];
}

class GetUserReviewStatsRequested extends ReviewEvent {
  final String userId;

  const GetUserReviewStatsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Advanced Features Events
class GetReviewSuggestionsRequested extends ReviewEvent {
  final String userId;

  const GetReviewSuggestionsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ImportReviewsRequested extends ReviewEvent {
  final ImportReviewsRequest request;

  const ImportReviewsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class ExportReviewsRequested extends ReviewEvent {
  final ExportReviewsRequest request;

  const ExportReviewsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class CleanupOldReviewsRequested extends ReviewEvent {
  final int daysOld;

  const CleanupOldReviewsRequested(this.daysOld);

  @override
  List<Object?> get props => [daysOld];
}

class RefreshReviewCacheRequested extends ReviewEvent {
  final String targetId;
  final ReviewTargetType targetType;

  const RefreshReviewCacheRequested(this.targetId, this.targetType);

  @override
  List<Object?> get props => [targetId, targetType];
}

// UI Events
class RefreshReviewsRequested extends ReviewEvent {}

class LoadMoreReviewsRequested extends ReviewEvent {
  final String? targetId;
  final ReviewTargetType? targetType;

  const LoadMoreReviewsRequested({this.targetId, this.targetType});

  @override
  List<Object?> get props => [targetId, targetType];
}

class ChangeReviewFilterRequested extends ReviewEvent {
  final ReviewFilter filter;

  const ChangeReviewFilterRequested(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ChangeRatingSortRequested extends ReviewEvent {
  final RatingSort sort;

  const ChangeRatingSortRequested(this.sort);

  @override
  List<Object?> get props => [sort];
}

class ToggleHelpfulRequested extends ReviewEvent {
  final String reviewId;
  final bool isHelpful;

  const ToggleHelpfulRequested(this.reviewId, this.isHelpful);

  @override
  List<Object?> get props => [reviewId, isHelpful];
}

// Real-time Events
class ReviewsUpdated extends ReviewEvent {
  final String targetId;
  final ReviewTargetType targetType;
  final List<ReviewEntity> reviews;

  const ReviewsUpdated(this.targetId, this.targetType, this.reviews);

  @override
  List<Object?> get props => [targetId, targetType, reviews];
}

class RatingUpdated extends ReviewEvent {
  final String targetId;
  final ReviewTargetType targetType;
  final RatingEntity rating;

  const RatingUpdated(this.targetId, this.targetType, this.rating);

  @override
  List<Object?> get props => [targetId, targetType, rating];
}

class ReputationUpdated extends ReviewEvent {
  final String userId;
  final ReputationEntity reputation;

  const ReputationUpdated(this.userId, this.reputation);

  @override
  List<Object?> get props => [userId, reputation];
}

class ModerationQueueUpdated extends ReviewEvent {
  final List<ReviewEntity> reviews;

  const ModerationQueueUpdated(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

enum ReviewFilter {
  all('all', 'Tümü'),
  verified('verified', 'Doğrulanmış'),
  unverified('unverified', 'Doğrulanmamış'),
  positive('positive', 'Pozitif'),
  negative('negative', 'Negatif'),
  recent('recent', 'Son'),
  helpful('helpful', 'Yararlı'),
  reported('reported', 'Bildirilen');

  const ReviewFilter(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum RatingSort {
  highest('highest', 'En Yüksek'),
  lowest('lowest', 'En Düşük'),
  newest('newest', 'En Yeni'),
  oldest('oldest', 'En Eski'),
  mostHelpful('most_helpful', 'En Yararlı'),
  mostReviews('most_reviews', 'En Çok İnceleme');

  const RatingSort(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ReviewTabType {
  reviews('reviews', 'İncelemeler'),
  ratings('ratings', 'Değerlendirmeler'),
  reputation('reputation', 'İtibar'),
  analytics('analytics', 'Analitik'),
  moderation('moderation', 'Moderatörlük');

  const ReviewTabType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ReviewSortOption {
  newest('newest', 'En Yeni'),
  oldest('oldest', 'En Eski'),
  highestRated('highest_rated', 'En Yüksek Puanlı'),
  lowestRated('lowest_rated', 'En Düşük Puanlı'),
  mostHelpful('most_helpful', 'En Yararlı'),
  mostReported('most_reported', 'En Çok Bildirilen');

  const ReviewSortOption(this.value, this.displayName);
  final String value;
  final String displayName;
}
