import 'package:dartz/dartz.dart';
import '../../repositories/help_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/help.dart';

class GetArticlesUseCase {
  final HelpRepository _repository;

  const GetArticlesUseCase(this._repository);

  Future<Either<Failure, List<HelpArticle>>> call({
    String? categoryId,
    String? subcategoryId,
    ArticleType? type,
    ArticlePriority? priority,
    int page = 1,
    int limit = 20,
  }) async {
    // Validation
    if (page < 1) {
      return const Left(ValidationFailure('Page must be greater than 0'));
    }

    if (limit < 1 || limit > 100) {
      return const Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    return await _repository.getArticles(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      type: type,
      priority: priority,
      page: page,
      limit: limit,
    );
  }
}

class GetArticleByIdUseCase {
  final HelpRepository _repository;

  const GetArticleByIdUseCase(this._repository);

  Future<Either<Failure, HelpArticle>> call(String articleId) async {
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    return await _repository.getArticleById(articleId);
  }
}

class CreateArticleUseCase {
  final HelpRepository _repository;

  const CreateArticleUseCase(this._repository);

  Future<Either<Failure, HelpArticle>> call(CreateArticleRequest request) async {
    // Validation
    if (request.title.isEmpty) {
      return const Left(ValidationFailure('Title cannot be empty'));
    }

    if (request.content.isEmpty) {
      return const Left(ValidationFailure('Content cannot be empty'));
    }

    if (request.categoryId.isEmpty) {
      return const Left(ValidationFailure('Category ID cannot be empty'));
    }

    if (request.title.length < 5) {
      return const Left(ValidationFailure('Title must be at least 5 characters'));
    }

    if (request.content.length < 20) {
      return const Left(ValidationFailure('Content must be at least 20 characters'));
    }

    final article = HelpArticle(
      id: 'article_${DateTime.now().millisecondsSinceEpoch}',
      title: request.title,
      content: request.content,
      categoryId: request.categoryId,
      subcategoryId: request.subcategoryId,
      type: request.type,
      priority: request.priority,
      tags: request.tags,
      relatedArticles: request.relatedArticles,
      videoUrl: request.videoUrl,
      images: request.images,
      steps: request.steps,
      requiresAuth: request.requiresAuth,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      authorId: request.authorId,
      metadata: request.metadata,
    );

    return await _repository.createArticle(article);
  }
}

class UpdateArticleUseCase {
  final HelpRepository _repository;

  const UpdateArticleUseCase(this._repository);

  Future<Either<Failure, HelpArticle>> call(String articleId, UpdateArticleRequest request) async {
    // Validation
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    if (request.title.isEmpty) {
      return const Left(ValidationFailure('Title cannot be empty'));
    }

    if (request.content.isEmpty) {
      return const Left(ValidationFailure('Content cannot be empty'));
    }

    final result = await _repository.getArticleById(articleId);
    return result.fold(
      (failure) => Left(failure),
      (existingArticle) async {
        final updatedArticle = existingArticle.copyWith(
          title: request.title,
          content: request.content,
          categoryId: request.categoryId,
          subcategoryId: request.subcategoryId,
          type: request.type,
          priority: request.priority,
          tags: request.tags,
          relatedArticles: request.relatedArticles,
          videoUrl: request.videoUrl,
          images: request.images,
          steps: request.steps,
          requiresAuth: request.requiresAuth,
          updatedAt: DateTime.now(),
        );

        return await _repository.updateArticle(articleId, updatedArticle);
      },
    );
  }
}

class DeleteArticleUseCase {
  final HelpRepository _repository;

  const DeleteArticleUseCase(this._repository);

  Future<Either<Failure, void>> call(String articleId) async {
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    return await _repository.deleteArticle(articleId);
  }
}

class SearchArticlesUseCase {
  final HelpRepository _repository;

  const SearchArticlesUseCase(this._repository);

