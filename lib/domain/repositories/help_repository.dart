import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/help.dart';

abstract class HelpRepository {
  // Article Operations
  Future<Either<Failure, List<HelpArticle>>> getArticles({
    String? categoryId,
    String? subcategoryId,
    ArticleType? type,
    ArticlePriority? priority,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, HelpArticle>> getArticleById(String articleId);

  Future<Either<Failure, HelpArticle>> createArticle(HelpArticle article);

  Future<Either<Failure, HelpArticle>> updateArticle(String articleId, HelpArticle article);

  Future<Either<Failure, void>> deleteArticle(String articleId);

  Future<Either<Failure, void>> publishArticle(String articleId);

  Future<Either<Failure, void>> unpublishArticle(String articleId);

  Future<Either<Failure, void>> incrementArticleViews(String articleId);

  Future<Either<Failure, void>> markArticleAsHelpful(String articleId, String userId);

  Future<Either<Failure, void>> markArticleAsNotHelpful(String articleId, String userId);

  Future<Either<Failure, void>> bookmarkArticle(String articleId, String userId);

  Future<Either<Failure, void>> removeBookmark(String articleId, String userId);

  Future<Either<Failure, List<HelpArticle>>> getBookmarkedArticles(String userId);

  Future<Either<Failure, List<HelpArticle>>> getPopularArticles({
    int limit = 10,
    String? categoryId,
  });

  Future<Either<Failure, List<HelpArticle>>> getRecentArticles({
    int limit = 10,
    String? categoryId,
  });

  // Category Operations
  Future<Either<Failure, List<HelpCategory>>> getCategories();

  Future<Either<Failure, HelpCategory>> getCategoryById(String categoryId);

  Future<Either<Failure, List<HelpCategory>>> getSubcategories(String parentId);

  Future<Either<Failure, HelpCategory>> createCategory(HelpCategory category);

  Future<Either<Failure, HelpCategory>> updateCategory(String categoryId, HelpCategory category);

  Future<Either<Failure, void>> deleteCategory(String categoryId);

  Future<Either<Failure, void>> reorderCategories(List<String> categoryIds);

  // FAQ Operations
  Future<Either<Failure, List<FAQ>>> getFAQs({
    String? categoryId,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, FAQ>> getFAQById(String faqId);

  Future<Either<Failure, FAQ>> createFAQ(FAQ faq);

  Future<Either<Failure, FAQ>> updateFAQ(String faqId, FAQ faq);

  Future<Either<Failure, void>> deleteFAQ(String faqId);

  Future<Either<Failure, void>> markFAQAsPopular(String faqId);

  Future<Either<Failure, List<FAQ>>> getPopularFAQs({
    int limit = 10,
    String? categoryId,
  });

  // Search Operations
  Future<Either<Failure, List<HelpSearchResult>>> searchArticles(HelpSearchRequest request);

  Future<Either<Failure, List<String>>> getSearchSuggestions(String query, {
    int limit = 10,
    String? categoryId,
  });

  Future<Either<Failure, void>> saveSearchTerm(String userId, String query);

  Future<Either<Failure, List<String>>> getRecentSearches(String userId, {
    int limit = 10,
  });

  Future<Either<Failure, void>> clearSearchHistory(String userId);

  // User History & Preferences
  Future<Either<Failure, UserHelpHistory>> getUserHelpHistory(String userId);

  Future<Either<Failure, UserHelpHistory>> updateUserHelpHistory(String userId, UserHelpHistory history);

  Future<Either<Failure, HelpSettings>> getUserHelpSettings(String userId);

  Future<Either<Failure, HelpSettings>> updateUserHelpSettings(String userId, HelpSettings settings);

  // Feedback Operations
  Future<Either<Failure, void>> submitFeedback(HelpFeedback feedback);

  Future<Either<Failure, List<HelpFeedback>>> getArticleFeedback(String articleId);

  Future<Either<Failure, List<HelpFeedback>>> getUserFeedback(String userId);

  Future<Either<Failure, void>> resolveFeedback(String feedbackId, String resolvedBy);

  // Stats & Analytics
  Future<Either<Failure, HelpStats>> getHelpStats();

  Future<Either<Failure, Map<String, int>>> getArticleViewsByCategory();

  Future<Either<Failure, Map<String, int>>> getPopularSearchTerms({
    int limit = 20,
  });

  Future<Either<Failure, Map<String, double>>> getCategorySatisfaction();

  // Content Management
  Future<Either<Failure, List<HelpArticle>>> getArticlesByAuthor(String authorId, {
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, List<HelpArticle>>> getArticlesNeedingReview();

  Future<Either<Failure, void>> bulkUpdateArticles(List<String> articleIds, {
    ArticleType? type,
    ArticlePriority? priority,
    bool? isPublished,
  });

  Future<Either<Failure, void>> importArticles(List<HelpArticle> articles);

  Future<Either<Failure, void>> exportArticles({
    String? categoryId,
    ArticleType? type,
    DateTime? fromDate,
    DateTime? toDate,
  });

  // Advanced Features
  Future<Either<Failure, List<HelpArticle>>> getRelatedArticles(String articleId, {
    int limit = 5,
  });

  Future<Either<Failure, List<HelpArticle>>> getRecommendedArticles(String userId, {
    int limit = 10,
  });

  Future<Either<Failure, void>> reportArticle(String articleId, String userId, String reason);

  Future<Either<Failure, List<HelpArticle>>> getReportedArticles();

  // Cache Management
  Future<Either<Failure, void>> refreshArticlesCache();

  Future<Either<Failure, void>> refreshCategoriesCache();

  Future<Either<Failure, void>> refreshFAQCache();

  Future<Either<Failure, void>> clearAllCaches();

  // Real-time Updates
  Stream<Either<Failure, HelpArticle>> subscribeToArticleUpdates(String articleId);

  Stream<Either<Failure, List<HelpArticle>>> subscribeToCategoryArticles(String categoryId);

  Stream<Either<Failure, HelpStats>> subscribeToHelpStats();
}

// Request/Response Models
class CreateArticleRequest {
  final String title;
  final String content;
  final String categoryId;
  final String? subcategoryId;
  final ArticleType type;
  final ArticlePriority priority;
  final List<String> tags;
  final List<String> relatedArticles;
  final String? videoUrl;
  final List<String> images;
  final List<HelpStep> steps;
  final bool requiresAuth;
  final String authorId;
  final Map<String, dynamic>? metadata;

  const CreateArticleRequest({
    required this.title,
    required this.content,
    required this.categoryId,
    this.subcategoryId,
    this.type = ArticleType.article,
    this.priority = ArticlePriority.medium,
    this.tags = const [],
    this.relatedArticles = const [],
    this.videoUrl,
    this.images = const [],
    this.steps = const [],
    this.requiresAuth = false,
    required this.authorId,
    this.metadata,
  });
}

class UpdateArticleRequest extends CreateArticleRequest {
  final String articleId;
  final String? lastEditorId;

  const UpdateArticleRequest({
    required this.articleId,
    required super.title,
    required super.content,
    required super.categoryId,
    super.subcategoryId,
    super.type,
    super.priority,
    super.tags,
    super.relatedArticles,
    super.videoUrl,
    super.images,
    super.steps,
    super.requiresAuth,
    required super.authorId,
    super.metadata,
    this.lastEditorId,
  });
}

class CreateCategoryRequest {
  final String name;
  final String description;
  final String? parentId;
  final int order;
  final String iconName;
  final String color;
  final Map<String, dynamic>? metadata;

  const CreateCategoryRequest({
    required this.name,
    required this.description,
    this.parentId,
    this.order = 0,
    this.iconName = 'help',
    this.color = '#2563EB',
    this.metadata,
  });
}

class CreateFAQRequest {
  final String question;
  final String answer;
  final String categoryId;
  final List<String> tags;
  final Map<String, dynamic>? metadata;

  const CreateFAQRequest({
    required this.question,
    required this.answer,
    required this.categoryId,
    this.tags = const [],
    this.metadata,
  });
}

class SearchArticlesRequest {
  final String query;
  final String? categoryId;
  final String? subcategoryId;
  final ArticleType? type;
  final ArticlePriority? priority;
  final List<String> tags;
  final int page;
  final int limit;
  final SearchSort sortBy;
  final bool includeUnpublished;
  final bool includeDrafts;

  const SearchArticlesRequest({
    required this.query,
    this.categoryId,
    this.subcategoryId,
    this.type,
    this.priority,
    this.tags = const [],
    this.page = 1,
    this.limit = 20,
    this.sortBy = SearchSort.relevance,
    this.includeUnpublished = false,
    this.includeDrafts = false,
  });
}

class GetArticlesByCategoryRequest {
  final String categoryId;
  final String? subcategoryId;
  final ArticleType? type;
  final int page;
  final int limit;
  final bool includeSubcategories;

  const GetArticlesByCategoryRequest({
    required this.categoryId,
    this.subcategoryId,
    this.type,
    this.page = 1,
    this.limit = 20,
    this.includeSubcategories = false,
  });
}

class BulkUpdateRequest {
  final List<String> articleIds;
  final ArticleType? type;
  final ArticlePriority? priority;
  final bool? isPublished;
  final String updatedBy;

  const BulkUpdateRequest({
    required this.articleIds,
    this.type,
    this.priority,
    this.isPublished,
    required this.updatedBy,
  });
}

class ImportArticlesRequest {
  final List<HelpArticle> articles;
  final bool overwriteExisting;
  final String importedBy;

  const ImportArticlesRequest({
    required this.articles,
    this.overwriteExisting = false,
    required this.importedBy,
  });
}

class ExportArticlesRequest {
  final String? categoryId;
  final ArticleType? type;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool includeUnpublished;
  final String requestedBy;

  const ExportArticlesRequest({
    this.categoryId,
    this.type,
    this.fromDate,
    this.toDate,
    this.includeUnpublished = false,
    required this.requestedBy,
  });
}

class HelpReportRequest {
  final String articleId;
  final String userId;
  final String reason;
  final String? description;
  final Map<String, dynamic>? metadata;

  const HelpReportRequest({
    required this.articleId,
    required this.userId,
    required this.reason,
    this.description,
    this.metadata,
  });
}

class UserHelpPreferences {
  final String userId;
  final List<String> preferredCategories;
  final List<ArticleType> preferredTypes;
  final bool showHelpfulTips;
  final bool showVideoContent;
  final bool showImageContent;
  final bool autoBookmark;
  final int maxSearchHistory;
  final Map<String, dynamic>? customPreferences;

  const UserHelpPreferences({
    required this.userId,
    this.preferredCategories = const [],
    this.preferredTypes = const [],
    this.showHelpfulTips = true,
    this.showVideoContent = true,
    this.showImageContent = true,
    this.autoBookmark = false,
    this.maxSearchHistory = 50,
    this.customPreferences,
  });
}

class HelpAnalyticsData {
  final DateTime date;
  final int totalViews;
  final int uniqueVisitors;
  final int searches;
  final int helpfulVotes;
  final int feedbackCount;
  final Map<String, int> categoryViews;
  final Map<String, int> articleViews;
  final Map<String, int> searchTerms;
  final Map<String, double> satisfactionScores;

  const HelpAnalyticsData({
    required this.date,
    required this.totalViews,
    required this.uniqueVisitors,
    required this.searches,
    required this.helpfulVotes,
    required this.feedbackCount,
    this.categoryViews = const {},
    this.articleViews = const {},
    this.searchTerms = const {},
    this.satisfactionScores = const {},
  });
}
