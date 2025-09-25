import 'package:equatable/equatable.dart';
import '../../../domain/entities/ai_matching.dart';

abstract class AIState extends Equatable {
  const AIState();

  @override
  List<Object?> get props => [];
}

class AIInitial extends AIState {}

class AILoading extends AIState {}

class MatchesLoading extends AIState {
  final bool isLoadMore;

  const MatchesLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class RecommendationsLoading extends AIState {
  final bool isLoadMore;

  const RecommendationsLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class ModelsLoading extends AIState {}

class TrainingLoading extends AIState {}

class StatsLoading extends AIState {}

// Success States
class MatchesLoaded extends AIState {
  final List<AIMatchingEntity> matches;
  final bool hasMore;
  final int currentPage;
  final int totalCount;
  final AIMatchFilter? filter;
  final AISortOption? sortOption;

  const MatchesLoaded({
    required this.matches,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
    this.filter,
    this.sortOption,
  });

  @override
  List<Object?> get props => [matches, hasMore, currentPage, totalCount, filter, sortOption];
}

class MatchLoaded extends AIState {
  final AIMatchingEntity match;

  const MatchLoaded(this.match);

  @override
  List<Object?> get props => [match];
}

class MatchGenerated extends AIState {
  final AIMatchingEntity match;

  const MatchGenerated(this.match);

  @override
  List<Object?> get props => [match];
}

class MatchUpdated extends AIState {
  final AIMatchingEntity match;

  const MatchUpdated(this.match);

  @override
  List<Object?> get props => [match];
}

class MatchDeleted extends AIState {
  final String matchId;

  const MatchDeleted(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class MatchAccepted extends AIState {
  final String matchId;

  const MatchAccepted(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class MatchRejected extends AIState {
  final String matchId;

  const MatchRejected(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class MatchesForUserLoaded extends AIState {
  final List<AIMatchingEntity> matches;

  const MatchesForUserLoaded(this.matches);

  @override
  List<Object?> get props => [matches];
}

class UserPreferencesLoaded extends AIState {
  final UserPreferenceEntity preferences;

  const UserPreferencesLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class UserPreferencesUpdated extends AIState {
  final UserPreferenceEntity preferences;

  const UserPreferencesUpdated(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class UserPreferencesReset extends AIState {
  final String userId;

  const UserPreferencesReset(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RecommendationsLoaded extends AIState {
  final List<AIRecommendationEntity> recommendations;
  final bool hasMore;
  final int currentPage;
  final int totalCount;
  final RecommendationType? type;

  const RecommendationsLoaded({
    required this.recommendations,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
    this.type,
  });

  @override
  List<Object?> get props => [recommendations, hasMore, currentPage, totalCount, type];
}

class RecommendationGenerated extends AIState {
  final AIRecommendationEntity recommendation;

  const RecommendationGenerated(this.recommendation);

  @override
  List<Object?> get props => [recommendation];
}

class RecommendationViewed extends AIState {
  final String recommendationId;

  const RecommendationViewed(this.recommendationId);

  @override
  List<Object?> get props => [recommendationId];
}

class RecommendationRated extends AIState {
  final String recommendationId;
  final int rating;

  const RecommendationRated(this.recommendationId, this.rating);

  @override
  List<Object?> get props => [recommendationId, rating];
}

class AIModelsLoaded extends AIState {
  final List<AIModelEntity> models;

  const AIModelsLoaded(this.models);

  @override
  List<Object?> get props => [models];
}

class AIModelLoaded extends AIState {
  final AIModelEntity model;

  const AIModelLoaded(this.model);

  @override
  List<Object?> get props => [model];
}

class AIModelCreated extends AIState {
  final AIModelEntity model;

  const AIModelCreated(this.model);

  @override
  List<Object?> get props => [model];
}

class AIModelUpdated extends AIState {
  final AIModelEntity model;

  const AIModelUpdated(this.model);

  @override
  List<Object?> get props => [model];
}

class AIModelDeleted extends AIState {
  final String modelId;

  const AIModelDeleted(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class AIModelActivated extends AIState {
  final String modelId;

  const AIModelActivated(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class AIModelDeactivated extends AIState {
  final String modelId;

  const AIModelDeactivated(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class TrainingDataLoaded extends AIState {
  final AITrainingDataEntity trainingData;

  const TrainingDataLoaded(this.trainingData);

  @override
  List<Object?> get props => [trainingData];
}

class TrainingDataCreated extends AIState {
  final AITrainingDataEntity trainingData;

  const TrainingDataCreated(this.trainingData);

  @override
  List<Object?> get props => [trainingData];
}

class TrainingDataUpdated extends AIState {
  final AITrainingDataEntity trainingData;

  const TrainingDataUpdated(this.trainingData);

  @override
  List<Object?> get props => [trainingData];
}

class TrainingDataDeleted extends AIState {
  final String trainingDataId;

  const TrainingDataDeleted(this.trainingDataId);

  @override
  List<Object?> get props => [trainingDataId];
}

class TrainingStarted extends AIState {
  final String modelId;

  const TrainingStarted(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class TrainingStopped extends AIState {
  final String trainingDataId;

  const TrainingStopped(this.trainingDataId);

  @override
  List<Object?> get props => [trainingDataId];
}

class MatchingRequestsLoaded extends AIState {
  final List<AIMatchingRequestEntity> requests;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const MatchingRequestsLoaded({
    required this.requests,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [requests, hasMore, currentPage, totalCount];
}

class MatchingRequestLoaded extends AIState {
  final AIMatchingRequestEntity request;

  const MatchingRequestLoaded(this.request);

  @override
  List<Object?> get props => [request];
}

class MatchingRequestCreated extends AIState {
  final AIMatchingRequestEntity request;

  const MatchingRequestCreated(this.request);

  @override
  List<Object?> get props => [request];
}

class MatchingResponseProcessed extends AIState {
  final AIMatchingResponseEntity response;

  const MatchingResponseProcessed(this.response);

  @override
  List<Object?> get props => [response];
}

class MatchingStatsLoaded extends AIState {
  final AIMatchingStatsEntity stats;

  const MatchingStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class MatchingStatsByPeriodLoaded extends AIState {
  final List<AIMatchingStatsEntity> stats;

  const MatchingStatsByPeriodLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class MatchFeedbackProvided extends AIState {
  final String matchId;

  const MatchFeedbackProvided(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class IncorrectMatchReported extends AIState {
  final String matchId;

  const IncorrectMatchReported(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class SimilarUserPreferencesLoaded extends AIState {
  final List<UserPreferenceEntity> preferences;

  const SimilarUserPreferencesLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class BatchMatchesGenerated extends AIState {
  final List<AIMatchingEntity> matches;

  const BatchMatchesGenerated(this.matches);

  @override
  List<Object?> get props => [matches];
}

class ModelsRetrained extends AIState {
  final List<String> modelIds;

  const ModelsRetrained(this.modelIds);

  @override
  List<Object?> get props => [modelIds];
}

class SuggestedCategoriesLoaded extends AIState {
  final List<String> categories;

  const SuggestedCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class SuggestedBrandsLoaded extends AIState {
  final List<String> brands;

  const SuggestedBrandsLoaded(this.brands);

  @override
  List<Object?> get props => [brands];
}

class SuggestedLocationsLoaded extends AIState {
  final List<String> locations;

  const SuggestedLocationsLoaded(this.locations);

  @override
  List<Object?> get props => [locations];
}

class CompatibilityMatrixLoaded extends AIState {
  final Map<String, double> matrix;

  const CompatibilityMatrixLoaded(this.matrix);

  @override
  List<Object?> get props => [matrix];
}

class UserPreferencesCacheRefreshed extends AIState {
  final String userId;

  const UserPreferencesCacheRefreshed(this.userId);

  @override
  List<Object?> get props => [userId];
}

class MatchingCacheRefreshed extends AIState {
  final String userId;

  const MatchingCacheRefreshed(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AICacheCleared extends AIState {
  final String cacheType;

  const AICacheCleared(this.cacheType);

  @override
  List<Object?> get props => [cacheType];
}

// Real-time States
class MatchesUpdatedInRealTime extends AIState {
  final String userId;
  final List<AIMatchingEntity> matches;

  const MatchesUpdatedInRealTime(this.userId, this.matches);

  @override
  List<Object?> get props => [userId, matches];
}

class RecommendationsUpdatedInRealTime extends AIState {
  final String userId;
  final List<AIRecommendationEntity> recommendations;

  const RecommendationsUpdatedInRealTime(this.userId, this.recommendations);

  @override
  List<Object?> get props => [userId, recommendations];
}

class MatchingStatsUpdatedInRealTime extends AIState {
  final AIMatchingStatsEntity stats;

  const MatchingStatsUpdatedInRealTime(this.stats);

  @override
  List<Object?> get props => [stats];
}

class TrainingProgressUpdatedInRealTime extends AIState {
  final String modelId;
  final AITrainingDataEntity trainingData;

  const TrainingProgressUpdatedInRealTime(this.modelId, this.trainingData);

  @override
  List<Object?> get props => [modelId, trainingData];
}

class AIModelUpdatedInRealTime extends AIState {
  final AIModelEntity model;

  const AIModelUpdatedInRealTime(this.model);

  @override
  List<Object?> get props => [model];
}

// Error State
class AIError extends AIState {
  final String message;
  final String? code;
  final AIErrorType? errorType;

  const AIError(this.message, {this.code, this.errorType});

  @override
  List<Object?> get props => [message, code, errorType];
}

enum AIErrorType {
  network('network', 'Ağ Hatası'),
  model('model', 'Model Hatası'),
  training('training', 'Eğitim Hatası'),
  matching('matching', 'Eşleştirme Hatası'),
  data('data', 'Veri Hatası'),
  permission('permission', 'İzin Hatası'),
  validation('validation', 'Doğrulama Hatası'),
  timeout('timeout', 'Zaman Aşımı'),
  unknown('unknown', 'Bilinmeyen Hata');

  const AIErrorType(this.value, this.displayName);
  final String value;
  final String displayName;
}

// UI State
class AIUIState extends AIState {
  final AIMatchingTabType currentTab;
  final AIMatchFilter currentFilter;
  final AISortOption currentSort;
  final bool isAIEnabled;
  final bool isLoading;
  final String? selectedUserId;
  final Map<String, dynamic> uiSettings;

  const AIUIState({
    this.currentTab = AIMatchingTabType.matches,
    this.currentFilter = AIMatchFilter.all,
    this.currentSort = AISortOption.score,
    this.isAIEnabled = true,
    this.isLoading = false,
    this.selectedUserId,
    this.uiSettings = const {},
  });

  AIUIState copyWith({
    AIMatchingTabType? currentTab,
    AIMatchFilter? currentFilter,
    AISortOption? currentSort,
    bool? isAIEnabled,
    bool? isLoading,
    String? selectedUserId,
    Map<String, dynamic>? uiSettings,
  }) {
    return AIUIState(
      currentTab: currentTab ?? this.currentTab,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSort: currentSort ?? this.currentSort,
      isAIEnabled: isAIEnabled ?? this.isAIEnabled,
      isLoading: isLoading ?? this.isLoading,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      uiSettings: uiSettings ?? this.uiSettings,
    );
  }

  @override
  List<Object?> get props => [
        currentTab,
        currentFilter,
        currentSort,
        isAIEnabled,
        isLoading,
        selectedUserId,
        uiSettings,
      ];
}

// Configuration State
class AIMatchingConfigState extends AIState {
  final AIMatchingConfigEntity config;
  final bool isInitialized;

  const AIMatchingConfigState({
    required this.config,
    this.isInitialized = false,
  });

  @override
  List<Object?> get props => [config, isInitialized];
}
