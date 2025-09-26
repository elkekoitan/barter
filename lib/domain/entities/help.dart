import 'package:equatable/equatable.dart';

class HelpArticle extends Equatable {
  final String id;
  final String title;
  final String content;
  final String categoryId;
  final String subcategoryId;
  final ArticleType type;
  final ArticlePriority priority;
  final List<String> tags;
  final List<String> relatedArticles;
  final String? videoUrl;
  final List<String> images;
  final List<HelpStep> steps;
  final bool isPublished;
  final bool requiresAuth;
  final int viewCount;
  final int helpfulCount;
  final int notHelpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authorId;
  final String? lastEditorId;
  final Map<String, dynamic>? metadata;

  const HelpArticle({
    required this.id,
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
    this.isPublished = true,
    this.requiresAuth = false,
    this.viewCount = 0,
    this.helpfulCount = 0,
    this.notHelpfulCount = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.authorId,
    this.lastEditorId,
    this.metadata,
  });

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  bool get hasImages => images.isNotEmpty;

  bool get hasSteps => steps.isNotEmpty;

  bool get isTutorial => type == ArticleType.tutorial;

  bool get isFAQ => type == ArticleType.faq;

  bool get isTroubleshooting => type == ArticleType.troubleshooting;

  double get helpfulnessRatio {
    final total = helpfulCount + notHelpfulCount;
    return total > 0 ? helpfulCount / total : 0.0;
  }

  bool get isHelpful => helpfulnessRatio >= 0.7;

  String get excerpt => content.length > 150
      ? '${content.substring(0, 150)}...'
      : content;

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        categoryId,
        subcategoryId,
        type,
        priority,
        tags,
        relatedArticles,
        videoUrl,
        images,
        steps,
        isPublished,
        requiresAuth,
        viewCount,
        helpfulCount,
        notHelpfulCount,
        createdAt,
        updatedAt,
        authorId,
        lastEditorId,
        metadata,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'type': type.value,
      'priority': priority.value,
      'tags': tags,
      'relatedArticles': relatedArticles,
      'videoUrl': videoUrl,
      'images': images,
      'steps': steps.map((step) => {
        'id': step.id,
        'title': step.title,
        'description': step.description,
        'imageUrl': step.imageUrl,
        'videoUrl': step.videoUrl,
        'order': step.order,
        'tips': step.tips,
        'metadata': step.metadata,
      }).toList(),
      'isPublished': isPublished,
      'requiresAuth': requiresAuth,
      'viewCount': viewCount,
      'helpfulCount': helpfulCount,
      'notHelpfulCount': notHelpfulCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'authorId': authorId,
      'lastEditorId': lastEditorId,
      'metadata': metadata,
    };
  }

  factory HelpArticle.fromJson(Map<String, dynamic> json) {
    return HelpArticle(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      type: ArticleType.fromString(json['type'] ?? 'article'),
      priority: ArticlePriority.fromString(json['priority'] ?? 'medium'),
      tags: List<String>.from(json['tags'] ?? []),
      relatedArticles: List<String>.from(json['relatedArticles'] ?? []),
      videoUrl: json['videoUrl'],
      images: List<String>.from(json['images'] ?? []),
      steps: (json['steps'] as List?)?.map((step) => HelpStep(
        id: step['id'],
        title: step['title'],
        description: step['description'],
        imageUrl: step['imageUrl'],
        videoUrl: step['videoUrl'],
        order: step['order'] ?? 0,
        tips: List<String>.from(step['tips'] ?? []),
        metadata: step['metadata'],
      )).toList() ?? [],
      isPublished: json['isPublished'] ?? true,
      requiresAuth: json['requiresAuth'] ?? false,
      viewCount: json['viewCount'] ?? 0,
      helpfulCount: json['helpfulCount'] ?? 0,
      notHelpfulCount: json['notHelpfulCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      authorId: json['authorId'],
      lastEditorId: json['lastEditorId'],
      metadata: json['metadata'],
    );
  }
}

enum ArticleType {
  article('article', 'Makale'),
  tutorial('tutorial', 'Eğitim'),
  faq('faq', 'SSS'),
  troubleshooting('troubleshooting', 'Sorun Giderme'),
  guide('guide', 'Rehber'),
  tip('tip', 'İpucu'),
  announcement('announcement', 'Duyuru'),
  changelog('changelog', 'Değişiklik Günlüğü');

  const ArticleType(this.value, this.displayName);
  final String value;
  final String displayName;

  static ArticleType fromString(String value) {
    return ArticleType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ArticleType.article,
    );
  }
}

