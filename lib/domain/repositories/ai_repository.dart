import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/ai_matching.dart';

abstract class AIRepository {
  // Matching Operations
  Future<Either<Failure, List<AIMatchingEntity>>> getMatches({
    String? userId,
    List<String>? categories,
    double? minScore,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, AIMatchingEntity>> getMatchById(String matchId);

  Future<Either<Failure, AIMatchingEntity>> generateMatch(GenerateMatchRequest request);

  Future<Either<Failure, AIMatchingEntity>> updateMatch(String matchId, UpdateMatchRequest request);

  Future<Either<Failure, void>> deleteMatch(String matchId);

  Future<Either<Failure, void>> acceptMatch(String matchId);

  Future<Either<Failure, void>> rejectMatch(String matchId);

  Future<Either<Failure, List<AIMatchingEntity>>> getMatchesForUser(String userId);

  // User Preferences
  Future<Either<Failure, UserPreferenceEntity>> getUserPreferences(String userId);

  Future<Either<Failure, UserPreferenceEntity>> updateUserPreferences(
    String userId,
    UpdateUserPreferencesRequest request,
  );

  Future<Either<Failure, void>> resetUserPreferences(String userId);

  // Recommendations
  Future<Either<Failure, List<AIRecommendationEntity>>> getRecommendations({
    String? userId,
    RecommendationType? type,
    List<String>? categories,
    int limit = 20,
  });

  Future<Either<Failure, AIRecommendationEntity>> generateRecommendations(
    GenerateRecommendationsRequest request,
  );

  Future<Either<Failure, void>> markRecommendationAsViewed(String recommendationId);

  Future<Either<Failure, void>> rateRecommendation(String recommendationId, int rating);

  // AI Models
  Future<Either<Failure, List<AIModelEntity>>> getAIModels({
    ModelType? type,
    ModelStatus? status,
  });

  Future<Either<Failure, AIModelEntity>> getAIModelById(String modelId);

  Future<Either<Failure, AIModelEntity>> createAIModel(CreateAIModelRequest request);

  Future<Either<Failure, AIModelEntity>> updateAIModel(String modelId, UpdateAIModelRequest request);

  Future<Either<Failure, void>> deleteAIModel(String modelId);

  Future<Either<Failure, void>> activateAIModel(String modelId);

  Future<Either<Failure, void>> deactivateAIModel(String modelId);

  // Training Data
  Future<Either<Failure, AITrainingDataEntity>> getTrainingData(String modelId);

  Future<Either<Failure, AITrainingDataEntity>> createTrainingData(
    CreateTrainingDataRequest request,
  );

  Future<Either<Failure, void>> updateTrainingData(
    String trainingDataId,
    UpdateTrainingDataRequest request,
  );

  Future<Either<Failure, void>> deleteTrainingData(String trainingDataId);

  Future<Either<Failure, void>> startTraining(String modelId);

  Future<Either<Failure, void>> stopTraining(String trainingDataId);

  // Matching Requests
  Future<Either<Failure, List<AIMatchingRequestEntity>>> getMatchingRequests({
    String? userId,
    MatchingRequestType? type,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, AIMatchingRequestEntity>> getMatchingRequestById(String requestId);

  Future<Either<Failure, AIMatchingRequestEntity>> createMatchingRequest(
    CreateMatchingRequestRequest request,
  );

  Future<Either<Failure, AIMatchingResponseEntity>> processMatchingRequest(String requestId);

  // Statistics
  Future<Either<Failure, AIMatchingStatsEntity>> getMatchingStats({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, List<AIMatchingStatsEntity>>> getMatchingStatsByPeriod(
    DateTime startDate,
    DateTime endDate,
  );

  // Learning & Feedback
  Future<Either<Failure, void>> provideMatchFeedback(
    String matchId,
    MatchFeedbackRequest feedback,
  );

  Future<Either<Failure, void>> reportIncorrectMatch(String matchId, String reason);

  Future<Either<Failure, List<UserPreferenceEntity>>> getSimilarUserPreferences(String userId);

  // Real-time Updates
  Stream<Either<Failure, List<AIMatchingEntity>>> subscribeToMatches(String userId);

  Stream<Either<Failure, List<AIRecommendationEntity>>> subscribeToRecommendations(String userId);

  Stream<Either<Failure, AIMatchingStatsEntity>> subscribeToMatchingStats();

  Stream<Either<Failure, AITrainingDataEntity>> subscribeToTrainingProgress(String modelId);

  // Batch Operations
  Future<Either<Failure, List<AIMatchingEntity>>> generateBatchMatches(
    BatchMatchingRequest request,
  );

  Future<Either<Failure, void>> retrainModels(RetrainModelsRequest request);

  // Advanced Features
  Future<Either<Failure, List<String>>> getSuggestedCategories(String userId);

  Future<Either<Failure, List<String>>> getSuggestedBrands(String userId);

  Future<Either<Failure, List<String>>> getSuggestedLocations(String userId);

  Future<Either<Failure, Map<String, double>>> getCompatibilityMatrix(
    String userId,
    List<String> categoryIds,
  );

  // Cache Management
  Future<Either<Failure, void>> refreshUserPreferencesCache(String userId);

  Future<Either<Failure, void>> refreshMatchingCache(String userId);

  Future<Either<Failure, void>> clearAICache(String cacheType);
}

// Request/Response Models
class GenerateMatchRequest {
  final String userId;
  final List<String> targetCategories;
  final PriceRange? priceRange;
  final List<String> preferredBrands;
  final List<String> preferredLocations;
  final Map<String, double> customWeights;
  final int maxResults;
  final double minCompatibilityScore;
  final bool includeUserPreferences;
  final Map<String, dynamic>? additionalParameters;

  const GenerateMatchRequest({
    required this.userId,
    required this.targetCategories,
    this.priceRange,
    this.preferredBrands = const [],
    this.preferredLocations = const [],
    this.customWeights = const {},
    this.maxResults = 20,
    this.minCompatibilityScore = 0.6,
    this.includeUserPreferences = true,
    this.additionalParameters,
  });
}

class UpdateMatchRequest {
  final MatchQuality? quality;
  final bool? isActive;
  final List<MatchedItem>? matchedItems;
  final Map<String, dynamic>? metadata;

  const UpdateMatchRequest({
    this.quality,
    this.isActive,
    this.matchedItems,
    this.metadata,
  });
}

class UpdateUserPreferencesRequest {
  final List<PreferenceCategory>? preferredCategories;
  final List<PreferenceCondition>? preferredConditions;
  final PriceRange? preferredPriceRange;
  final List<String>? preferredBrands;
  final List<String>? preferredLocations;
  final List<String>? excludedCategories;
  final List<String>? excludedBrands;
  final Map<String, double>? categoryWeights;
  final Map<String, double>? featureWeights;
  final int? minCompatibilityScore;
  final bool? prioritizeQuality;
  final bool? prioritizePrice;
  final bool? prioritizeLocation;

  const UpdateUserPreferencesRequest({
    this.preferredCategories,
    this.preferredConditions,
    this.preferredPriceRange,
    this.preferredBrands,
    this.preferredLocations,
    this.excludedCategories,
    this.excludedBrands,
    this.categoryWeights,
    this.featureWeights,
    this.minCompatibilityScore,
    this.prioritizeQuality,
    this.prioritizePrice,
    this.prioritizeLocation,
  });
}

class GenerateRecommendationsRequest {
  final String userId;
  final RecommendationType type;
  final List<String>? categories;
  final int limit;
  final Map<String, dynamic>? parameters;

  const GenerateRecommendationsRequest({
    required this.userId,
    required this.type,
    this.categories,
    this.limit = 20,
    this.parameters,
  });
}

class CreateAIModelRequest {
  final String name;
  final String version;
  final ModelType type;
  final Map<String, dynamic> parameters;
  final List<String> features;
  final Map<String, dynamic>? metadata;

  const CreateAIModelRequest({
    required this.name,
    required this.version,
    required this.type,
    required this.parameters,
    required this.features,
    this.metadata,
  });
}

class UpdateAIModelRequest {
  final ModelStatus? status;
  final Map<String, dynamic>? parameters;
  final List<String>? features;
  final Map<String, dynamic>? metadata;

  const UpdateAIModelRequest({
    this.status,
    this.parameters,
    this.features,
    this.metadata,
  });
}

class CreateTrainingDataRequest {
  final String modelId;
  final List<TrainingSample> trainingSamples;
  final List<TrainingSample> validationSamples;
  final List<TrainingSample> testSamples;
  final Map<String, dynamic> parameters;
  final int epochs;

  const CreateTrainingDataRequest({
    required this.modelId,
    required this.trainingSamples,
    required this.validationSamples,
    required this.testSamples,
    required this.parameters,
    required this.epochs,
  });
}

class UpdateTrainingDataRequest {
  final TrainingStatus? status;
  final double? trainingAccuracy;
  final double? validationAccuracy;
  final int? currentEpoch;

  const UpdateTrainingDataRequest({
    this.status,
    this.trainingAccuracy,
    this.validationAccuracy,
    this.currentEpoch,
  });
}

class CreateMatchingRequestRequest {
  final String userId;
  final MatchingRequestType type;
  final List<String> targetCategories;
  final PriceRange? priceRange;
  final List<String>? preferredBrands;
  final List<String>? preferredLocations;
  final Map<String, double>? customWeights;
  final int? maxResults;
  final double? minCompatibilityScore;
  final bool? includeUserPreferences;
  final Map<String, dynamic>? parameters;

  const CreateMatchingRequestRequest({
    required this.userId,
    required this.type,
    required this.targetCategories,
    this.priceRange,
    this.preferredBrands,
    this.preferredLocations,
    this.customWeights,
    this.maxResults,
    this.minCompatibilityScore,
    this.includeUserPreferences,
    this.parameters,
  });
}

class MatchFeedbackRequest {
  final String matchId;
  final int rating;
  final String? comment;
  final List<String>? preferredCategories;
  final List<String>? dislikedCategories;
  final Map<String, double>? weightAdjustments;

  const MatchFeedbackRequest({
    required this.matchId,
    required this.rating,
    this.comment,
    this.preferredCategories,
    this.dislikedCategories,
    this.weightAdjustments,
  });
}

class BatchMatchingRequest {
  final List<String> userIds;
  final List<String> categories;
  final int matchesPerUser;
  final double minCompatibilityScore;
  final Map<String, dynamic>? parameters;

  const BatchMatchingRequest({
    required this.userIds,
    required this.categories,
    required this.matchesPerUser,
    required this.minCompatibilityScore,
    this.parameters,
  });
}

class RetrainModelsRequest {
  final List<String> modelIds;
  final bool includeNewData;
  final Map<String, dynamic>? trainingParameters;
  final bool forceRetrain;

  const RetrainModelsRequest({
    required this.modelIds,
    this.includeNewData = true,
    this.trainingParameters,
    this.forceRetrain = false,
  });
}

class AIMatchingConfigEntity extends Equatable {
  final String id;
  final Map<String, double> defaultWeights;
  final Map<String, double> algorithmParameters;
  final int defaultMaxResults;
  final double defaultMinScore;
  final bool enableRealTimeUpdates;
  final int cacheExpirationMinutes;
  final int maxConcurrentRequests;
  final Map<String, dynamic> modelEndpoints;
  final bool enableFallbackMatching;
  final Map<String, dynamic> featureFlags;

  const AIMatchingConfigEntity({
    required this.id,
    required this.defaultWeights,
    required this.algorithmParameters,
    required this.defaultMaxResults,
    required this.defaultMinScore,
    this.enableRealTimeUpdates = true,
    this.cacheExpirationMinutes = 60,
    this.maxConcurrentRequests = 10,
    required this.modelEndpoints,
    this.enableFallbackMatching = true,
    this.featureFlags = const {},
  });

  @override
  List<Object?> get props => [
        id,
        defaultWeights,
        algorithmParameters,
        defaultMaxResults,
        defaultMinScore,
        enableRealTimeUpdates,
        cacheExpirationMinutes,
        maxConcurrentRequests,
        modelEndpoints,
        enableFallbackMatching,
        featureFlags,
      ];
}
