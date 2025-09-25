import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/help.dart';
import '../../domain/repositories/help_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/remote/help_remote_datasource.dart';

class HelpRepositoryImpl implements HelpRepository {
  final HelpRemoteDataSource _remoteDataSource;

  const HelpRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<HelpArticle>>> getArticles({
    String? categoryId,
    String? subcategoryId,
    ArticleType? type,
    ArticlePriority? priority,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _remoteDataSource.getArticles(
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        type: type,
        priority: priority,
        page: page,
        limit: limit,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpArticle>> getArticleById(String articleId) async {
    try {
      return await _remoteDataSource.getArticleById(articleId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpArticle>> createArticle(HelpArticle article) async {
    try {
      return await _remoteDataSource.createArticle(article);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpArticle>> updateArticle(String articleId, HelpArticle article) async {
    try {
      return await _remoteDataSource.updateArticle(articleId, article);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteArticle(String articleId) async {
    try {
      return await _remoteDataSource.deleteArticle(articleId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> publishArticle(String articleId) async {
    try {
      return await _remoteDataSource.publishArticle(articleId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unpublishArticle(String articleId) async {
    try {
      return await _remoteDataSource.unpublishArticle(articleId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementArticleViews(String articleId) async {
    try {
      return await _remoteDataSource.incrementArticleViews(articleId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markArticleAsHelpful(String articleId, String userId) async {
    try {
      return await _remoteDataSource.markArticleAsHelpful(articleId, userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markArticleAsNotHelpful(String articleId, String userId) async {
    try {
      return await _remoteDataSource.markArticleAsNotHelpful(articleId, userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> bookmarkArticle(String articleId, String userId) async {
    try {
      return await _remoteDataSource.bookmarkArticle(articleId, userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String articleId, String userId) async {
    try {
      return await _remoteDataSource.removeBookmark(articleId, userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getBookmarkedArticles(String userId) async {
    try {
      return await _remoteDataSource.getBookmarkedArticles(userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getPopularArticles({
    int limit = 10,
    String? categoryId,
  }) async {
    try {
      return await _remoteDataSource.getPopularArticles(
        limit: limit,
        categoryId: categoryId,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getRecentArticles({
    int limit = 10,
    String? categoryId,
  }) async {
    try {
      return await _remoteDataSource.getRecentArticles(
        limit: limit,
        categoryId: categoryId,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpCategory>>> getCategories() async {
    try {
      return await _remoteDataSource.getCategories();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpCategory>> getCategoryById(String categoryId) async {
    try {
      return await _remoteDataSource.getCategoryById(categoryId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpCategory>>> getSubcategories(String parentId) async {
    try {
      return await _remoteDataSource.getSubcategories(parentId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpCategory>> createCategory(HelpCategory category) async {
    try {
      return await _remoteDataSource.createCategory(category);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpCategory>> updateCategory(String categoryId, HelpCategory category) async {
    try {
      return await _remoteDataSource.updateCategory(categoryId, category);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String categoryId) async {
    try {
      return await _remoteDataSource.deleteCategory(categoryId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reorderCategories(List<String> categoryIds) async {
    try {
      return await _remoteDataSource.reorderCategories(categoryIds);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FAQ>>> getFAQs({
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _remoteDataSource.getFAQs(
        categoryId: categoryId,
        page: page,
        limit: limit,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FAQ>> getFAQById(String faqId) async {
    try {
      return await _remoteDataSource.getFAQById(faqId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FAQ>> createFAQ(FAQ faq) async {
    try {
      return await _remoteDataSource.createFAQ(faq);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FAQ>> updateFAQ(String faqId, FAQ faq) async {
    try {
      return await _remoteDataSource.updateFAQ(faqId, faq);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFAQ(String faqId) async {
    try {
      return await _remoteDataSource.deleteFAQ(faqId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markFAQAsPopular(String faqId) async {
    try {
      return await _remoteDataSource.markFAQAsPopular(faqId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FAQ>>> getPopularFAQs({
    int limit = 10,
    String? categoryId,
  }) async {
    try {
      return await _remoteDataSource.getPopularFAQs(
        limit: limit,
        categoryId: categoryId,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpSearchResult>>> searchArticles(HelpSearchRequest request) async {
    try {
      return await _remoteDataSource.searchArticles(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions(String query, {
    int limit = 10,
    String? categoryId,
  }) async {
    try {
      return await _remoteDataSource.getSearchSuggestions(
        query,
        limit: limit,
        categoryId: categoryId,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchTerm(String userId, String query) async {
    try {
      return await _remoteDataSource.saveSearchTerm(userId, query);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches(String userId, {
    int limit = 10,
  }) async {
    try {
      return await _remoteDataSource.getRecentSearches(userId, limit: limit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory(String userId) async {
    try {
      return await _remoteDataSource.clearSearchHistory(userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserHelpHistory>> getUserHelpHistory(String userId) async {
    try {
      return await _remoteDataSource.getUserHelpHistory(userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserHelpHistory>> updateUserHelpHistory(String userId, UserHelpHistory history) async {
    try {
      return await _remoteDataSource.updateUserHelpHistory(userId, history);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpSettings>> getUserHelpSettings(String userId) async {
    try {
      return await _remoteDataSource.getUserHelpSettings(userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpSettings>> updateUserHelpSettings(String userId, HelpSettings settings) async {
    try {
      return await _remoteDataSource.updateUserHelpSettings(userId, settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitFeedback(HelpFeedback feedback) async {
    try {
      return await _remoteDataSource.submitFeedback(feedback);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpFeedback>>> getArticleFeedback(String articleId) async {
    try {
      return await _remoteDataSource.getArticleFeedback(articleId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpFeedback>>> getUserFeedback(String userId) async {
    try {
      return await _remoteDataSource.getUserFeedback(userId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resolveFeedback(String feedbackId, String resolvedBy) async {
    try {
      return await _remoteDataSource.resolveFeedback(feedbackId, resolvedBy);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpStats>> getHelpStats() async {
    try {
      return await _remoteDataSource.getHelpStats();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getArticleViewsByCategory() async {
    try {
      return await _remoteDataSource.getArticleViewsByCategory();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getPopularSearchTerms({
    int limit = 20,
  }) async {
    try {
      return await _remoteDataSource.getPopularSearchTerms(limit: limit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getCategorySatisfaction() async {
    try {
      return await _remoteDataSource.getCategorySatisfaction();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getArticlesByAuthor(String authorId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _remoteDataSource.getArticlesByAuthor(
        authorId,
        page: page,
        limit: limit,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getArticlesNeedingReview() async {
    try {
      return await _remoteDataSource.getArticlesNeedingReview();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> bulkUpdateArticles(List<String> articleIds, {
    ArticleType? type,
    ArticlePriority? priority,
    bool? isPublished,
  }) async {
    try {
      return await _remoteDataSource.bulkUpdateArticles(
        articleIds,
        type: type,
        priority: priority,
        isPublished: isPublished,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> importArticles(List<HelpArticle> articles) async {
    try {
      return await _remoteDataSource.importArticles(articles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> exportArticles({
    String? categoryId,
    ArticleType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      return await _remoteDataSource.exportArticles(
        categoryId: categoryId,
        type: type,
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getRelatedArticles(String articleId, {
    int limit = 5,
  }) async {
    try {
      return await _remoteDataSource.getRelatedArticles(articleId, limit: limit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getRecommendedArticles(String userId, {
    int limit = 10,
  }) async {
    try {
      return await _remoteDataSource.getRecommendedArticles(userId, limit: limit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reportArticle(String articleId, String userId, String reason) async {
    try {
      return await _remoteDataSource.reportArticle(articleId, userId, reason);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getReportedArticles() async {
    try {
      return await _remoteDataSource.getReportedArticles();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshArticlesCache() async {
    try {
      return await _remoteDataSource.refreshArticlesCache();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshCategoriesCache() async {
    try {
      return await _remoteDataSource.refreshCategoriesCache();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshFAQCache() async {
    try {
      return await _remoteDataSource.refreshFAQCache();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllCaches() async {
    try {
      return await _remoteDataSource.clearAllCaches();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
