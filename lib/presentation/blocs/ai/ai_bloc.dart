import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/ai_repository.dart';
import 'ai_event.dart';
import 'ai_state.dart';

class AIBloc extends Bloc<AIEvent, AIState> {
  final AIRepository _aiRepository;

  AIBloc({required AIRepository aiRepository})
      : _aiRepository = aiRepository,
        super(AIInitial()) {
    on<GetMatchesRequested>(_onGetMatchesRequested);
    on<GetMatchByIdRequested>(_onGetMatchByIdRequested);
    on<GenerateMatchRequested>(_onGenerateMatchRequested);
    on<UpdateMatchRequested>(_onUpdateMatchRequested);
    on<DeleteMatchRequested>(_onDeleteMatchRequested);
    on<AcceptMatchRequested>(_onAcceptMatchRequested);
    on<RejectMatchRequested>(_onRejectMatchRequested);
    on<GetMatchesForUserRequested>(_onGetMatchesForUserRequested);
    on<GetUserPreferencesRequested>(_onGetUserPreferencesRequested);
    on<UpdateUserPreferencesRequested>(_onUpdateUserPreferencesRequested);
    on<ResetUserPreferencesRequested>(_onResetUserPreferencesRequested);
    on<GetRecommendationsRequested>(_onGetRecommendationsRequested);
    on<GenerateRecommendationsRequested>(_onGenerateRecommendationsRequested);
    on<MarkRecommendationAsViewedRequested>(_onMarkRecommendationAsViewedRequested);
    on<RateRecommendationRequested>(_onRateRecommendationRequested);
    on<GetAIModelsRequested>(_onGetAIModelsRequested);
    on<GetAIModelByIdRequested>(_onGetAIModelByIdRequested);
    on<CreateAIModelRequested>(_onCreateAIModelRequested);
    on<UpdateAIModelRequested>(_onUpdateAIModelRequested);
    on<DeleteAIModelRequested>(_onDeleteAIModelRequested);
    on<ActivateAIModelRequested>(_onActivateAIModelRequested);
    on<DeactivateAIModelRequested>(_onDeactivateAIModelRequested);
    on<GetTrainingDataRequested>(_onGetTrainingDataRequested);
    on<CreateTrainingDataRequested>(_onCreateTrainingDataRequested);
    on<UpdateTrainingDataRequested>(_onUpdateTrainingDataRequested);
    on<DeleteTrainingDataRequested>(_onDeleteTrainingDataRequested);
    on<StartTrainingRequested>(_onStartTrainingRequested);
    on<StopTrainingRequested>(_onStopTrainingRequested);
    on<GetMatchingRequestsRequested>(_onGetMatchingRequestsRequested);
    on<GetMatchingRequestByIdRequested>(_onGetMatchingRequestByIdRequested);
    on<CreateMatchingRequestRequested>(_onCreateMatchingRequestRequested);
    on<ProcessMatchingRequestRequested>(_onProcessMatchingRequestRequested);
    on<GetMatchingStatsRequested>(_onGetMatchingStatsRequested);
    on<GetMatchingStatsByPeriodRequested>(_onGetMatchingStatsByPeriodRequested);
    on<ProvideMatchFeedbackRequested>(_onProvideMatchFeedbackRequested);
    on<ReportIncorrectMatchRequested>(_onReportIncorrectMatchRequested);
    on<GetSimilarUserPreferencesRequested>(_onGetSimilarUserPreferencesRequested);
    on<GenerateBatchMatchesRequested>(_onGenerateBatchMatchesRequested);
    on<RetrainModelsRequested>(_onRetrainModelsRequested);
    on<GetSuggestedCategoriesRequested>(_onGetSuggestedCategoriesRequested);
    on<GetSuggestedBrandsRequested>(_onGetSuggestedBrandsRequested);
    on<GetSuggestedLocationsRequested>(_onGetSuggestedLocationsRequested);
    on<GetCompatibilityMatrixRequested>(_onGetCompatibilityMatrixRequested);
    on<RefreshUserPreferencesCacheRequested>(_onRefreshUserPreferencesCacheRequested);
    on<RefreshMatchingCacheRequested>(_onRefreshMatchingCacheRequested);
    on<ClearAICacheRequested>(_onClearAICacheRequested);
    on<RefreshAIMatchesRequested>(_onRefreshAIMatchesRequested);
    on<LoadMoreMatchesRequested>(_onLoadMoreMatchesRequested);
    on<ChangeRecommendationTypeRequested>(_onChangeRecommendationTypeRequested);
    on<ToggleAIEnabledRequested>(_onToggleAIEnabledRequested);
    on<UpdateMatchingCriteriaRequested>(_onUpdateMatchingCriteriaRequested);
    on<MatchesUpdated>(_onMatchesUpdated);
    on<RecommendationsUpdated>(_onRecommendationsUpdated);
    on<MatchingStatsUpdated>(_onMatchingStatsUpdated);
    on<TrainingProgressUpdated>(_onTrainingProgressUpdated);
    on<AIModelUpdated>(_onAIModelUpdated);
  }