  Future<Either<Failure, List<HelpSearchResult>>> call(HelpSearchRequest request) async {
    // Validation
    if (request.query.isEmpty) {
      return const Left(ValidationFailure('Search query cannot be empty'));
    }

    if (request.query.length < 2) {
      return const Left(ValidationFailure('Search query too short'));
    }

    if (request.page < 1) {
      return const Left(ValidationFailure('Page must be greater than 0'));
    }

    if (request.limit < 1 || request.limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await _repository.searchArticles(request);
  }
}

class GetCategoriesUseCase {
  final HelpRepository _repository;

  const GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<HelpCategory>>> call() async {
    return await _repository.getCategories();
  }
}

class GetCategoryByIdUseCase {
  final HelpRepository _repository;

  const GetCategoryByIdUseCase(this._repository);

  Future<Either<Failure, HelpCategory>> call(String categoryId) async {
    if (categoryId.isEmpty) {
      return const Left(ValidationFailure('Category ID cannot be empty'));
    }

    return await _repository.getCategoryById(categoryId);
  }
}

class GetSubcategoriesUseCase {
  final HelpRepository _repository;

  const GetSubcategoriesUseCase(this._repository);

  Future<Either<Failure, List<HelpCategory>>> call(String parentId) async {
    if (parentId.isEmpty) {
      return const Left(ValidationFailure('Parent ID cannot be empty'));
    }

    return await _repository.getSubcategories(parentId);
  }
}

class CreateCategoryUseCase {
  final HelpRepository _repository;

  const CreateCategoryUseCase(this._repository);

  Future<Either<Failure, HelpCategory>> call(CreateCategoryRequest request) async {
    // Validation
    if (request.name.isEmpty) {
      return const Left(ValidationFailure('Category name cannot be empty'));
    }

    if (request.description.isEmpty) {
      return const Left(ValidationFailure('Category description cannot be empty'));
    }

    if (request.name.length < 2) {
      return const Left(ValidationFailure('Category name too short'));
    }

    if (request.description.length < 10) {
      return const Left(ValidationFailure('Category description too short'));
    }

    final category = HelpCategory(
      id: 'category_${DateTime.now().millisecondsSinceEpoch}',
      name: request.name,
      description: request.description,
      parentId: request.parentId,
      order: request.order,
      iconName: request.iconName,
      color: request.color,
      createdAt: DateTime.now(),
      metadata: request.metadata,
    );

    return await _repository.createCategory(category);
  }
}

class GetFAQsUseCase {
  final HelpRepository _repository;

  const GetFAQsUseCase(this._repository);

