import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/errors/failures.dart';
import '../../../domain/repositories/help_repository.dart';
import '../../../domain/entities/help.dart';

abstract class HelpRemoteDataSource {
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

  Future<Either<Failure, List<HelpCategory>>> getCategories();

  Future<Either<Failure, HelpCategory>> getCategoryById(String categoryId);

  Future<Either<Failure, List<HelpCategory>>> getSubcategories(String parentId);

  Future<Either<Failure, HelpCategory>> createCategory(HelpCategory category);

  Future<Either<Failure, HelpCategory>> updateCategory(String categoryId, HelpCategory category);

  Future<Either<Failure, void>> deleteCategory(String categoryId);

  Future<Either<Failure, void>> reorderCategories(List<String> categoryIds);

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

  Future<Either<Failure, UserHelpHistory>> getUserHelpHistory(String userId);

  Future<Either<Failure, UserHelpHistory>> updateUserHelpHistory(String userId, UserHelpHistory history);

  Future<Either<Failure, HelpSettings>> getUserHelpSettings(String userId);

  Future<Either<Failure, HelpSettings>> updateUserHelpSettings(String userId, HelpSettings settings);

  Future<Either<Failure, void>> submitFeedback(HelpFeedback feedback);

  Future<Either<Failure, List<HelpFeedback>>> getArticleFeedback(String articleId);

  Future<Either<Failure, List<HelpFeedback>>> getUserFeedback(String userId);

  Future<Either<Failure, void>> resolveFeedback(String feedbackId, String resolvedBy);

  Future<Either<Failure, HelpStats>> getHelpStats();

  Future<Either<Failure, Map<String, int>>> getArticleViewsByCategory();

  Future<Either<Failure, Map<String, int>>> getPopularSearchTerms({
    int limit = 20,
  });

  Future<Either<Failure, Map<String, double>>> getCategorySatisfaction();

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

  Future<Either<Failure, List<HelpArticle>>> getRelatedArticles(String articleId, {
    int limit = 5,
  });

  Future<Either<Failure, List<HelpArticle>>> getRecommendedArticles(String userId, {
    int limit = 10,
  });

  Future<Either<Failure, void>> reportArticle(String articleId, String userId, String reason);

  Future<Either<Failure, List<HelpArticle>>> getReportedArticles();

  Future<Either<Failure, void>> refreshArticlesCache();

  Future<Either<Failure, void>> refreshCategoriesCache();

  Future<Either<Failure, void>> refreshFAQCache();

  Future<Either<Failure, void>> clearAllCaches();
}

class HelpRemoteDataSourceImpl implements HelpRemoteDataSource {
  final String _baseUrl;

