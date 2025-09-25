import 'package:equatable/equatable.dart';
import '../../../domain/entities/review.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoading extends ReviewState {
  final bool isLoadMore;

  const ReviewsLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class RatingsLoading extends ReviewState {}

class ReputationLoading extends ReviewState {}

class AnalyticsLoading extends ReviewState {}

class ModerationLoading extends ReviewState {}

// Success States
class ReviewsLoaded extends ReviewState {
  final List<ReviewEntity> reviews;
  final bool hasMore;
  final int currentPage;
  final int totalCount;
  final ReviewFilter? filter;
  final ReviewSortOption? sortOption;

  const ReviewsLoaded({
    required this.reviews,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
    this.filter,
    this.sortOption,
  });

  @override
  List<Object?> get props => [reviews, hasMore, currentPage, totalCount, filter, sortOption];
}

class ReviewLoaded extends ReviewState {
  final ReviewEntity review;

  const ReviewLoaded(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewCreated extends ReviewState {
  final ReviewEntity review;

  const ReviewCreated(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewUpdated extends ReviewState {
  final ReviewEntity review;

  const ReviewUpdated(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewDeleted extends ReviewState {
  final String reviewId;

  const ReviewDeleted(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewApproved extends ReviewState {
  final String reviewId;

  const ReviewApproved(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewRejected extends ReviewState {
  final String reviewId;

  const ReviewRejected(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewFlagged extends ReviewState {
  final String reviewId;

  const ReviewFlagged(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewHidden extends ReviewState {
  final String reviewId;

  const ReviewHidden(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewUnhidden extends ReviewState {
  final String reviewId;

  const ReviewUnhidden(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewResponseAdded extends ReviewState {
  final ReviewEntity review;

  const ReviewResponseAdded(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewResponseRemoved extends ReviewState {
  final String reviewId;
  final String responseId;

  const ReviewResponseRemoved(this.reviewId, this.responseId);

  @override
  List<Object?> get props => [reviewId, responseId];
}

class ReviewMarkedHelpful extends ReviewState {
  final String reviewId;

  const ReviewMarkedHelpful(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewMarkedNotHelpful extends ReviewState {
  final String reviewId;

  const ReviewMarkedNotHelpful(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewReported extends ReviewState {
  final String reviewId;

  const ReviewReported(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class RatingLoaded extends ReviewState {
  final RatingEntity rating;

  const RatingLoaded(this.rating);

  @override
  List<Object?> get props => [rating];
}

class RatingUpdated extends ReviewState {
  final String targetId;
  final ReviewTargetType targetType;

  const RatingUpdated(this.targetId, this.targetType);

  @override
  List<Object?> get props => [targetId, targetType];
}

class RatingsByUserLoaded extends ReviewState {
  final List<RatingEntity> ratings;

  const RatingsByUserLoaded(this.ratings);

  @override
  List<Object?> get props => [ratings];
}

class TopRatedLoaded extends ReviewState {
  final List<RatingEntity> ratings;

  const TopRatedLoaded(this.ratings);

  @override
  List<Object?> get props => [ratings];
}

class UserReputationLoaded extends ReviewState {
  final ReputationEntity reputation;

  const UserReputationLoaded(this.reputation);

  @override
  List<Object?> get props => [reputation];
}

class UserReputationUpdated extends ReviewState {
  final ReputationEntity reputation;

  const UserReputationUpdated(this.reputation);

  @override
  List<Object?> get props => [reputation];
}

class UserReputationRecalculated extends ReviewState {
  final String userId;

  const UserReputationRecalculated(this.userId);

  @override
  List<Object?> get props => [userId];
}

class TopReputationsLoaded extends ReviewState {
  final List<ReputationEntity> reputations;

  const TopReputationsLoaded(this.reputations);

  @override
  List<Object?> get props => [reputations];
}

class ReputationBadgeAwarded extends ReviewState {
  final String userId;
  final ReputationBadge badge;

  const ReputationBadgeAwarded(this.userId, this.badge);

  @override
  List<Object?> get props => [userId, badge];
}

class ReputationBadgeRevoked extends ReviewState {
  final String userId;
  final String badgeId;

  const ReputationBadgeRevoked(this.userId, this.badgeId);

  @override
  List<Object?> get props => [userId, badgeId];
}

class ReviewAnalyticsLoaded extends ReviewState {
  final ReviewAnalyticsEntity analytics;

  const ReviewAnalyticsLoaded(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

class ReviewAnalyticsByPeriodLoaded extends ReviewState {
  final List<ReviewAnalyticsEntity> analytics;

  const ReviewAnalyticsByPeriodLoaded(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

class ReviewInsightsLoaded extends ReviewState {
  final Map<String, dynamic> insights;

  const ReviewInsightsLoaded(this.insights);

  @override
  List<Object?> get props => [insights];
}

class ReviewsForModerationLoaded extends ReviewState {
  final List<ReviewEntity> reviews;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const ReviewsForModerationLoaded({
    required this.reviews,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [reviews, hasMore, currentPage, totalCount];
}

class ReviewModerationHistoryLoaded extends ReviewState {
  final List<ReviewModerationEntity> history;

  const ReviewModerationHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class ModerationHistoryByModeratorLoaded extends ReviewState {
  final List<ReviewModerationEntity> history;

  const ModerationHistoryByModeratorLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class ReviewModerated extends ReviewState {
  final String reviewId;
  final ModerationAction action;

  const ReviewModerated(this.reviewId, this.action);

  @override
  List<Object?> get props => [reviewId, action];
}

class ReviewsBulkApproved extends ReviewState {
  final List<String> reviewIds;

  const ReviewsBulkApproved(this.reviewIds);

  @override
  List<Object?> get props => [reviewIds];
}

class ReviewsBulkRejected extends ReviewState {
  final List<String> reviewIds;

  const ReviewsBulkRejected(this.reviewIds);

  @override
  List<Object?> get props => [reviewIds];
}

class ReviewsBulkDeleted extends ReviewState {
  final List<String> reviewIds;

  const ReviewsBulkDeleted(this.reviewIds);

  @override
  List<Object?> get props => [reviewIds];
}

class ReviewsBulkHidden extends ReviewState {
  final List<String> reviewIds;

  const ReviewsBulkHidden(this.reviewIds);

  @override
  List<Object?> get props => [reviewIds];
}

class ReviewSettingsLoaded extends ReviewState {
  final ReviewSettingsEntity settings;

  const ReviewSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class ReviewSettingsUpdated extends ReviewState {
  final ReviewSettingsEntity settings;

  const ReviewSettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}

class ReviewsSearched extends ReviewState {
  final List<ReviewEntity> reviews;
  final String query;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const ReviewsSearched({
    required this.reviews,
    required this.query,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [reviews, query, hasMore, currentPage, totalCount];
}

class ReviewsByKeywordLoaded extends ReviewState {
  final List<ReviewEntity> reviews;
  final String keyword;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const ReviewsByKeywordLoaded({
    required this.reviews,
    required this.keyword,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [reviews, keyword, hasMore, currentPage, totalCount];
}

class ReviewStatsLoaded extends ReviewState {
  final ReviewStatsEntity stats;

  const ReviewStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class UserReviewStatsLoaded extends ReviewState {
  final UserReviewStatsEntity stats;

  const UserReviewStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ReviewSuggestionsLoaded extends ReviewState {
  final List<String> suggestions;

  const ReviewSuggestionsLoaded(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class ReviewsImported extends ReviewState {
  final int importedCount;

  const ReviewsImported(this.importedCount);

  @override
  List<Object?> get props => [importedCount];
}

class ReviewsExported extends ReviewState {
  final String exportId;

  const ReviewsExported(this.exportId);

  @override
  List<Object?> get props => [exportId];
}

class OldReviewsCleaned extends ReviewState {
  final int deletedCount;

  const OldReviewsCleaned(this.deletedCount);

  @override
  List<Object?> get props => [deletedCount];
}

class ReviewCacheRefreshed extends ReviewState {
  final String targetId;
  final ReviewTargetType targetType;

  const ReviewCacheRefreshed(this.targetId, this.targetType);

  @override
  List<Object?> get props => [targetId, targetType];
}

// Real-time States
class ReviewsUpdatedInRealTime extends ReviewState {
  final String targetId;
  final ReviewTargetType targetType;
  final List<ReviewEntity> reviews;

  const ReviewsUpdatedInRealTime(this.targetId, this.targetType, this.reviews);

  @override
  List<Object?> get props => [targetId, targetType, reviews];
}

class RatingUpdatedInRealTime extends ReviewState {
  final String targetId;
  final ReviewTargetType targetType;
  final RatingEntity rating;

  const RatingUpdatedInRealTime(this.targetId, this.targetType, this.rating);

  @override
  List<Object?> get props => [targetId, targetType, rating];
}

class ReputationUpdatedInRealTime extends ReviewState {
  final String userId;
  final ReputationEntity reputation;

  const ReputationUpdatedInRealTime(this.userId, this.reputation);

  @override
  List<Object?> get props => [userId, reputation];
}

class ModerationQueueUpdatedInRealTime extends ReviewState {
  final List<ReviewEntity> reviews;

  const ModerationQueueUpdatedInRealTime(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

// Error State
class ReviewError extends ReviewState {
  final String message;
  final String? code;
  final ReviewErrorType? errorType;

  const ReviewError(this.message, {this.code, this.errorType});

  @override
  List<Object?> get props => [message, code, errorType];
}

enum ReviewErrorType {
  network('network', 'Ağ Hatası'),
  validation('validation', 'Doğrulama Hatası'),
  permission('permission', 'İzin Hatası'),
  notFound('not_found', 'Bulunamadı'),
  duplicate('duplicate', 'Tekrarlanan'),
  moderation('moderation', 'Moderatörlük Hatası'),
  import('import', 'İçe Aktarma Hatası'),
  export('export', 'Dışa Aktarma Hatası'),
  unknown('unknown', 'Bilinmeyen Hata');

  const ReviewErrorType(this.value, this.displayName);
  final String value;
  final String displayName;
}

// UI State
class ReviewUIState extends ReviewState {
  final ReviewTabType currentTab;
  final ReviewFilter currentFilter;
  final RatingSort currentSort;
  final bool isLoading;
  final String? selectedTargetId;
  final ReviewTargetType? selectedTargetType;
  final Map<String, dynamic> uiSettings;

  const ReviewUIState({
    this.currentTab = ReviewTabType.reviews,
    this.currentFilter = ReviewFilter.all,
    this.currentSort = RatingSort.highest,
    this.isLoading = false,
    this.selectedTargetId,
    this.selectedTargetType,
    this.uiSettings = const {},
  });

  ReviewUIState copyWith({
    ReviewTabType? currentTab,
    ReviewFilter? currentFilter,
    RatingSort? currentSort,
    bool? isLoading,
    String? selectedTargetId,
    ReviewTargetType? selectedTargetType,
    Map<String, dynamic>? uiSettings,
  }) {
    return ReviewUIState(
      currentTab: currentTab ?? this.currentTab,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSort: currentSort ?? this.currentSort,
      isLoading: isLoading ?? this.isLoading,
      selectedTargetId: selectedTargetId ?? this.selectedTargetId,
      selectedTargetType: selectedTargetType ?? this.selectedTargetType,
      uiSettings: uiSettings ?? this.uiSettings,
    );
  }

  @override
  List<Object?> get props => [
        currentTab,
        currentFilter,
        currentSort,
        isLoading,
        selectedTargetId,
        selectedTargetType,
        uiSettings,
      ];
}

// Review Summary State
class ReviewSummaryState extends ReviewState {
  final ReviewSummaryEntity summary;
  final bool isLoading;

  const ReviewSummaryState({
    required this.summary,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [summary, isLoading];
}