  Future<void> _onGetMatchesRequested(
    GetMatchesRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(MatchesLoading());

    final result = await _aiRepository.getMatches(
      userId: event.userId,
      categories: event.categories,
      minScore: event.minScore,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (matches) => emit(MatchesLoaded(
        matches: matches,
        currentPage: event.page,
        hasMore: matches.length == event.limit,
        totalCount: matches.length,
      )),
    );
  }

  Future<void> _onGetMatchByIdRequested(
    GetMatchByIdRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.getMatchById(event.matchId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (match) => emit(MatchLoaded(match)),
    );
  }

  Future<void> _onGenerateMatchRequested(
    GenerateMatchRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.generateMatch(event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (match) => emit(MatchGenerated(match)),
    );
  }

  Future<void> _onUpdateMatchRequested(
    UpdateMatchRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.updateMatch(event.matchId, event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (match) => emit(MatchUpdated(match)),
    );
  }

  Future<void> _onDeleteMatchRequested(
    DeleteMatchRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.deleteMatch(event.matchId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(MatchDeleted(event.matchId)),
    );
  }

  Future<void> _onAcceptMatchRequested(
    AcceptMatchRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.acceptMatch(event.matchId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(MatchAccepted(event.matchId)),
    );
  }

  Future<void> _onRejectMatchRequested(
    RejectMatchRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.rejectMatch(event.matchId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(MatchRejected(event.matchId)),
    );
  }

  Future<void> _onGetMatchesForUserRequested(
    GetMatchesForUserRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.getMatchesForUser(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (matches) => emit(MatchesForUserLoaded(matches)),
    );
  }

  Future<void> _onGetUserPreferencesRequested(
    GetUserPreferencesRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.getUserPreferences(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (preferences) => emit(UserPreferencesLoaded(preferences)),
    );
  }

  Future<void> _onUpdateUserPreferencesRequested(
    UpdateUserPreferencesRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.updateUserPreferences(event.userId, event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (preferences) => emit(UserPreferencesUpdated(preferences)),
    );
  }

  Future<void> _onResetUserPreferencesRequested(
    ResetUserPreferencesRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.resetUserPreferences(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(UserPreferencesReset(event.userId)),
    );
  }

  Future<void> _onGetRecommendationsRequested(
    GetRecommendationsRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(RecommendationsLoading());

    final result = await _aiRepository.getRecommendations(
      userId: event.userId,
      type: event.type,
      categories: event.categories,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (recommendations) => emit(RecommendationsLoaded(
        recommendations: recommendations,
        currentPage: 1,
        hasMore: recommendations.length == event.limit,
        totalCount: recommendations.length,
        type: event.type,
      )),
    );
  }

  Future<void> _onGenerateRecommendationsRequested(
    GenerateRecommendationsRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.generateRecommendations(event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (recommendation) => emit(RecommendationGenerated(recommendation)),
    );
  }

  Future<void> _onMarkRecommendationAsViewedRequested(
    MarkRecommendationAsViewedRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.markRecommendationAsViewed(event.recommendationId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(RecommendationViewed(event.recommendationId)),
    );
  }