  Future<Either<Failure, List<FAQ>>> call({
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    // Validation
    if (page < 1) {
      return const Left(ValidationFailure('Page must be greater than 0'));
    }

    if (limit < 1 || limit > 100) {
      return const Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    return await _repository.getFAQs(
      categoryId: categoryId,
      page: page,
      limit: limit,
    );
  }
}

class GetPopularFAQsUseCase {
  final HelpRepository _repository;

  const GetPopularFAQsUseCase(this._repository);

  Future<Either<Failure, List<FAQ>>> call({
    int limit = 10,
    String? categoryId,
  }) async {
    if (limit < 1 || limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await _repository.getPopularFAQs(
      limit: limit,
      categoryId: categoryId,
    );
  }
}

class GetPopularArticlesUseCase {
  final HelpRepository _repository;

  const GetPopularArticlesUseCase(this._repository);

  Future<Either<Failure, List<HelpArticle>>> call({
    int limit = 10,
    String? categoryId,
  }) async {
    if (limit < 1 || limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await _repository.getPopularArticles(
      limit: limit,
      categoryId: categoryId,
    );
  }
}

class GetRecentArticlesUseCase {
  final HelpRepository _repository;

  const GetRecentArticlesUseCase(this._repository);

  Future<Either<Failure, List<HelpArticle>>> call({
    int limit = 10,
    String? categoryId,
  }) async {
    if (limit < 1 || limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await _repository.getRecentArticles(
      limit: limit,
      categoryId: categoryId,
    );
  }
}

class MarkArticleAsHelpfulUseCase {
  final HelpRepository _repository;

  const MarkArticleAsHelpfulUseCase(this._repository);

  Future<Either<Failure, void>> call(String articleId, String userId) async {
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await _repository.markArticleAsHelpful(articleId, userId);
  }
}

class BookmarkArticleUseCase {
  final HelpRepository _repository;

  const BookmarkArticleUseCase(this._repository);

  Future<Either<Failure, void>> call(String articleId, String userId) async {
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await _repository.bookmarkArticle(articleId, userId);
  }
}

class GetBookmarkedArticlesUseCase {
  final HelpRepository _repository;

  const GetBookmarkedArticlesUseCase(this._repository);

  Future<Either<Failure, List<HelpArticle>>> call(String userId) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await _repository.getBookmarkedArticles(userId);
  }
}

class GetSearchSuggestionsUseCase {
  final HelpRepository _repository;

  const GetSearchSuggestionsUseCase(this._repository);

  Future<Either<Failure, List<String>>> call(String query, {
    int limit = 10,
    String? categoryId,
  }) async {
    if (query.isEmpty) {
      return const Left(ValidationFailure('Query cannot be empty'));
    }

    if (query.length < 2) {
      return const Left(ValidationFailure('Query too short'));
    }

    if (limit < 1 || limit > 20) {
      return const Left(ValidationFailure('Limit must be between 1 and 20'));
    }

    return await _repository.getSearchSuggestions(query, limit: limit, categoryId: categoryId);
  }
}

class SaveSearchTermUseCase {
  final HelpRepository _repository;

  const SaveSearchTermUseCase(this._repository);

  Future<Either<Failure, void>> call(String userId, String query) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    if (query.isEmpty) {
      return const Left(ValidationFailure('Query cannot be empty'));
    }

    return await _repository.saveSearchTerm(userId, query);
  }
}

class GetRecentSearchesUseCase {
  final HelpRepository _repository;

  const GetRecentSearchesUseCase(this._repository);

  Future<Either<Failure, List<String>>> call(String userId, {
    int limit = 10,
  }) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    if (limit < 1 || limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await _repository.getRecentSearches(userId, limit: limit);
  }
}

class ClearSearchHistoryUseCase {
  final HelpRepository _repository;

  const ClearSearchHistoryUseCase(this._repository);

  Future<Either<Failure, void>> call(String userId) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await _repository.clearSearchHistory(userId);
  }
}

class SubmitHelpFeedbackUseCase {
  final HelpRepository _repository;

  const SubmitHelpFeedbackUseCase(this._repository);

  Future<Either<Failure, void>> call(HelpFeedback feedback) async {
    // Validation
    if (feedback.articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    if (feedback.userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    if (feedback.type == FeedbackType.other && (feedback.comment == null || feedback.comment!.isEmpty)) {
      return const Left(ValidationFailure('Comment is required for other feedback type'));
    }

    if (feedback.rating < 1 || feedback.rating > 5) {
      return const Left(ValidationFailure('Rating must be between 1 and 5'));
    }

    return await _repository.submitFeedback(feedback);
  }
}

class GetHelpStatsUseCase {
  final HelpRepository _repository;

  const GetHelpStatsUseCase(this._repository);

  Future<Either<Failure, HelpStats>> call() async {
    return await _repository.getHelpStats();
  }
}

class GetRecommendedArticlesUseCase {
  final HelpRepository _repository;

  const GetRecommendedArticlesUseCase(this._repository);

  Future<Either<Failure, List<HelpArticle>>> call(String userId, {
    int limit = 10,
  }) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    if (limit < 1 || limit > 50) {
      return const Left(ValidationFailure('Limit must be between 1 and 50'));
    }

    return await _repository.getRecommendedArticles(userId, limit: limit);
  }
}

class GetRelatedArticlesUseCase {
  final HelpRepository _repository;

  const GetRelatedArticlesUseCase(this._repository);

  Future<Either<Failure, List<HelpArticle>>> call(String articleId, {
    int limit = 5,
  }) async {
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    if (limit < 1 || limit > 20) {
      return const Left(ValidationFailure('Limit must be between 1 and 20'));
    }

    return await _repository.getRelatedArticles(articleId, limit: limit);
  }
}

class IncrementArticleViewsUseCase {
  final HelpRepository _repository;

  const IncrementArticleViewsUseCase(this._repository);

  Future<Either<Failure, void>> call(String articleId) async {
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    return await _repository.incrementArticleViews(articleId);
  }
}

class PublishArticleUseCase {
  final HelpRepository _repository;

  const PublishArticleUseCase(this._repository);

  Future<Either<Failure, void>> call(String articleId) async {
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    return await _repository.publishArticle(articleId);
  }
}

class UnpublishArticleUseCase {
  final HelpRepository _repository;

  const UnpublishArticleUseCase(this._repository);

  Future<Either<Failure, void>> call(String articleId) async {
    if (articleId.isEmpty) {
      return const Left(ValidationFailure('Article ID cannot be empty'));
    }

    return await _repository.unpublishArticle(articleId);
  }
}

class ReorderCategoriesUseCase {
  final HelpRepository _repository;

  const ReorderCategoriesUseCase(this._repository);

  Future<Either<Failure, void>> call(List<String> categoryIds) async {
    if (categoryIds.isEmpty) {
      return const Left(ValidationFailure('Category IDs cannot be empty'));
    }

    if (categoryIds.length > 100) {
      return const Left(ValidationFailure('Too many categories to reorder'));
    }

    return await _repository.reorderCategories(categoryIds);
  }
}

class GetArticlesByCategoryUseCase {
  final HelpRepository _repository;

  const GetArticlesByCategoryUseCase(this._repository);

  Future<Either<Failure, List<HelpArticle>>> call(String categoryId, {
    String? subcategoryId,
    int page = 1,
    int limit = 20,
  }) async {
    if (categoryId.isEmpty) {
      return const Left(ValidationFailure('Category ID cannot be empty'));
    }

    if (page < 1) {
      return const Left(ValidationFailure('Page must be greater than 0'));
    }

    if (limit < 1 || limit > 100) {
      return const Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    return await _repository.getArticles(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      page: page,
      limit: limit,
    );
  }
}

class GetArticlesByAuthorUseCase {
  final HelpRepository _repository;

  const GetArticlesByAuthorUseCase(this._repository);

  Future<Either<Failure, List<HelpArticle>>> call(String authorId, {
    int page = 1,
    int limit = 20,
  }) async {
    if (authorId.isEmpty) {
      return const Left(ValidationFailure('Author ID cannot be empty'));
    }

    if (page < 1) {
      return const Left(ValidationFailure('Page must be greater than 0'));
    }

    if (limit < 1 || limit > 100) {
      return const Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    return await _repository.getArticlesByAuthor(authorId, page: page, limit: limit);
  }
}

class GetUserHelpSettingsUseCase {
  final HelpRepository _repository;

  const GetUserHelpSettingsUseCase(this._repository);

  Future<Either<Failure, HelpSettings>> call(String userId) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await _repository.getUserHelpSettings(userId);
  }
}

class UpdateUserHelpSettingsUseCase {
  final HelpRepository _repository;

  const UpdateUserHelpSettingsUseCase(this._repository);

  Future<Either<Failure, HelpSettings>> call(String userId, HelpSettings settings) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    if (settings.maxSearchHistory < 0 || settings.maxSearchHistory > 200) {
      return const Left(ValidationFailure('Max search history must be between 0 and 200'));
    }

    return await _repository.updateUserHelpSettings(userId, settings);
  }
}