enum ArticlePriority {
  low('low', 'Düşük'),
  medium('medium', 'Orta'),
  high('high', 'Yüksek'),
  urgent('urgent', 'Acil');

  const ArticlePriority(this.value, this.displayName);
  final String value;
  final String displayName;

  static ArticlePriority fromString(String value) {
    return ArticlePriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => ArticlePriority.medium,
    );
  }
}

class HelpCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? parentId;
  final int order;
  final bool isActive;
  final String iconName;
  final String color;
  final int articleCount;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const HelpCategory({
    required this.id,
    required this.name,
    required this.description,
    this.parentId,
    this.order = 0,
    this.isActive = true,
    this.iconName = 'help',
    this.color = '#2563EB',
    this.articleCount = 0,
    required this.createdAt,
    this.metadata,
  });

  bool get isSubcategory => parentId != null && parentId!.isNotEmpty;

  bool get hasArticles => articleCount > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        parentId,
        order,
        isActive,
        iconName,
        color,
        articleCount,
        createdAt,
        metadata,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'parentId': parentId,
      'order': order,
      'isActive': isActive,
      'iconName': iconName,
      'color': color,
      'articleCount': articleCount,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory HelpCategory.fromJson(Map<String, dynamic> json) {
    return HelpCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      parentId: json['parentId'],
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
      iconName: json['iconName'] ?? 'help',
      color: json['color'] ?? '#2563EB',
      articleCount: json['articleCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      metadata: json['metadata'],
    );
  }
}

class FAQ extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String categoryId;
  final List<String> tags;
  final bool isPopular;
  final int viewCount;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryId,
    this.tags = const [],
    this.isPopular = false,
    this.viewCount = 0,
    this.helpfulCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  bool get isFrequentlyAsked => viewCount > 100;

  bool get isHelpful => helpfulCount > viewCount * 0.7;

  @override
  List<Object?> get props => [
        id,
        question,
        answer,
        categoryId,
        tags,
        isPopular,
        viewCount,
        helpfulCount,
        createdAt,
        updatedAt,
        metadata,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'categoryId': categoryId,
      'tags': tags,
      'isPopular': isPopular,
      'viewCount': viewCount,
      'helpfulCount': helpfulCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      categoryId: json['categoryId'],
      tags: List<String>.from(json['tags'] ?? []),
      isPopular: json['isPopular'] ?? false,
      viewCount: json['viewCount'] ?? 0,
      helpfulCount: json['helpfulCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      metadata: json['metadata'],
    );
  }
}

class HelpStep extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final int order;
  final Duration? estimatedTime;
  final List<String> tips;
  final Map<String, dynamic>? metadata;

  const HelpStep({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    this.order = 0,
    this.estimatedTime,
    this.tips = const [],
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        videoUrl,
        order,
        estimatedTime,
        tips,
        metadata,
      ];
}

class HelpSearchResult extends Equatable {
  final String id;
  final String title;
  final String excerpt;
  final String type;
  final String categoryName;
  final double relevanceScore;
  final List<String> tags;
  final DateTime createdAt;