  Future<void> _onRateRecommendationRequested(
    RateRecommendationRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.rateRecommendation(event.recommendationId, event.rating);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(RecommendationRated(event.recommendationId, event.rating)),
    );
  }

  Future<void> _onGetAIModelsRequested(
    GetAIModelsRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(ModelsLoading());

    final result = await _aiRepository.getAIModels(
      type: event.type,
      status: event.status,
    );

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (models) => emit(AIModelsLoaded(models)),
    );
  }

  Future<void> _onGetAIModelByIdRequested(
    GetAIModelByIdRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.getAIModelById(event.modelId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (model) => emit(AIModelLoaded(model)),
    );
  }

  Future<void> _onCreateAIModelRequested(
    CreateAIModelRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.createAIModel(event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (model) => emit(AIModelCreated(model)),
    );
  }

  Future<void> _onUpdateAIModelRequested(
    UpdateAIModelRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.updateAIModel(event.modelId, event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (model) => emit(AIModelUpdated(model)),
    );
  }

  Future<void> _onDeleteAIModelRequested(
    DeleteAIModelRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.deleteAIModel(event.modelId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(AIModelDeleted(event.modelId)),
    );
  }

  Future<void> _onActivateAIModelRequested(
    ActivateAIModelRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.activateAIModel(event.modelId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(AIModelActivated(event.modelId)),
    );
  }

  Future<void> _onDeactivateAIModelRequested(
    DeactivateAIModelRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.deactivateAIModel(event.modelId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(AIModelDeactivated(event.modelId)),
    );
  }

  Future<void> _onGetTrainingDataRequested(
    GetTrainingDataRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(TrainingLoading());

    final result = await _aiRepository.getTrainingData(event.modelId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (trainingData) => emit(TrainingDataLoaded(trainingData)),
    );
  }

  Future<void> _onCreateTrainingDataRequested(
    CreateTrainingDataRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(TrainingLoading());

    final result = await _aiRepository.createTrainingData(event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (trainingData) => emit(TrainingDataCreated(trainingData)),
    );
  }

  Future<void> _onUpdateTrainingDataRequested(
    UpdateTrainingDataRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.updateTrainingData(event.trainingDataId, event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(TrainingDataUpdated(state as AITrainingDataEntity)),
    );
  }

  Future<void> _onDeleteTrainingDataRequested(
    DeleteTrainingDataRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.deleteTrainingData(event.trainingDataId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(TrainingDataDeleted(event.trainingDataId)),
    );
  }

  Future<void> _onStartTrainingRequested(
    StartTrainingRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.startTraining(event.modelId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(TrainingStarted(event.modelId)),
    );
  }

  Future<void> _onStopTrainingRequested(
    StopTrainingRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.stopTraining(event.trainingDataId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(TrainingStopped(event.trainingDataId)),
    );
  }

  Future<void> _onGetMatchingRequestsRequested(
    GetMatchingRequestsRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.getMatchingRequests(
      userId: event.userId,
      type: event.type,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (requests) => emit(MatchingRequestsLoaded(
        requests: requests,
        currentPage: event.page,
        hasMore: requests.length == event.limit,
        totalCount: requests.length,
      )),
    );
  }

  Future<void> _onGetMatchingRequestByIdRequested(
    GetMatchingRequestByIdRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.getMatchingRequestById(event.requestId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (request) => emit(MatchingRequestLoaded(request)),
    );
  }

  Future<void> _onCreateMatchingRequestRequested(
    CreateMatchingRequestRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.createMatchingRequest(event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (request) => emit(MatchingRequestCreated(request)),
    );
  }

  Future<void> _onProcessMatchingRequestRequested(
    ProcessMatchingRequestRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.processMatchingRequest(event.requestId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (response) => emit(MatchingResponseProcessed(response)),
    );
  }

  Future<void> _onGetMatchingStatsRequested(
    GetMatchingStatsRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(StatsLoading());

    final result = await _aiRepository.getMatchingStats(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (stats) => emit(MatchingStatsLoaded(stats)),
    );
  }

  Future<void> _onGetMatchingStatsByPeriodRequested(
    GetMatchingStatsByPeriodRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(StatsLoading());

    final result = await _aiRepository.getMatchingStatsByPeriod(event.startDate, event.endDate);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (stats) => emit(MatchingStatsByPeriodLoaded(stats)),
    );
  }

  Future<void> _onProvideMatchFeedbackRequested(
    ProvideMatchFeedbackRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.provideMatchFeedback(event.matchId, event.feedback);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(MatchFeedbackProvided(event.matchId)),
    );
  }

  Future<void> _onReportIncorrectMatchRequested(
    ReportIncorrectMatchRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.reportIncorrectMatch(event.matchId, event.reason);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(IncorrectMatchReported(event.matchId)),
    );
  }

  Future<void> _onGetSimilarUserPreferencesRequested(
    GetSimilarUserPreferencesRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.getSimilarUserPreferences(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (preferences) => emit(SimilarUserPreferencesLoaded(preferences)),
    );
  }

  Future<void> _onGenerateBatchMatchesRequested(
    GenerateBatchMatchesRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading());

    final result = await _aiRepository.generateBatchMatches(event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (matches) => emit(BatchMatchesGenerated(matches)),
    );
  }

  Future<void> _onRetrainModelsRequested(
    RetrainModelsRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(TrainingLoading());

    final result = await _aiRepository.retrainModels(event.request);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(ModelsRetrained(event.request.modelIds)),
    );
  }

  Future<void> _onGetSuggestedCategoriesRequested(
    GetSuggestedCategoriesRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.getSuggestedCategories(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (categories) => emit(SuggestedCategoriesLoaded(categories)),
    );
  }

  Future<void> _onGetSuggestedBrandsRequested(
    GetSuggestedBrandsRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.getSuggestedBrands(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (brands) => emit(SuggestedBrandsLoaded(brands)),
    );
  }

  Future<void> _onGetSuggestedLocationsRequested(
    GetSuggestedLocationsRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.getSuggestedLocations(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (locations) => emit(SuggestedLocationsLoaded(locations)),
    );
  }

  Future<void> _onGetCompatibilityMatrixRequested(
    GetCompatibilityMatrixRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.getCompatibilityMatrix(event.userId, event.categoryIds);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (matrix) => emit(CompatibilityMatrixLoaded(matrix)),
    );
  }

  Future<void> _onRefreshUserPreferencesCacheRequested(
    RefreshUserPreferencesCacheRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.refreshUserPreferencesCache(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(UserPreferencesCacheRefreshed(event.userId)),
    );
  }

  Future<void> _onRefreshMatchingCacheRequested(
    RefreshMatchingCacheRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.refreshMatchingCache(event.userId);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(MatchingCacheRefreshed(event.userId)),
    );
  }

  Future<void> _onClearAICacheRequested(
    ClearAICacheRequested event,
    Emitter<AIState> emit,
  ) async {
    final result = await _aiRepository.clearAICache(event.cacheType);

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (_) => emit(AICacheCleared(event.cacheType)),
    );
  }

  Future<void> _onRefreshAIMatchesRequested(
    RefreshAIMatchesRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(AIInitial());
  }

  Future<void> _onLoadMoreMatchesRequested(
    LoadMoreMatchesRequested event,
    Emitter<AIState> emit,
  ) async {
    if (state is MatchesLoaded) {
      final currentState = state as MatchesLoaded;
      emit(MatchesLoading(isLoadMore: true));

      final result = await _aiRepository.getMatches(
        userId: event.userId,
        page: currentState.currentPage + 1,
        limit: 20,
      );

      result.fold(
        (failure) => emit(AIError(failure.message)),
        (matches) => emit(MatchesLoaded(
          matches: [...currentState.matches, ...matches],
          currentPage: currentState.currentPage + 1,
          hasMore: matches.length == 20,
          totalCount: currentState.totalCount + matches.length,
        )),
      );
    }
  }

  Future<void> _onChangeRecommendationTypeRequested(
    ChangeRecommendationTypeRequested event,
    Emitter<AIState> emit,
  ) async {
    emit(RecommendationsLoading());

    final result = await _aiRepository.getRecommendations(
      type: event.type,
      limit: 20,
    );

    result.fold(
      (failure) => emit(AIError(failure.message)),
      (recommendations) => emit(RecommendationsLoaded(
        recommendations: recommendations,
        type: event.type,
      )),
    );
  }

  Future<void> _onToggleAIEnabledRequested(
    ToggleAIEnabledRequested event,
    Emitter<AIState> emit,
  ) async {
    // Update AI enabled state in preferences
    debugPrint('AI enabled: ${event.enabled}');
  }

  Future<void> _onUpdateMatchingCriteriaRequested(
    UpdateMatchingCriteriaRequested event,
    Emitter<AIState> emit,
  ) async {
    // Update matching criteria
    debugPrint('Updated matching criteria: ${event.criteria}');
  }

  Future<void> _onMatchesUpdated(
    MatchesUpdated event,
    Emitter<AIState> emit,
  ) async {
    emit(MatchesUpdatedInRealTime(event.userId, event.matches));
  }

  Future<void> _onRecommendationsUpdated(
    RecommendationsUpdated event,
    Emitter<AIState> emit,
  ) async {
    emit(RecommendationsUpdatedInRealTime(event.userId, event.recommendations));
  }

  Future<void> _onMatchingStatsUpdated(
    MatchingStatsUpdated event,
    Emitter<AIState> emit,
  ) async {
    emit(MatchingStatsUpdatedInRealTime(event.stats));
  }

  Future<void> _onTrainingProgressUpdated(
    TrainingProgressUpdated event,
    Emitter<AIState> emit,
  ) async {
    emit(TrainingProgressUpdatedInRealTime(event.modelId, event.trainingData));
  }

  Future<void> _onAIModelUpdated(
    AIModelUpdated event,
    Emitter<AIState> emit,
  ) async {
    emit(AIModelUpdatedInRealTime(event.model));
  }

  // Helper methods
  void refreshAllData() {
    add(const GetMatchesRequested());
    add(const GetRecommendationsRequested());
    add(const GetMatchingStatsRequested());
    add(const GetAIModelsRequested());
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
