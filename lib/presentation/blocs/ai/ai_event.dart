import 'package:equatable/equatable.dart';
import '../../../domain/repositories/ai_repository.dart';

abstract class AIEvent extends Equatable {
  const AIEvent();

  @override
  List<Object?> get props => [];
}

// Matching Events
class GetMatchesRequested extends AIEvent {
  final String? userId;
  final List<String>? categories;
  final double? minScore;
  final int page;
  final int limit;

  const GetMatchesRequested({
    this.userId,
    this.categories,
    this.minScore,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, categories, minScore, page, limit];
}

class GetMatchByIdRequested extends AIEvent {
  final String matchId;

  const GetMatchByIdRequested(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class GenerateMatchRequested extends AIEvent {
  final GenerateMatchRequest request;

  const GenerateMatchRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateMatchRequested extends AIEvent {
  final String matchId;
  final UpdateMatchRequest request;

  const UpdateMatchRequested(this.matchId, this.request);

  @override
  List<Object?> get props => [matchId, request];
}

class DeleteMatchRequested extends AIEvent {
  final String matchId;

  const DeleteMatchRequested(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class AcceptMatchRequested extends AIEvent {
  final String matchId;

  const AcceptMatchRequested(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class RejectMatchRequested extends AIEvent {
  final String matchId;

  const RejectMatchRequested(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class GetMatchesForUserRequested extends AIEvent {
  final String userId;

  const GetMatchesForUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

// User Preferences Events
class GetUserPreferencesRequested extends AIEvent {
  final String userId;

  const GetUserPreferencesRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserPreferencesRequested extends AIEvent {
  final String userId;
  final UpdateUserPreferencesRequest request;

  const UpdateUserPreferencesRequested(this.userId, this.request);

  @override
  List<Object?> get props => [userId, request];
}

class ResetUserPreferencesRequested extends AIEvent {
  final String userId;

  const ResetUserPreferencesRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Recommendations Events
class GetRecommendationsRequested extends AIEvent {
  final String? userId;
  final RecommendationType? type;
  final List<String>? categories;
  final int limit;

  const GetRecommendationsRequested({
    this.userId,
    this.type,
    this.categories,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, type, categories, limit];
}

class GenerateRecommendationsRequested extends AIEvent {
  final GenerateRecommendationsRequest request;

  const GenerateRecommendationsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class MarkRecommendationAsViewedRequested extends AIEvent {
  final String recommendationId;

  const MarkRecommendationAsViewedRequested(this.recommendationId);

  @override
  List<Object?> get props => [recommendationId];
}

class RateRecommendationRequested extends AIEvent {
  final String recommendationId;
  final int rating;

  const RateRecommendationRequested(this.recommendationId, this.rating);

  @override
  List<Object?> get props => [recommendationId, rating];
}

// AI Models Events
class GetAIModelsRequested extends AIEvent {
  final ModelType? type;
  final ModelStatus? status;

  const GetAIModelsRequested({this.type, this.status});

  @override
  List<Object?> get props => [type, status];
}

class GetAIModelByIdRequested extends AIEvent {
  final String modelId;

  const GetAIModelByIdRequested(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class CreateAIModelRequested extends AIEvent {
  final CreateAIModelRequest request;

  const CreateAIModelRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateAIModelRequested extends AIEvent {
  final String modelId;
  final UpdateAIModelRequest request;

  const UpdateAIModelRequested(this.modelId, this.request);

  @override
  List<Object?> get props => [modelId, request];
}

class DeleteAIModelRequested extends AIEvent {
  final String modelId;

  const DeleteAIModelRequested(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class ActivateAIModelRequested extends AIEvent {
  final String modelId;

  const ActivateAIModelRequested(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class DeactivateAIModelRequested extends AIEvent {
  final String modelId;

  const DeactivateAIModelRequested(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

// Training Data Events
class GetTrainingDataRequested extends AIEvent {
  final String modelId;

  const GetTrainingDataRequested(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class CreateTrainingDataRequested extends AIEvent {
  final CreateTrainingDataRequest request;

  const CreateTrainingDataRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateTrainingDataRequested extends AIEvent {
  final String trainingDataId;
  final UpdateTrainingDataRequest request;

  const UpdateTrainingDataRequested(this.trainingDataId, this.request);

  @override
  List<Object?> get props => [trainingDataId, request];
}

class DeleteTrainingDataRequested extends AIEvent {
  final String trainingDataId;

  const DeleteTrainingDataRequested(this.trainingDataId);

  @override
  List<Object?> get props => [trainingDataId];
}

class StartTrainingRequested extends AIEvent {
  final String modelId;

  const StartTrainingRequested(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class StopTrainingRequested extends AIEvent {
  final String trainingDataId;

  const StopTrainingRequested(this.trainingDataId);

  @override
  List<Object?> get props => [trainingDataId];
}

// Matching Requests Events
class GetMatchingRequestsRequested extends AIEvent {
  final String? userId;
  final MatchingRequestType? type;
  final int page;
  final int limit;

  const GetMatchingRequestsRequested({
    this.userId,
    this.type,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, type, page, limit];
}

class GetMatchingRequestByIdRequested extends AIEvent {
  final String requestId;

  const GetMatchingRequestByIdRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class CreateMatchingRequestRequested extends AIEvent {
  final CreateMatchingRequestRequest request;

  const CreateMatchingRequestRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class ProcessMatchingRequestRequested extends AIEvent {
  final String requestId;

  const ProcessMatchingRequestRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

// Statistics Events
class GetMatchingStatsRequested extends AIEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const GetMatchingStatsRequested({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetMatchingStatsByPeriodRequested extends AIEvent {
  final DateTime startDate;
  final DateTime endDate;

  const GetMatchingStatsByPeriodRequested(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

// Learning & Feedback Events
class ProvideMatchFeedbackRequested extends AIEvent {
  final String matchId;
  final MatchFeedbackRequest feedback;

  const ProvideMatchFeedbackRequested(this.matchId, this.feedback);

  @override
  List<Object?> get props => [matchId, feedback];
}

class ReportIncorrectMatchRequested extends AIEvent {
  final String matchId;
  final String reason;

  const ReportIncorrectMatchRequested(this.matchId, this.reason);

  @override
  List<Object?> get props => [matchId, reason];
}

class GetSimilarUserPreferencesRequested extends AIEvent {
  final String userId;

  const GetSimilarUserPreferencesRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Batch Operations Events
class GenerateBatchMatchesRequested extends AIEvent {
  final BatchMatchingRequest request;

  const GenerateBatchMatchesRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class RetrainModelsRequested extends AIEvent {
  final RetrainModelsRequest request;

  const RetrainModelsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// Advanced Features Events
class GetSuggestedCategoriesRequested extends AIEvent {
  final String userId;

  const GetSuggestedCategoriesRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetSuggestedBrandsRequested extends AIEvent {
  final String userId;

  const GetSuggestedBrandsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetSuggestedLocationsRequested extends AIEvent {
  final String userId;

  const GetSuggestedLocationsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetCompatibilityMatrixRequested extends AIEvent {
  final String userId;
  final List<String> categoryIds;

  const GetCompatibilityMatrixRequested(this.userId, this.categoryIds);

  @override
  List<Object?> get props => [userId, categoryIds];
}

// Cache Management Events
class RefreshUserPreferencesCacheRequested extends AIEvent {
  final String userId;

  const RefreshUserPreferencesCacheRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshMatchingCacheRequested extends AIEvent {
  final String userId;

  const RefreshMatchingCacheRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ClearAICacheRequested extends AIEvent {
  final String cacheType;

  const ClearAICacheRequested(this.cacheType);

  @override
  List<Object?> get props => [cacheType];
}

// UI Events
class RefreshAIMatchesRequested extends AIEvent {}

class LoadMoreMatchesRequested extends AIEvent {
  final String userId;

  const LoadMoreMatchesRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ChangeRecommendationTypeRequested extends AIEvent {
  final RecommendationType type;

  const ChangeRecommendationTypeRequested(this.type);

  @override
  List<Object?> get props => [type];
}

class ToggleAIEnabledRequested extends AIEvent {
  final bool enabled;

  const ToggleAIEnabledRequested(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class UpdateMatchingCriteriaRequested extends AIEvent {
  final Map<String, double> criteria;

  const UpdateMatchingCriteriaRequested(this.criteria);

  @override
  List<Object?> get props => [criteria];
}

// Real-time Events
class MatchesUpdated extends AIEvent {
  final String userId;
  final List<AIMatchingEntity> matches;

  const MatchesUpdated(this.userId, this.matches);

  @override
  List<Object?> get props => [userId, matches];
}

class RecommendationsUpdated extends AIEvent {
  final String userId;
  final List<AIRecommendationEntity> recommendations;

  const RecommendationsUpdated(this.userId, this.recommendations);

  @override
  List<Object?> get props => [userId, recommendations];
}

class MatchingStatsUpdated extends AIEvent {
  final AIMatchingStatsEntity stats;

  const MatchingStatsUpdated(this.stats);

  @override
  List<Object?> get props => [stats];
}

class TrainingProgressUpdated extends AIEvent {
  final String modelId;
  final AITrainingDataEntity trainingData;

  const TrainingProgressUpdated(this.modelId, this.trainingData);

  @override
  List<Object?> get props => [modelId, trainingData];
}

class AIModelUpdated extends AIEvent {
  final AIModelEntity model;

  const AIModelUpdated(this.model);

  @override
  List<Object?> get props => [model];
}

enum AIMatchingTabType {
  matches('matches', 'Eşleşmeler'),
  recommendations('recommendations', 'Öneriler'),
  preferences('preferences', 'Tercihler'),
  stats('stats', 'İstatistikler'),
  models('models', 'Modeller');

  const AIMatchingTabType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum AIMatchFilter {
  all('all', 'Tümü'),
  highQuality('high_quality', 'Yüksek Kalite'),
  mediumQuality('medium_quality', 'Orta Kalite'),
  lowQuality('low_quality', 'Düşük Kalite'),
  active('active', 'Aktif'),
  expired('expired', 'Süresi Dolmuş');

  const AIMatchFilter(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum AISortOption {
  score('score', 'Skora Göre'),
  date('date', 'Tarihe Göre'),
  quality('quality', 'Kaliteye Göre'),
  compatibility('compatibility', 'Uyuma Göre');

  const AISortOption(this.value, this.displayName);
  final String value;
  final String displayName;
}