  HelpRemoteDataSourceImpl({String baseUrl = 'https://api.bogazicibarter.com/v1'})
      : _baseUrl = baseUrl;

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
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (categoryId != null) 'categoryId': categoryId,
        if (subcategoryId != null) 'subcategoryId': subcategoryId,
        if (type != null) 'type': type.value,
        if (priority != null) 'priority': priority.value,
      };

      final uri = Uri.parse('$_baseUrl/help/articles').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get articles'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpArticle>> getArticleById(String articleId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final article = HelpArticle.fromJson(data['data']);
        return Right(article);
      } else {
        return Left(ServerFailure('Failed to get article'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpArticle>> createArticle(HelpArticle article) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(article.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdArticle = HelpArticle.fromJson(data['data']);
        return Right(createdArticle);
      } else {
        return Left(ServerFailure('Failed to create article'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpArticle>> updateArticle(String articleId, HelpArticle article) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(article.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedArticle = HelpArticle.fromJson(data['data']);
        return Right(updatedArticle);
      } else {
        return Left(ServerFailure('Failed to update article'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteArticle(String articleId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId');
      final response = await http.delete(uri);

      if (response.statusCode == 204) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to delete article'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> publishArticle(String articleId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/publish');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to publish article'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unpublishArticle(String articleId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/unpublish');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to unpublish article'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementArticleViews(String articleId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/views');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to increment article views'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markArticleAsHelpful(String articleId, String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/helpful');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to mark article as helpful'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markArticleAsNotHelpful(String articleId, String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/not-helpful');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to mark article as not helpful'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> bookmarkArticle(String articleId, String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/bookmark');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to bookmark article'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String articleId, String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/bookmark');
      final response = await http.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to remove bookmark'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getBookmarkedArticles(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/bookmarks');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get bookmarked articles'));
      }
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
      final queryParams = {
        'limit': limit.toString(),
        if (categoryId != null) 'categoryId': categoryId,
      };

      final uri = Uri.parse('$_baseUrl/help/articles/popular').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get popular articles'));
      }
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
      final queryParams = {
        'limit': limit.toString(),
        if (categoryId != null) 'categoryId': categoryId,
      };

      final uri = Uri.parse('$_baseUrl/help/articles/recent').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get recent articles'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpCategory>>> getCategories() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/categories');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categories = (data['data'] as List)
            .map((json) => HelpCategory.fromJson(json))
            .toList();

        return Right(categories);
      } else {
        return Left(ServerFailure('Failed to get categories'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpCategory>> getCategoryById(String categoryId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/categories/$categoryId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final category = HelpCategory.fromJson(data['data']);
        return Right(category);
      } else {
        return Left(ServerFailure('Failed to get category'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpCategory>>> getSubcategories(String parentId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/categories/$parentId/subcategories');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categories = (data['data'] as List)
            .map((json) => HelpCategory.fromJson(json))
            .toList();

        return Right(categories);
      } else {
        return Left(ServerFailure('Failed to get subcategories'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpCategory>> createCategory(HelpCategory category) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/categories');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdCategory = HelpCategory.fromJson(data['data']);
        return Right(createdCategory);
      } else {
        return Left(ServerFailure('Failed to create category'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpCategory>> updateCategory(String categoryId, HelpCategory category) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/categories/$categoryId');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedCategory = HelpCategory.fromJson(data['data']);
        return Right(updatedCategory);
      } else {
        return Left(ServerFailure('Failed to update category'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String categoryId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/categories/$categoryId');
      final response = await http.delete(uri);

      if (response.statusCode == 204) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to delete category'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reorderCategories(List<String> categoryIds) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/categories/reorder');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'categoryIds': categoryIds}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to reorder categories'));
      }
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
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (categoryId != null) 'categoryId': categoryId,
      };

      final uri = Uri.parse('$_baseUrl/help/faqs').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final faqs = (data['data'] as List)
            .map((json) => FAQ.fromJson(json))
            .toList();

        return Right(faqs);
      } else {
        return Left(ServerFailure('Failed to get FAQs'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FAQ>> getFAQById(String faqId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/faqs/$faqId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final faq = FAQ.fromJson(data['data']);
        return Right(faq);
      } else {
        return Left(ServerFailure('Failed to get FAQ'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FAQ>> createFAQ(FAQ faq) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/faqs');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(faq.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdFAQ = FAQ.fromJson(data['data']);
        return Right(createdFAQ);
      } else {
        return Left(ServerFailure('Failed to create FAQ'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FAQ>> updateFAQ(String faqId, FAQ faq) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/faqs/$faqId');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(faq.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedFAQ = FAQ.fromJson(data['data']);
        return Right(updatedFAQ);
      } else {
        return Left(ServerFailure('Failed to update FAQ'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFAQ(String faqId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/faqs/$faqId');
      final response = await http.delete(uri);

      if (response.statusCode == 204) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to delete FAQ'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markFAQAsPopular(String faqId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/faqs/$faqId/popular');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to mark FAQ as popular'));
      }
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
      final queryParams = {
        'limit': limit.toString(),
        if (categoryId != null) 'categoryId': categoryId,
      };

      final uri = Uri.parse('$_baseUrl/help/faqs/popular').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final faqs = (data['data'] as List)
            .map((json) => FAQ.fromJson(json))
            .toList();

        return Right(faqs);
      } else {
        return Left(ServerFailure('Failed to get popular FAQs'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpSearchResult>>> searchArticles(HelpSearchRequest request) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/search');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = (data['data'] as List)
            .map((json) => HelpSearchResult.fromJson(json))
            .toList();

        return Right(results);
      } else {
        return Left(ServerFailure('Failed to search articles'));
      }
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
      final queryParams = {
        'q': query,
        'limit': limit.toString(),
        if (categoryId != null) 'categoryId': categoryId,
      };

      final uri = Uri.parse('$_baseUrl/help/search/suggestions').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final suggestions = (data['data'] as List).map((s) => s.toString()).toList();
        return Right(suggestions);
      } else {
        return Left(ServerFailure('Failed to get search suggestions'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchTerm(String userId, String query) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/search-history');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to save search term'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches(String userId, {
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/search-history?limit=$limit');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final searches = (data['data'] as List).map((s) => s.toString()).toList();
        return Right(searches);
      } else {
        return Left(ServerFailure('Failed to get recent searches'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/search-history');
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to clear search history'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserHelpHistory>> getUserHelpHistory(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/history');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final history = UserHelpHistory.fromJson(data['data']);
        return Right(history);
      } else {
        return Left(ServerFailure('Failed to get user help history'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserHelpHistory>> updateUserHelpHistory(String userId, UserHelpHistory history) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/history');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(history.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedHistory = UserHelpHistory.fromJson(data['data']);
        return Right(updatedHistory);
      } else {
        return Left(ServerFailure('Failed to update user help history'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpSettings>> getUserHelpSettings(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/settings');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final settings = HelpSettings.fromJson(data['data']);
        return Right(settings);
      } else {
        return Left(ServerFailure('Failed to get user help settings'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpSettings>> updateUserHelpSettings(String userId, HelpSettings settings) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/settings');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(settings.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedSettings = HelpSettings.fromJson(data['data']);
        return Right(updatedSettings);
      } else {
        return Left(ServerFailure('Failed to update user help settings'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitFeedback(HelpFeedback feedback) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/feedback');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(feedback.toJson()),
      );

      if (response.statusCode == 201) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to submit feedback'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpFeedback>>> getArticleFeedback(String articleId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/feedback');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final feedback = (data['data'] as List)
            .map((json) => HelpFeedback.fromJson(json))
            .toList();

        return Right(feedback);
      } else {
        return Left(ServerFailure('Failed to get article feedback'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpFeedback>>> getUserFeedback(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/feedback');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final feedback = (data['data'] as List)
            .map((json) => HelpFeedback.fromJson(json))
            .toList();

        return Right(feedback);
      } else {
        return Left(ServerFailure('Failed to get user feedback'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resolveFeedback(String feedbackId, String resolvedBy) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/feedback/$feedbackId/resolve');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'resolvedBy': resolvedBy}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to resolve feedback'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HelpStats>> getHelpStats() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/stats');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final stats = HelpStats.fromJson(data['data']);
        return Right(stats);
      } else {
        return Left(ServerFailure('Failed to get help stats'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getArticleViewsByCategory() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/stats/views-by-category');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final viewsByCategory = Map<String, int>.from(data['data']);
        return Right(viewsByCategory);
      } else {
        return Left(ServerFailure('Failed to get article views by category'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getPopularSearchTerms({
    int limit = 20,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/stats/popular-searches?limit=$limit');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final searchTerms = Map<String, int>.from(data['data']);
        return Right(searchTerms);
      } else {
        return Left(ServerFailure('Failed to get popular search terms'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getCategorySatisfaction() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/stats/category-satisfaction');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final satisfaction = Map<String, double>.from(data['data']);
        return Right(satisfaction);
      } else {
        return Left(ServerFailure('Failed to get category satisfaction'));
      }
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
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$_baseUrl/help/authors/$authorId/articles').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get articles by author'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getArticlesNeedingReview() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/needing-review');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get articles needing review'));
      }
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
      final uri = Uri.parse('$_baseUrl/help/articles/bulk-update');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'articleIds': articleIds,
          'type': type?.value,
          'priority': priority?.value,
          'isPublished': isPublished,
        }),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to bulk update articles'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> importArticles(List<HelpArticle> articles) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/import');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'articles': articles.map((a) => a.toJson()).toList()}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to import articles'));
      }
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
      final queryParams = {
        if (categoryId != null) 'categoryId': categoryId,
        if (type != null) 'type': type.value,
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      };

      final uri = Uri.parse('$_baseUrl/help/articles/export').replace(queryParameters: queryParams);
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to export articles'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getRelatedArticles(String articleId, {
    int limit = 5,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/related?limit=$limit');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get related articles'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getRecommendedArticles(String userId, {
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/users/$userId/recommendations?limit=$limit');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get recommended articles'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reportArticle(String articleId, String userId, String reason) async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/$articleId/report');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'reason': reason}),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to report article'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HelpArticle>>> getReportedArticles() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/articles/reported');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['data'] as List)
            .map((json) => HelpArticle.fromJson(json))
            .toList();

        return Right(articles);
      } else {
        return Left(ServerFailure('Failed to get reported articles'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshArticlesCache() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/cache/articles/refresh');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to refresh articles cache'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshCategoriesCache() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/cache/categories/refresh');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to refresh categories cache'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshFAQCache() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/cache/faqs/refresh');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to refresh FAQ cache'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllCaches() async {
    try {
      final uri = Uri.parse('$_baseUrl/help/cache/clear');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to clear all caches'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