  const HelpSearchResult({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.type,
    required this.categoryName,
    required this.relevanceScore,
    this.tags = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        excerpt,
        type,
        categoryName,
        relevanceScore,
        tags,
        createdAt,
      ];

  factory HelpSearchResult.fromJson(Map<String, dynamic> json) {
    return HelpSearchResult(
      id: json['id'],
      title: json['title'],
      excerpt: json['excerpt'],
      type: json['type'],
      categoryName: json['categoryName'],
      relevanceScore: json['relevanceScore']?.toDouble() ?? 0.0,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class HelpStats extends Equatable {
  final int totalArticles;
  final int totalCategories;
  final int totalFAQs;
  final int totalViews;
  final int totalHelpfulVotes;
  final Map<String, int> articlesByCategory;
  final Map<String, int> popularArticles;
  final Map<String, int> searchTerms;
  final Map<String, double> categorySatisfaction;
  final DateTime lastUpdated;

  const HelpStats({
    required this.totalArticles,
    required this.totalCategories,
    required this.totalFAQs,
    required this.totalViews,
    required this.totalHelpfulVotes,
    this.articlesByCategory = const {},
    this.popularArticles = const {},
    this.searchTerms = const {},
    this.categorySatisfaction = const {},
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        totalArticles,
        totalCategories,
        totalFAQs,
        totalViews,
        totalHelpfulVotes,
        articlesByCategory,
        popularArticles,
        searchTerms,
        categorySatisfaction,
        lastUpdated,
      ];

  factory HelpStats.fromJson(Map<String, dynamic> json) {
    return HelpStats(
      totalArticles: json['totalArticles'] ?? 0,
      totalCategories: json['totalCategories'] ?? 0,
      totalFAQs: json['totalFAQs'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      totalHelpfulVotes: json['totalHelpfulVotes'] ?? 0,
      articlesByCategory: (json['articlesByCategory'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ) ?? {},
      popularArticles: (json['popularArticles'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ) ?? {},
      searchTerms: (json['searchTerms'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ) ?? {},
      categorySatisfaction: (json['categorySatisfaction'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as double),
      ) ?? {},
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class HelpFeedback extends Equatable {
  final String id;
  final String articleId;
  final String userId;
  final FeedbackType type;
  final String? comment;
  final int rating;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final Map<String, dynamic>? metadata;

  const HelpFeedback({
    required this.id,
    required this.articleId,
    required this.userId,
    required this.type,
    this.comment,
    this.rating = 0,
    this.isResolved = false,
    required this.createdAt,
    this.resolvedAt,
    this.resolvedBy,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        articleId,
        userId,
        type,
        comment,
        rating,
        isResolved,
        createdAt,
        resolvedAt,
        resolvedBy,
        metadata,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'articleId': articleId,
      'userId': userId,
      'type': type.value,
      'comment': comment,
      'rating': rating,
      'isResolved': isResolved,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedBy': resolvedBy,
      'metadata': metadata,
    };
  }

  factory HelpFeedback.fromJson(Map<String, dynamic> json) {
    return HelpFeedback(
      id: json['id'],
      articleId: json['articleId'],
      userId: json['userId'],
      type: FeedbackType.fromString(json['type'] ?? 'general'),
      comment: json['comment'],
      rating: json['rating'] ?? 0,
      isResolved: json['isResolved'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
      resolvedBy: json['resolvedBy'],
      metadata: json['metadata'],
    );
  }
}

enum FeedbackType {
  suggestion('suggestion', 'Öneri'),
  correction('correction', 'Düzeltme'),
  missingInfo('missing_info', 'Eksik Bilgi'),
  confusing('confusing', 'Kafa Karıştırıcı'),
  outdated('outdated', 'Güncel Değil'),
  other('other', 'Diğer');

  const FeedbackType(this.value, this.displayName);
  final String value;
  final String displayName;

  static FeedbackType fromString(String value) {
    return FeedbackType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => FeedbackType.other,
    );
  }
}

class HelpSearchRequest extends Equatable {
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

  const HelpSearchRequest({
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
  });

  @override
  List<Object?> get props => [
        query,
        categoryId,
        subcategoryId,
        type,
        priority,
        tags,
        page,
        limit,
        sortBy,
        includeUnpublished,
      ];

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'type': type?.value,
      'priority': priority?.value,
      'tags': tags,
      'page': page,
      'limit': limit,
      'sortBy': sortBy.value,
      'includeUnpublished': includeUnpublished,
    };
  }

  factory HelpSearchRequest.fromJson(Map<String, dynamic> json) {
    return HelpSearchRequest(
      query: json['query'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      type: json['type'] != null ? ArticleType.fromString(json['type']) : null,
      priority: json['priority'] != null ? ArticlePriority.fromString(json['priority']) : null,
      tags: List<String>.from(json['tags'] ?? []),
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      sortBy: json['sortBy'] != null ? SearchSort.fromString(json['sortBy']) : SearchSort.relevance,
      includeUnpublished: json['includeUnpublished'] ?? false,
    );
  }
}

enum SearchSort {
  relevance('relevance', 'Alaka'),
  title('title', 'Başlık'),
  createdAt('created_at', 'Oluşturulma Tarihi'),
  updatedAt('updated_at', 'Güncellenme Tarihi'),
  viewCount('view_count', 'Görüntülenme Sayısı'),
  helpfulness('helpfulness', 'Yararlılık');

  const SearchSort(this.value, this.displayName);
  final String value;
  final String displayName;

  static SearchSort fromString(String value) {
    return SearchSort.values.firstWhere(
      (sort) => sort.value == value,
      orElse: () => SearchSort.relevance,
    );
  }
}

class HelpFilter extends Equatable {
  final List<String> categories;
  final List<ArticleType> types;
  final List<ArticlePriority> priorities;
  final List<String> tags;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final bool onlyPublished;
  final bool onlyWithVideo;
  final bool onlyWithImages;
  final bool onlyTutorials;

  const HelpFilter({
    this.categories = const [],
    this.types = const [],
    this.priorities = const [],
    this.tags = const [],
    this.dateFrom,
    this.dateTo,
    this.onlyPublished = true,
    this.onlyWithVideo = false,
    this.onlyWithImages = false,
    this.onlyTutorials = false,
  });

  bool get hasFilters =>
      categories.isNotEmpty ||
      types.isNotEmpty ||
      priorities.isNotEmpty ||
      tags.isNotEmpty ||
      dateFrom != null ||
      dateTo != null ||
      onlyWithVideo ||
      onlyWithImages ||
      onlyTutorials;

  @override
  List<Object?> get props => [
        categories,
        types,
        priorities,
        tags,
        dateFrom,
        dateTo,
        onlyPublished,
        onlyWithVideo,
        onlyWithImages,
        onlyTutorials,
      ];
}

class UserHelpHistory extends Equatable {
  final String userId;
  final List<String> viewedArticles;
  final List<String> searchedTerms;
  final List<String> helpfulArticles;
  final List<String> bookmarkedArticles;
  final Map<String, DateTime> lastViewed;
  final Map<String, int> articleRatings;
  final DateTime lastActivity;
  final Map<String, dynamic>? preferences;

  const UserHelpHistory({
    required this.userId,
    this.viewedArticles = const [],
    this.searchedTerms = const [],
    this.helpfulArticles = const [],
    this.bookmarkedArticles = const [],
    this.lastViewed = const {},
    this.articleRatings = const {},
    required this.lastActivity,
    this.preferences,
  });

  @override
  List<Object?> get props => [
        userId,
        viewedArticles,
        searchedTerms,
        helpfulArticles,
        bookmarkedArticles,
        lastViewed,
        articleRatings,
        lastActivity,
        preferences,
      ];

  factory UserHelpHistory.fromJson(Map<String, dynamic> json) {
    return UserHelpHistory(
      userId: json['userId'],
      viewedArticles: List<String>.from(json['viewedArticles'] ?? []),
      searchedTerms: List<String>.from(json['searchedTerms'] ?? []),
      helpfulArticles: List<String>.from(json['helpfulArticles'] ?? []),
      bookmarkedArticles: List<String>.from(json['bookmarkedArticles'] ?? []),
      lastViewed: (json['lastViewed'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, DateTime.parse(value)),
      ) ?? {},
      articleRatings: (json['articleRatings'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ) ?? {},
      lastActivity: DateTime.parse(json['lastActivity']),
      preferences: json['preferences'],
    );
  }
}

class HelpSettings extends Equatable {
  final String userId;
  final bool enableNotifications;
  final bool emailUpdates;
  final List<String> subscribedCategories;
  final bool showHelpfulTips;
  final bool showVideoContent;
  final String preferredLanguage;
  final bool autoBookmark;
  final int maxSearchHistory;
  final Map<String, dynamic>? customSettings;

  const HelpSettings({
    required this.userId,
    this.enableNotifications = true,
    this.emailUpdates = false,
    this.subscribedCategories = const [],
    this.showHelpfulTips = true,
    this.showVideoContent = true,
    this.preferredLanguage = 'tr',
    this.autoBookmark = false,
    this.maxSearchHistory = 50,
    this.customSettings,
  });

  @override
  List<Object?> get props => [
        userId,
        enableNotifications,
        emailUpdates,
        subscribedCategories,
        showHelpfulTips,
        showVideoContent,
        preferredLanguage,
        autoBookmark,
        maxSearchHistory,
        customSettings,
      ];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'enableNotifications': enableNotifications,
      'emailUpdates': emailUpdates,
      'subscribedCategories': subscribedCategories,
      'showHelpfulTips': showHelpfulTips,
      'showVideoContent': showVideoContent,
      'preferredLanguage': preferredLanguage,
      'autoBookmark': autoBookmark,
      'maxSearchHistory': maxSearchHistory,
      'customSettings': customSettings,
    };
  }

  factory HelpSettings.fromJson(Map<String, dynamic> json) {
    return HelpSettings(
      userId: json['userId'],
      enableNotifications: json['enableNotifications'] ?? true,
      emailUpdates: json['emailUpdates'] ?? false,
      subscribedCategories: List<String>.from(json['subscribedCategories'] ?? []),
      showHelpfulTips: json['showHelpfulTips'] ?? true,
      showVideoContent: json['showVideoContent'] ?? true,
      preferredLanguage: json['preferredLanguage'] ?? 'tr',
      autoBookmark: json['autoBookmark'] ?? false,
      maxSearchHistory: json['maxSearchHistory'] ?? 50,
      customSettings: json['customSettings'],
    );
  }
}
