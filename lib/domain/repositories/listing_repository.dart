import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/listing.dart';

abstract class ListingRepository {
  // CRUD Operations
  Future<Either<Failure, ListingEntity>> createListing(CreateListingRequest request);
  Future<Either<Failure, ListingEntity>> getListingById(String listingId);
  Future<Either<Failure, ListingEntity>> updateListing(String listingId, UpdateListingRequest request);
  Future<Either<Failure, void>> deleteListing(String listingId);

  // Query Operations
  Future<Either<Failure, List<ListingEntity>>> getListings({
    ListingQueryParams? params,
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, List<ListingEntity>>> getUserListings(
    String userId, {
    ListingStatus? status,
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, List<ListingEntity>>> getFavoriteListings(
    String userId, {
    int page = 1,
    int limit = 20,
  });

  // Search & Filter
  Future<Either<Failure, List<ListingEntity>>> searchListings(SearchListingsRequest request);
  Future<Either<Failure, List<ListingEntity>>> getListingsByCategory(
    String categoryId, {
    ListingQueryParams? params,
    int page = 1,
    int limit = 20,
  });

  // Stats & Analytics
  Future<Either<Failure, ListingStatsResponse>> getListingStats(String listingId);
  Future<Either<Failure, ListingStatsResponse>> incrementViewCount(String listingId);

  // Boost & Premium Features
  Future<Either<Failure, ListingEntity>> boostListing(String listingId, BoostRequest request);
  Future<Either<Failure, ListingEntity>> cancelBoost(String listingId);

  // Moderation
  Future<Either<Failure, ListingEntity>> submitForModeration(String listingId);
  Future<Either<Failure, ListingEntity>> approveListing(String listingId);
  Future<Either<Failure, ListingEntity>> rejectListing(String listingId, String reason);

  // Favorites
  Future<Either<Failure, void>> addToFavorites(String listingId);
  Future<Either<Failure, void>> removeFromFavorites(String listingId);
  Future<Either<Failure, bool>> isFavorite(String listingId);

  // Media Operations
  Future<Either<Failure, List<String>>> uploadMedia(List<String> filePaths);
  Future<Either<Failure, void>> deleteMedia(String mediaId);
  Future<Either<Failure, void>> reorderMedia(String listingId, List<String> mediaIds);

  // Categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories({String? parentId});
  Future<Either<Failure, CategoryEntity>> getCategoryById(String categoryId);
}

// Request/Response Models
class CreateListingRequest {
  final String userId;
  final String title;
  final String description;
  final String categoryId;
  final ListingCondition condition;
  final String? brand;
  final String? model;
  final int? year;
  final List<String> mediaUrls;
  final CreateListingPricing pricing;
  final CreateListingDelivery delivery;
  final CreateListingLocation location;
  final bool saveAsDraft;

  const CreateListingRequest({
    required this.userId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.condition,
    this.brand,
    this.model,
    this.year,
    required this.mediaUrls,
    required this.pricing,
    required this.delivery,
    required this.location,
    this.saveAsDraft = false,
  });
}

class UpdateListingRequest {
  final String? title;
  final String? description;
  final String? categoryId;
  final ListingCondition? condition;
  final String? brand;
  final String? model;
  final int? year;
  final List<String>? mediaUrls;
  final UpdateListingPricing? pricing;
  final UpdateListingDelivery? delivery;
  final UpdateListingLocation? location;
  final bool? isActive;

  const UpdateListingRequest({
    this.title,
    this.description,
    this.categoryId,
    this.condition,
    this.brand,
    this.model,
    this.year,
    this.mediaUrls,
    this.pricing,
    this.delivery,
    this.location,
    this.isActive,
  });
}

class ListingQueryParams {
  final String? categoryId;
  final String? city;
  final String? district;
  final double? minPrice;
  final double? maxPrice;
  final ListingCondition? condition;
  final bool? hasImages;
  final bool? acceptsBarter;
  final bool? isUrgent;
  final bool? isFeatured;
  final ListingStatus? status;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final String? searchQuery;
  final ListingSortOption sortBy;
  final bool sortDescending;

  const ListingQueryParams({
    this.categoryId,
    this.city,
    this.district,
    this.minPrice,
    this.maxPrice,
    this.condition,
    this.hasImages,
    this.acceptsBarter,
    this.isUrgent,
    this.isFeatured,
    this.status,
    this.createdAfter,
    this.createdBefore,
    this.searchQuery,
    this.sortBy = ListingSortOption.createdAt,
    this.sortDescending = true,
  });
}

class SearchListingsRequest {
  final String query;
  final String? categoryId;
  final ListingQueryParams? filters;
  final int page;
  final int limit;
  final ListingSortOption sortBy;
  final bool sortDescending;

  const SearchListingsRequest({
    required this.query,
    this.categoryId,
    this.filters,
    this.page = 1,
    this.limit = 20,
    this.sortBy = ListingSortOption.relevance,
    this.sortDescending = true,
  });
}

class CreateListingPricing {
  final double? cashPrice;
  final String currency;
  final bool isNegotiable;
  final CreateBarterOptions barterOptions;

  const CreateListingPricing({
    this.cashPrice,
    this.currency = 'TRY',
    this.isNegotiable = true,
    required this.barterOptions,
  });
}

class CreateBarterOptions {
  final bool acceptDirectSwap;
  final bool acceptSwapWithCash;
  final bool acceptBarterPool;
  final List<String>? preferredItems;
  final double? minCashDifference;
  final double? maxCashDifference;

  const CreateBarterOptions({
    this.acceptDirectSwap = false,
    this.acceptSwapWithCash = false,
    this.acceptBarterPool = false,
    this.preferredItems,
    this.minCashDifference,
    this.maxCashDifference,
  });
}

class CreateListingDelivery {
  final List<DeliveryMethod> methods;
  final List<String>? cargoProviders;
  final double? shippingCost;
  final int? estimatedDays;
  final bool isFreeShipping;

  const CreateListingDelivery({
    required this.methods,
    this.cargoProviders,
    this.shippingCost,
    this.estimatedDays,
    this.isFreeShipping = false,
  });
}

class CreateListingLocation {
  final String city;
  final String district;
  final String? neighborhood;
  final String? address;

  const CreateListingLocation({
    required this.city,
    required this.district,
    this.neighborhood,
    this.address,
  });
}

class UpdateListingPricing {
  final double? cashPrice;
  final String? currency;
  final bool? isNegotiable;
  final UpdateBarterOptions? barterOptions;

  const UpdateListingPricing({
    this.cashPrice,
    this.currency,
    this.isNegotiable,
    this.barterOptions,
  });
}

class UpdateBarterOptions {
  final bool? acceptDirectSwap;
  final bool? acceptSwapWithCash;
  final bool? acceptBarterPool;
  final List<String>? preferredItems;
  final double? minCashDifference;
  final double? maxCashDifference;

  const UpdateBarterOptions({
    this.acceptDirectSwap,
    this.acceptSwapWithCash,
    this.acceptBarterPool,
    this.preferredItems,
    this.minCashDifference,
    this.maxCashDifference,
  });
}

class UpdateListingDelivery {
  final List<DeliveryMethod>? methods;
  final List<String>? cargoProviders;
  final double? shippingCost;
  final int? estimatedDays;
  final bool? isFreeShipping;

  const UpdateListingDelivery({
    this.methods,
    this.cargoProviders,
    this.shippingCost,
    this.estimatedDays,
    this.isFreeShipping,
  });
}

class UpdateListingLocation {
  final String? city;
  final String? district;
  final String? neighborhood;
  final String? address;

  const UpdateListingLocation({
    this.city,
    this.district,
    this.neighborhood,
    this.address,
  });
}

class BoostRequest {
  final BoostType type;
  final int durationDays;

  const BoostRequest({
    required this.type,
    required this.durationDays,
  });
}

class ListingStatsResponse {
  final ListingStats stats;
  final int viewCount;
  final int favoriteCount;
  final int offerCount;
  final double averageRating;
  final List<RatingBreakdown> ratingBreakdown;

  const ListingStatsResponse({
    required this.stats,
    required this.viewCount,
    required this.favoriteCount,
    required this.offerCount,
    required this.averageRating,
    required this.ratingBreakdown,
  });
}

class RatingBreakdown {
  final int rating;
  final int count;
  final double percentage;

  const RatingBreakdown({
    required this.rating,
    required this.count,
    required this.percentage,
  });
}

enum ListingSortOption {
  createdAt('created_at', 'Oluşturulma Tarihi'),
  updatedAt('updated_at', 'Güncellenme Tarihi'),
  price('price', 'Fiyat'),
  distance('distance', 'Uzaklık'),
  relevance('relevance', 'Alaka'),
  popularity('popularity', 'Popülerlik'),
  rating('rating', 'Değerlendirme');

  const ListingSortOption(this.value, this.displayName);
  final String value;
  final String displayName;
}
