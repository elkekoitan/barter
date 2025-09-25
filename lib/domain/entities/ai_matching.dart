import 'package:equatable/equatable.dart';

class AIMatchingEntity extends Equatable {
  final String id;
  final String userId;
  final String targetUserId;
  final List<MatchedItem> matchedItems;
  final MatchingScore overallScore;
  final List<MatchingCriteria> criteria;
  final MatchQuality quality;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;
  final Map<String, dynamic>? metadata;

  const AIMatchingEntity({
    required this.id,
    required this.userId,
    required this.targetUserId,
    required this.matchedItems,
    required this.overallScore,
    required this.criteria,
    this.quality = MatchQuality.medium,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
    this.metadata,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  bool get hasHighQualityMatch => quality == MatchQuality.high;

  bool get hasCompatibleItems => matchedItems.any((item) => item.compatibilityScore >= 0.7);

  double get averageCompatibility => matchedItems.isEmpty
      ? 0.0
      : matchedItems.map((item) => item.compatibilityScore).reduce((a, b) => a + b) / matchedItems.length;

  @override
  List<Object?> get props => [
        id,
        userId,
        targetUserId,
        matchedItems,
        overallScore,
        criteria,
        quality,
        isActive,
        createdAt,
        updatedAt,
        expiresAt,
        metadata,
      ];
}

class MatchedItem extends Equatable {
  final String listingId;
  final String itemName;
  final String itemDescription;
  final List<String> categories;
  final double compatibilityScore;
  final List<CompatibilityFactor> factors;
  final MatchReason reason;
  final Map<String, dynamic>? itemData;
  final List<String>? tags;
  final double? priceCompatibility;
  final double? conditionCompatibility;
  final double? locationCompatibility;

  const MatchedItem({
    required this.listingId,
    required this.itemName,
    required this.itemDescription,
    required this.categories,
    required this.compatibilityScore,
    required this.factors,
    this.reason = MatchReason.similarity,
    this.itemData,
    this.tags,
    this.priceCompatibility,
    this.conditionCompatibility,
    this.locationCompatibility,
  });

  bool get isHighlyCompatible => compatibilityScore >= 0.8;

  bool get isModeratelyCompatible => compatibilityScore >= 0.6 && compatibilityScore < 0.8;

  bool get isLowCompatible => compatibilityScore < 0.6;

  String get compatibilityLabel {
    if (isHighlyCompatible) return 'Mükemmel Uyum';
    if (isModeratelyCompatible) return 'İyi Uyum';
    return 'Düşük Uyum';
  }

  @override
  List<Object?> get props => [
        listingId,
        itemName,
        itemDescription,
        categories,
        compatibilityScore,
        factors,
        reason,
        itemData,
        tags,
        priceCompatibility,
        conditionCompatibility,
        locationCompatibility,
      ];
}

class CompatibilityFactor extends Equatable {
  final String factorName;
  final double score;
  final double weight;
  final String description;
  final FactorType type;
  final bool isPositive;

  const CompatibilityFactor({
    required this.factorName,
    required this.score,
    required this.weight,
    required this.description,
    required this.type,
    this.isPositive = true,
  });

  double get weightedScore => score * weight;

  @override
  List<Object?> get props => [
        factorName,
        score,
        weight,
        description,
        type,
        isPositive,
      ];
}

enum FactorType {
  category('category', 'Kategori'),
  condition('condition', 'Durum'),
  price('price', 'Fiyat'),
  location('location', 'Konum'),
  brand('brand', 'Marka'),
  model('model', 'Model'),
  age('age', 'Yaş'),
  quality('quality', 'Kalite'),
  popularity('popularity', 'Popülerlik'),
  userPreference('user_preference', 'Kullanıcı Tercihi');

  const FactorType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum MatchReason {
  similarity('similarity', 'Benzerlik'),
  complementarity('complementarity', 'Tamamlayıcılık'),
  userPreference('user_preference', 'Kullanıcı Tercihi'),
  popularity('popularity', 'Popülerlik'),
  recentActivity('recent_activity', 'Son Aktivite'),
  location('location', 'Konum'),
  price('price', 'Fiyat');

  const MatchReason(this.value, this.displayName);
  final String value;
  final String displayName;
}

class MatchingScore extends Equatable {
  final double overallScore;
  final double confidence;
  final List<ScoreBreakdown> breakdown;
  final Map<String, double> categoryScores;
  final DateTime calculatedAt;

  const MatchingScore({
    required this.overallScore,
    required this.confidence,
    required this.breakdown,
    required this.categoryScores,
    required this.calculatedAt,
  });

  bool get isHighConfidence => confidence >= 0.8;

  bool get isMediumConfidence => confidence >= 0.6 && confidence < 0.8;

  bool get isLowConfidence => confidence < 0.6;

  String get confidenceLabel {
    if (isHighConfidence) return 'Yüksek';
    if (isMediumConfidence) return 'Orta';
    return 'Düşük';
  }

  @override
  List<Object?> get props => [
        overallScore,
        confidence,
        breakdown,
        categoryScores,
        calculatedAt,
      ];
}

class ScoreBreakdown extends Equatable {
  final String criterion;
  final double score;
  final double weight;
  final String description;

  const ScoreBreakdown({
    required this.criterion,
    required this.score,
    required this.weight,
    required this.description,
  });

  double get weightedScore => score * weight;

  @override
  List<Object?> get props => [criterion, score, weight, description];
}

enum MatchQuality {
  low('low', 'Düşük', 0.0, 0.4),
  medium('medium', 'Orta', 0.4, 0.7),
  high('high', 'Yüksek', 0.7, 1.0);

  const MatchQuality(this.value, this.displayName, this.minScore, this.maxScore);
  final String value;
  final String displayName;
  final double minScore;
  final double maxScore;

  static MatchQuality fromScore(double score) {
    if (score >= MatchQuality.high.minScore) return MatchQuality.high;
    if (score >= MatchQuality.medium.minScore) return MatchQuality.medium;
    return MatchQuality.low;
  }
}

class MatchingCriteria extends Equatable {
  final String id;
  final String name;
  final double weight;
  final bool isRequired;
  final List<String> values;
  final CriteriaType type;
  final MatchingAlgorithm algorithm;

  const MatchingCriteria({
    required this.id,
    required this.name,
    required this.weight,
    this.isRequired = false,
    required this.values,
    required this.type,
    required this.algorithm,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        weight,
        isRequired,
        values,
        type,
        algorithm,
      ];
}

enum CriteriaType {
  category('category', 'Kategori'),
  condition('condition', 'Durum'),
  priceRange('price_range', 'Fiyat Aralığı'),
  location('location', 'Konum'),
  brand('brand', 'Marka'),
  model('model', 'Model'),
  age('age', 'Yaş'),
  tags('tags', 'Etiketler'),
  userPreference('user_preference', 'Kullanıcı Tercihi');

  const CriteriaType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum MatchingAlgorithm {
  exact('exact', 'Tam Eşleşme'),
  fuzzy('fuzzy', 'Bulanık Eşleşme'),
  semantic('semantic', 'Anlamsal Eşleşme'),
  collaborative('collaborative', 'İşbirlikçi Filtreleme'),
  contentBased('content_based', 'İçerik Tabanlı'),
  hybrid('hybrid', 'Hibrit');

  const MatchingAlgorithm(this.value, this.displayName);
  final String value;
  final String displayName;
}

class UserPreferenceEntity extends Equatable {
  final String userId;
  final List<PreferenceCategory> preferredCategories;
  final List<PreferenceCondition> preferredConditions;
  final PriceRange preferredPriceRange;
  final List<String> preferredBrands;
  final List<String> preferredLocations;
  final List<String> excludedCategories;
  final List<String> excludedBrands;
  final Map<String, double> categoryWeights;
  final Map<String, double> featureWeights;
  final int minCompatibilityScore;
  final bool prioritizeQuality;
  final bool prioritizePrice;
  final bool prioritizeLocation;
  final DateTime lastUpdated;
  final Map<String, dynamic>? metadata;

  const UserPreferenceEntity({
    required this.userId,
    this.preferredCategories = const [],
    this.preferredConditions = const [],
    this.preferredPriceRange = const PriceRange(min: 0, max: 1000000),
    this.preferredBrands = const [],
    this.preferredLocations = const [],
    this.excludedCategories = const [],
    this.excludedBrands = const [],
    this.categoryWeights = const {},
    this.featureWeights = const {},
    this.minCompatibilityScore = 60,
    this.prioritizeQuality = false,
    this.prioritizePrice = false,
    this.prioritizeLocation = false,
    required this.lastUpdated,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        userId,
        preferredCategories,
        preferredConditions,
        preferredPriceRange,
        preferredBrands,
        preferredLocations,
        excludedCategories,
        excludedBrands,
        categoryWeights,
        featureWeights,
        minCompatibilityScore,
        prioritizeQuality,
        prioritizePrice,
        prioritizeLocation,
        lastUpdated,
        metadata,
      ];
}

class PreferenceCategory extends Equatable {
  final String categoryId;
  final String categoryName;
  final double weight;
  final bool isActive;

  const PreferenceCategory({
    required this.categoryId,
    required this.categoryName,
    this.weight = 1.0,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, weight, isActive];
}

class PreferenceCondition extends Equatable {
  final String condition;
  final double weight;
  final bool isPreferred;

  const PreferenceCondition({
    required this.condition,
    this.weight = 1.0,
    this.isPreferred = true,
  });

  @override
  List<Object?> get props => [condition, weight, isPreferred];
}

class PriceRange extends Equatable {
  final double min;
  final double max;
  final String currency;

  const PriceRange({
    required this.min,
    required this.max,
    this.currency = 'TRY',
  });

  bool contains(double price) => price >= min && price <= max;

  double get average => (min + max) / 2;

  @override
  List<Object?> get props => [min, max, currency];
}

class AIRecommendationEntity extends Equatable {
  final String id;
  final String userId;
  final List<RecommendedItem> recommendations;
  final RecommendationType type;
  final double confidence;
  final String reason;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final Map<String, dynamic>? metadata;

  const AIRecommendationEntity({
    required this.id,
    required this.userId,
    required this.recommendations,
    required this.type,
    required this.confidence,
    required this.reason,
    required this.generatedAt,
    required this.expiresAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        recommendations,
        type,
        confidence,
        reason,
        generatedAt,
        expiresAt,
        metadata,
      ];
}

class RecommendedItem extends Equatable {
  final String listingId;
  final String title;
  final String description;
  final List<String> categories;
  final double recommendationScore;
  final List<RecommendationFactor> factors;
  final RecommendationReason reason;
  final String? imageUrl;
  final Map<String, dynamic>? itemData;

  const RecommendedItem({
    required this.listingId,
    required this.title,
    required this.description,
    required this.categories,
    required this.recommendationScore,
    required this.factors,
    required this.reason,
    this.imageUrl,
    this.itemData,
  });

  @override
  List<Object?> get props => [
        listingId,
        title,
        description,
        categories,
        recommendationScore,
        factors,
        reason,
        imageUrl,
        itemData,
      ];
}

class RecommendationFactor extends Equatable {
  final String factorName;
  final double score;
  final double weight;
  final String description;
  final bool isPositive;

  const RecommendationFactor({
    required this.factorName,
    required this.score,
    required this.weight,
    required this.description,
    this.isPositive = true,
  });

  double get weightedScore => score * weight;

  @override
  List<Object?> get props => [factorName, score, weight, description, isPositive];
}

enum RecommendationType {
  personalized('personalized', 'Kişiselleştirilmiş'),
  trending('trending', 'Trend Olan'),
  similarUsers('similar_users', 'Benzer Kullanıcılar'),
  categoryBased('category_based', 'Kategori Tabanlı'),
  locationBased('location_based', 'Konum Tabanlı'),
  priceBased('price_based', 'Fiyat Tabanlı');

  const RecommendationType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum RecommendationReason {
  userPreference('user_preference', 'Kullanıcı Tercihi'),
  popularity('popularity', 'Popülerlik'),
  similarity('similarity', 'Benzerlik'),
  complementarity('complementarity', 'Tamamlayıcılık'),
  recentActivity('recent_activity', 'Son Aktivite'),
  seasonal('seasonal', 'Mevsimsel');

  const RecommendationReason(this.value, this.displayName);
  final String value;
  final String displayName;
}

class AIModelEntity extends Equatable {
  final String id;
  final String name;
  final String version;
  final ModelType type;
  final ModelStatus status;
  final double accuracy;
  final int totalPredictions;
  final int correctPredictions;
  final DateTime trainedAt;
  final DateTime lastUsedAt;
  final Map<String, dynamic> parameters;
  final List<String> features;
  final Map<String, dynamic>? metadata;

  const AIModelEntity({
    required this.id,
    required this.name,
    required this.version,
    required this.type,
    required this.status,
    required this.accuracy,
    required this.totalPredictions,
    required this.correctPredictions,
    required this.trainedAt,
    required this.lastUsedAt,
    required this.parameters,
    required this.features,
    this.metadata,
  });

  double get precision => totalPredictions > 0
      ? correctPredictions / totalPredictions
      : 0.0;

  bool get isActive => status == ModelStatus.active;

  String get modelIdentifier => '$name-v$version';

  @override
  List<Object?> get props => [
        id,
        name,
        version,
        type,
        status,
        accuracy,
        totalPredictions,
        correctPredictions,
        trainedAt,
        lastUsedAt,
        parameters,
        features,
        metadata,
      ];
}

enum ModelType {
  classification('classification', 'Sınıflandırma'),
  regression('regression', 'Regresyon'),
  clustering('clustering', 'Kümeleme'),
  recommendation('recommendation', 'Öneri'),
  matching('matching', 'Eşleştirme');

  const ModelType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ModelStatus {
  training('training', 'Eğitiliyor'),
  active('active', 'Aktif'),
  inactive('inactive', 'Pasif'),
  deprecated('deprecated', 'Kullanım Dışı');

  const ModelStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

class AITrainingDataEntity extends Equatable {
  final String id;
  final String modelId;
  final List<TrainingSample> trainingSamples;
  final List<TrainingSample> validationSamples;
  final List<TrainingSample> testSamples;
  final Map<String, dynamic> parameters;
  final TrainingStatus status;
  final double? trainingAccuracy;
  final double? validationAccuracy;
  final int epochs;
  final int currentEpoch;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? errorMessage;

  const AITrainingDataEntity({
    required this.id,
    required this.modelId,
    required this.trainingSamples,
    required this.validationSamples,
    required this.testSamples,
    required this.parameters,
    required this.status,
    this.trainingAccuracy,
    this.validationAccuracy,
    required this.epochs,
    this.currentEpoch = 0,
    required this.createdAt,
    this.completedAt,
    this.errorMessage,
  });

  bool get isCompleted => status == TrainingStatus.completed;

  bool get isFailed => status == TrainingStatus.failed;

  bool get isInProgress => status == TrainingStatus.training;

  double get progress => epochs > 0 ? (currentEpoch / epochs) * 100 : 0.0;

  @override
  List<Object?> get props => [
        id,
        modelId,
        trainingSamples,
        validationSamples,
        testSamples,
        parameters,
        status,
        trainingAccuracy,
        validationAccuracy,
        epochs,
        currentEpoch,
        createdAt,
        completedAt,
        errorMessage,
      ];
}

class TrainingSample extends Equatable {
  final String id;
  final List<double> features;
  final List<double> labels;
  final Map<String, dynamic>? metadata;
  final double weight;

  const TrainingSample({
    required this.id,
    required this.features,
    required this.labels,
    this.metadata,
    this.weight = 1.0,
  });

  @override
  List<Object?> get props => [id, features, labels, metadata, weight];
}

enum TrainingStatus {
  pending('pending', 'Bekliyor'),
  training('training', 'Eğitiliyor'),
  completed('completed', 'Tamamlandı'),
  failed('failed', 'Başarısız');

  const TrainingStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

class AIMatchingStatsEntity extends Equatable {
  final int totalMatches;
  final int highQualityMatches;
  final int successfulMatches;
  final double averageCompatibilityScore;
  final Map<String, int> matchesByCategory;
  final Map<String, int> matchesByQuality;
  final List<MatchingTrend> matchingTrends;
  final List<PopularMatch> popularMatches;
  final DateTime generatedAt;

  const AIMatchingStatsEntity({
    required this.totalMatches,
    required this.highQualityMatches,
    required this.successfulMatches,
    required this.averageCompatibilityScore,
    required this.matchesByCategory,
    required this.matchesByQuality,
    required this.matchingTrends,
    required this.popularMatches,
    required this.generatedAt,
  });

  double get successRate => totalMatches > 0
      ? (successfulMatches / totalMatches) * 100
      : 0.0;

  double get highQualityRate => totalMatches > 0
      ? (highQualityMatches / totalMatches) * 100
      : 0.0;

  @override
  List<Object?> get props => [
        totalMatches,
        highQualityMatches,
        successfulMatches,
        averageCompatibilityScore,
        matchesByCategory,
        matchesByQuality,
        matchingTrends,
        popularMatches,
        generatedAt,
      ];
}

class MatchingTrend extends Equatable {
  final DateTime date;
  final int matchCount;
  final double averageScore;
  final int highQualityCount;

  const MatchingTrend({
    required this.date,
    required this.matchCount,
    required this.averageScore,
    required this.highQualityCount,
  });

  @override
  List<Object?> get props => [date, matchCount, averageScore, highQualityCount];
}

class PopularMatch extends Equatable {
  final String category;
  final int matchCount;
  final double averageScore;
  final String topItem;

  const PopularMatch({
    required this.category,
    required this.matchCount,
    required this.averageScore,
    required this.topItem,
  });

  @override
  List<Object?> get props => [category, matchCount, averageScore, topItem];
}

class AIMatchingRequestEntity extends Equatable {
  final String id;
  final String userId;
  final MatchingRequestType type;
  final List<String> targetCategories;
  final PriceRange? priceRange;
  final List<String> preferredBrands;
  final List<String> preferredLocations;
  final Map<String, double> customWeights;
  final int maxResults;
  final double minCompatibilityScore;
  final bool includeUserPreferences;
  final DateTime requestedAt;
  final Map<String, dynamic>? parameters;

  const AIMatchingRequestEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.targetCategories,
    this.priceRange,
    this.preferredBrands = const [],
    this.preferredLocations = const [],
    this.customWeights = const {},
    this.maxResults = 20,
    this.minCompatibilityScore = 0.6,
    this.includeUserPreferences = true,
    required this.requestedAt,
    this.parameters,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        targetCategories,
        priceRange,
        preferredBrands,
        preferredLocations,
        customWeights,
        maxResults,
        minCompatibilityScore,
        includeUserPreferences,
        requestedAt,
        parameters,
      ];
}

enum MatchingRequestType {
  general('general', 'Genel'),
  barter('barter', 'Takas'),
  purchase('purchase', 'Satın Alma'),
  categorySpecific('category_specific', 'Kategori Bazlı'),
  locationBased('location_based', 'Konum Bazlı');

  const MatchingRequestType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class AIMatchingResponseEntity extends Equatable {
  final String requestId;
  final List<AIMatchingEntity> matches;
  final int totalMatches;
  final double averageScore;
  final DateTime respondedAt;
  final String modelUsed;
  final double processingTimeMs;
  final Map<String, dynamic>? metadata;

  const AIMatchingResponseEntity({
    required this.requestId,
    required this.matches,
    required this.totalMatches,
    required this.averageScore,
    required this.respondedAt,
    required this.modelUsed,
    required this.processingTimeMs,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        requestId,
        matches,
        totalMatches,
        averageScore,
        respondedAt,
        modelUsed,
        processingTimeMs,
        metadata,
      ];
}
