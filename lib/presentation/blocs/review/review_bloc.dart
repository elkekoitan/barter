import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/review_repository.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewBloc({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository,
        super(ReviewInitial()) {
    on<GetReviewsRequested>(_onGetReviewsRequested);
    on<GetReviewByIdRequested>(_onGetReviewByIdRequested);
    on<CreateReviewRequested>(_onCreateReviewRequested);
    on<UpdateReviewRequested>(_onUpdateReviewRequested);
    on<DeleteReviewRequested>(_onDeleteReviewRequested);
    on<ApproveReviewRequested>(_onApproveReviewRequested);
    on<RejectReviewRequested>(_onRejectReviewRequested);
    on<FlagReviewRequested>(_onFlagReviewRequested);
    on<HideReviewRequested>(_onHideReviewRequested);
    on<UnhideReviewRequested>(_onUnhideReviewRequested);
    on<AddReviewResponseRequested>(_onAddReviewResponseRequested);
    on<RemoveReviewResponseRequested>(_onRemoveReviewResponseRequested);
    on<MarkReviewHelpfulRequested>(_onMarkReviewHelpfulRequested);
    on<MarkReviewNotHelpfulRequested>(_onMarkReviewNotHelpfulRequested);
    on<ReportReviewRequested>(_onReportReviewRequested);
    on<GetRatingRequested>(_onGetRatingRequested);
    on<GetOrCreateRatingRequested>(_onGetOrCreateRatingRequested);
    on<UpdateRatingRequested>(_onUpdateRatingRequested);
    on<GetRatingsByUserRequested>(_onGetRatingsByUserRequested);
    on<GetTopRatedRequested>(_onGetTopRatedRequested);
    on<GetUserReputationRequested>(_onGetUserReputationRequested);
    on<UpdateUserReputationRequested>(_onUpdateUserReputationRequested);
    on<RecalculateUserReputationRequested>(_onRecalculateUserReputationRequested);
    on<GetTopReputationsRequested>(_onGetTopReputationsRequested);
    on<AwardReputationBadgeRequested>(_onAwardReputationBadgeRequested);
    on<RevokeReputationBadgeRequested>(_onRevokeReputationBadgeRequested);
    on<GetReviewAnalyticsRequested>(_onGetReviewAnalyticsRequested);
    on<GetReviewAnalyticsByPeriodRequested>(_onGetReviewAnalyticsByPeriodRequested);
    on<GetReviewInsightsRequested>(_onGetReviewInsightsRequested);
    on<GetReviewsForModerationRequested>(_onGetReviewsForModerationRequested);
    on<GetReviewModerationHistoryRequested>(_onGetReviewModerationHistoryRequested);
    on<GetModerationHistoryByModeratorRequested>(_onGetModerationHistoryByModeratorRequested);
    on<ModerateReviewRequested>(_onModerateReviewRequested);
    on<BulkApproveReviewsRequested>(_onBulkApproveReviewsRequested);
    on<BulkRejectReviewsRequested>(_onBulkRejectReviewsRequested);
    on<BulkDeleteReviewsRequested>(_onBulkDeleteReviewsRequested);
    on<BulkHideReviewsRequested>(_onBulkHideReviewsRequested);
    on<GetReviewSettingsRequested>(_onGetReviewSettingsRequested);
    on<UpdateReviewSettingsRequested>(_onUpdateReviewSettingsRequested);
    on<SearchReviewsRequested>(_onSearchReviewsRequested);
    on<GetReviewsByKeywordRequested>(_onGetReviewsByKeywordRequested);
    on<GetReviewStatsRequested>(_onGetReviewStatsRequested);
    on<GetUserReviewStatsRequested>(_onGetUserReviewStatsRequested);
    on<GetReviewSuggestionsRequested>(_onGetReviewSuggestionsRequested);
    on<ImportReviewsRequested>(_onImportReviewsRequested);
    on<ExportReviewsRequested>(_onExportReviewsRequested);
    on<CleanupOldReviewsRequested>(_onCleanupOldReviewsRequested);
    on<RefreshReviewCacheRequested>(_onRefreshReviewCacheRequested);
    on<RefreshReviewsRequested>(_onRefreshReviewsRequested);
    on<LoadMoreReviewsRequested>(_onLoadMoreReviewsRequested);
    on<ChangeReviewFilterRequested>(_onChangeReviewFilterRequested);
    on<ChangeRatingSortRequested>(_onChangeRatingSortRequested);
    on<ToggleHelpfulRequested>(_onToggleHelpfulRequested);
    on<ReviewsUpdated>(_onReviewsUpdated);
    on<RatingUpdated>(_onRatingUpdated);
    on<ReputationUpdated>(_onReputationUpdated);
    on<ModerationQueueUpdated>(_onModerationQueueUpdated);
  }

  Future<void> _onGetReviewsRequested(
    GetReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewsLoading());

    final result = await _reviewRepository.getReviews(
      targetId: event.targetId,
      targetType: event.targetType,
      reviewerId: event.reviewerId,
      revieweeId: event.revieweeId,
      status: event.status,
      type: event.type,
      minRating: event.minRating,
      maxRating: event.maxRating,
      isVerified: event.isVerified,
      startDate: event.startDate,
      endDate: event.endDate,
      page: event.page,
      limit: event.limit,
      sortBy: event.sortBy,
      sortDescending: event.sortDescending,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewsLoaded(
        reviews: reviews,
        currentPage: event.page,
        hasMore: reviews.length == event.limit,
        totalCount: reviews.length,
      )),
    );
  }

  Future<void> _onGetReviewByIdRequested(
    GetReviewByIdRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _reviewRepository.getReviewById(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewLoaded(review)),
    );
  }

  Future<void> _onCreateReviewRequested(
    CreateReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _reviewRepository.createReview(event.request);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewCreated(review)),
    );
  }

  Future<void> _onUpdateReviewRequested(
    UpdateReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.updateReview(event.reviewId, event.request);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewUpdated(review)),
    );
  }

  Future<void> _onDeleteReviewRequested(
    DeleteReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.deleteReview(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewDeleted(event.reviewId)),
    );
  }

  Future<void> _onApproveReviewRequested(
    ApproveReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.approveReview(event.reviewId, event.moderatorNotes);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewApproved(event.reviewId)),
    );
  }

  Future<void> _onRejectReviewRequested(
    RejectReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.rejectReview(event.reviewId, event.reason, event.moderatorNotes);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewRejected(event.reviewId)),
    );
  }

  Future<void> _onFlagReviewRequested(
    FlagReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.flagReview(event.reviewId, event.reason);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewFlagged(event.reviewId)),
    );
  }

  Future<void> _onHideReviewRequested(
    HideReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.hideReview(event.reviewId, event.reason);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewHidden(event.reviewId)),
    );
  }

  Future<void> _onUnhideReviewRequested(
    UnhideReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.unhideReview(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewUnhidden(event.reviewId)),
    );
  }

  Future<void> _onAddReviewResponseRequested(
    AddReviewResponseRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.addReviewResponse(event.reviewId, event.request);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewResponseAdded(review)),
    );
  }

  Future<void> _onRemoveReviewResponseRequested(
    RemoveReviewResponseRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.removeReviewResponse(event.reviewId, event.responseId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewResponseRemoved(event.reviewId, event.responseId)),
    );
  }

  Future<void> _onMarkReviewHelpfulRequested(
    MarkReviewHelpfulRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.markReviewHelpful(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewMarkedHelpful(event.reviewId)),
    );
  }

  Future<void> _onMarkReviewNotHelpfulRequested(
    MarkReviewNotHelpfulRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.markReviewNotHelpful(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewMarkedNotHelpful(event.reviewId)),
    );
  }

  Future<void> _onReportReviewRequested(
    ReportReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.reportReview(event.reviewId, event.request);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewReported(event.reviewId)),
    );
  }

  Future<void> _onGetRatingRequested(
    GetRatingRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(RatingsLoading());

    final result = await _reviewRepository.getRating(
      targetId: event.targetId,
      targetType: event.targetType,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (rating) => emit(RatingLoaded(rating)),
    );
  }

  Future<void> _onGetOrCreateRatingRequested(
    GetOrCreateRatingRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(RatingsLoading());

    final result = await _reviewRepository.getOrCreateRating(
      targetId: event.targetId,
      targetType: event.targetType,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (rating) => emit(RatingLoaded(rating)),
    );
  }

  Future<void> _onUpdateRatingRequested(
    UpdateRatingRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.updateRating(
      event.targetId,
      event.targetType,
      event.rating,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(RatingUpdated(event.targetId, event.targetType)),
    );
  }

  Future<void> _onGetRatingsByUserRequested(
    GetRatingsByUserRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.getRatingsByUser(event.userId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (ratings) => emit(RatingsByUserLoaded(ratings)),
    );
  }

  Future<void> _onGetTopRatedRequested(
    GetTopRatedRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.getTopRated(
      targetType: event.targetType,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (ratings) => emit(TopRatedLoaded(ratings)),
    );
  }

  Future<void> _onGetUserReputationRequested(
    GetUserReputationRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReputationLoading());

    final result = await _reviewRepository.getUserReputation(event.userId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reputation) => emit(UserReputationLoaded(reputation)),
    );
  }

  Future<void> _onUpdateUserReputationRequested(
    UpdateUserReputationRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.updateUserReputation(event.userId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reputation) => emit(UserReputationUpdated(reputation)),
    );
  }

  Future<void> _onRecalculateUserReputationRequested(
    RecalculateUserReputationRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.recalculateUserReputation(event.userId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(UserReputationRecalculated(event.userId)),
    );
  }

  Future<void> _onGetTopReputationsRequested(
    GetTopReputationsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.getTopReputations(
      limit: event.limit,
      minTier: event.minTier,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reputations) => emit(TopReputationsLoaded(reputations)),
    );
  }

  Future<void> _onAwardReputationBadgeRequested(
    AwardReputationBadgeRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.awardReputationBadge(event.userId, event.badge);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReputationBadgeAwarded(event.userId, event.badge)),
    );
  }

  Future<void> _onRevokeReputationBadgeRequested(
    RevokeReputationBadgeRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.revokeReputationBadge(event.userId, event.badgeId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReputationBadgeRevoked(event.userId, event.badgeId)),
    );
  }

  Future<void> _onGetReviewAnalyticsRequested(
    GetReviewAnalyticsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await _reviewRepository.getReviewAnalytics(
      period: event.period,
      startDate: event.startDate,
      endDate: event.endDate,
      category: event.category,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (analytics) => emit(ReviewAnalyticsLoaded(analytics)),
    );
  }

  Future<void> _onGetReviewAnalyticsByPeriodRequested(
    GetReviewAnalyticsByPeriodRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await _reviewRepository.getReviewAnalyticsByPeriod(event.startDate, event.endDate);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (analytics) => emit(ReviewAnalyticsByPeriodLoaded(analytics)),
    );
  }

  Future<void> _onGetReviewInsightsRequested(
    GetReviewInsightsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.getReviewInsights(event.targetId, event.targetType);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (insights) => emit(ReviewInsightsLoaded(insights)),
    );
  }

  Future<void> _onGetReviewsForModerationRequested(
    GetReviewsForModerationRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ModerationLoading());

    final result = await _reviewRepository.getReviewsForModeration(
      status: event.status,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewsForModerationLoaded(
        reviews: reviews,
        currentPage: event.page,
        hasMore: reviews.length == event.limit,
        totalCount: reviews.length,
      )),
    );
  }

  Future<void> _onGetReviewModerationHistoryRequested(
    GetReviewModerationHistoryRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.getReviewModerationHistory(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (history) => emit(ReviewModerationHistoryLoaded(history)),
    );
  }

  Future<void> _onGetModerationHistoryByModeratorRequested(
    GetModerationHistoryByModeratorRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.getModerationHistoryByModerator(event.moderatorId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (history) => emit(ModerationHistoryByModeratorLoaded(history)),
    );
  }

  Future<void> _onModerateReviewRequested(
    ModerateReviewRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.moderateReview(
      event.reviewId,
      event.action,
      event.reason,
      event.notes,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewModerated(event.reviewId, event.action)),
    );
  }

  Future<void> _onBulkApproveReviewsRequested(
    BulkApproveReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.bulkApproveReviews(event.reviewIds);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewsBulkApproved(event.reviewIds)),
    );
  }

  Future<void> _onBulkRejectReviewsRequested(
    BulkRejectReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.bulkRejectReviews(event.reviewIds, event.reason);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewsBulkRejected(event.reviewIds)),
    );
  }

  Future<void> _onBulkDeleteReviewsRequested(
    BulkDeleteReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.bulkDeleteReviews(event.reviewIds, event.reason);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewsBulkDeleted(event.reviewIds)),
    );
  }

  Future<void> _onBulkHideReviewsRequested(
    BulkHideReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.bulkHideReviews(event.reviewIds, event.reason);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewsBulkHidden(event.reviewIds)),
    );
  }

  Future<void> _onGetReviewSettingsRequested(
    GetReviewSettingsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    final result = await _reviewRepository.getReviewSettings();

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (settings) => emit(ReviewSettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateReviewSettingsRequested(
    UpdateReviewSettingsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.updateReviewSettings(event.request);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (settings) => emit(ReviewSettingsUpdated(settings)),
    );
  }

  Future<void> _onSearchReviewsRequested(
    SearchReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewsLoading());

    final result = await _reviewRepository.searchReviews(event.request);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewsSearched(
        reviews: reviews,
        query: event.request.query,
        currentPage: event.request.page,
        hasMore: reviews.length == event.request.limit,
        totalCount: reviews.length,
      )),
    );
  }

  Future<void> _onGetReviewsByKeywordRequested(
    GetReviewsByKeywordRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewsLoading());

    final result = await _reviewRepository.getReviewsByKeyword(
      event.keyword,
      targetType: event.targetType,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewsByKeywordLoaded(
        reviews: reviews,
        keyword: event.keyword,
        currentPage: event.page,
        hasMore: reviews.length == event.limit,
        totalCount: reviews.length,
      )),
    );
  }

  Future<void> _onGetReviewStatsRequested(
    GetReviewStatsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await _reviewRepository.getReviewStats(
      startDate: event.startDate,
      endDate: event.endDate,
      category: event.category,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (stats) => emit(ReviewStatsLoaded(stats)),
    );
  }

  Future<void> _onGetUserReviewStatsRequested(
    GetUserReviewStatsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.getUserReviewStats(event.userId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (stats) => emit(UserReviewStatsLoaded(stats)),
    );
  }

  Future<void> _onGetReviewSuggestionsRequested(
    GetReviewSuggestionsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.getReviewSuggestions(event.userId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (suggestions) => emit(ReviewSuggestionsLoaded(suggestions)),
    );
  }

  Future<void> _onImportReviewsRequested(
    ImportReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.importReviews(event.request);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewsImported(event.request.reviews.length)),
    );
  }

  Future<void> _onExportReviewsRequested(
    ExportReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.exportReviews(event.request);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewsExported('export_${DateTime.now().millisecondsSinceEpoch}')),
    );
  }

  Future<void> _onCleanupOldReviewsRequested(
    CleanupOldReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.cleanupOldReviews(event.daysOld);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(OldReviewsCleaned(event.daysOld)),
    );
  }

  Future<void> _onRefreshReviewCacheRequested(
    RefreshReviewCacheRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await _reviewRepository.refreshReviewCache(event.targetId, event.targetType);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewCacheRefreshed(event.targetId, event.targetType)),
    );
  }

  Future<void> _onRefreshReviewsRequested(
    RefreshReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewInitial());
  }

  Future<void> _onLoadMoreReviewsRequested(
    LoadMoreReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is ReviewsLoaded) {
      final currentState = state as ReviewsLoaded;
      emit(ReviewsLoading(isLoadMore: true));

      final result = await _reviewRepository.getReviews(
        targetId: event.targetId,
        targetType: event.targetType,
        page: currentState.currentPage + 1,
        limit: 20,
      );

      result.fold(
        (failure) => emit(ReviewError(failure.message)),
        (reviews) => emit(ReviewsLoaded(
          reviews: [...currentState.reviews, ...reviews],
          currentPage: currentState.currentPage + 1,
          hasMore: reviews.length == 20,
          totalCount: currentState.totalCount + reviews.length,
        )),
      );
    }
  }

  Future<void> _onChangeReviewFilterRequested(
    ChangeReviewFilterRequested event,
    Emitter<ReviewState> emit,
  ) async {
    // TODO: Apply filter to current reviews
    debugPrint('Changed review filter to: ${event.filter.value}');
  }

  Future<void> _onChangeRatingSortRequested(
    ChangeRatingSortRequested event,
    Emitter<ReviewState> emit,
  ) async {
    // TODO: Sort current reviews
    debugPrint('Changed rating sort to: ${event.sort.value}');
  }

  Future<void> _onToggleHelpfulRequested(
    ToggleHelpfulRequested event,
    Emitter<ReviewState> emit,
  ) async {
    final result = event.isHelpful
        ? await _reviewRepository.markReviewHelpful(event.reviewId)
        : await _reviewRepository.markReviewNotHelpful(event.reviewId);

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => event.isHelpful
          ? emit(ReviewMarkedHelpful(event.reviewId))
          : emit(ReviewMarkedNotHelpful(event.reviewId)),
    );
  }

  Future<void> _onReviewsUpdated(
    ReviewsUpdated event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewsUpdatedInRealTime(event.targetId, event.targetType, event.reviews));
  }

  Future<void> _onRatingUpdated(
    RatingUpdated event,
    Emitter<ReviewState> emit,
  ) async {
    emit(RatingUpdatedInRealTime(event.targetId, event.targetType, event.rating));
  }

  Future<void> _onReputationUpdated(
    ReputationUpdated event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReputationUpdatedInRealTime(event.userId, event.reputation));
  }

  Future<void> _onModerationQueueUpdated(
    ModerationQueueUpdated event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ModerationQueueUpdatedInRealTime(event.reviews));
  }

  // Helper methods
  void refreshAllData() {
    add(const GetReviewsRequested());
    add(const GetReviewStatsRequested());
    add(const GetTopRatedRequested());
    add(const GetTopReputationsRequested());
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
