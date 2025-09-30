import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/listing.dart';
import '../../domain/repositories/listing_repository.dart';
import '../datasources/remote/listing_remote_datasource.dart';

class ListingRepositoryImpl implements ListingRepository {
  final ListingRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ListingRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, ListingEntity>> createListing(CreateListingRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        // Convert request to entity
        final listing = _convertCreateRequestToEntity(request);
        final createdListing = await _remoteDataSource.createListing(listing);
        return Right(createdListing);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ListingEntity>> getListingById(String listingId) async {
    if (await _networkInfo.isConnected) {
      try {
        final listing = await _remoteDataSource.getListingById(listingId);
        return Right(listing);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ListingEntity>>> getListings({
    ListingQueryParams? params,
    int page = 1,
    int limit = 20,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final listings = await _remoteDataSource.getListings(
          category: params?.categoryId,
          location: params?.city,
        );
        return Right(listings);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ListingEntity>> updateListing(String listingId, UpdateListingRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        // For now, get existing listing and update it
        final existingListing = await _remoteDataSource.getListingById(listingId);
        final updatedListing = _applyUpdateRequest(existingListing, request);
        final result = await _remoteDataSource.updateListing(listingId, updatedListing);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteListing(String listingId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteListing(listingId);
        return const Right(null);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ListingEntity>>> searchListings(SearchListingsRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final listings = await _remoteDataSource.searchListings(request.query);
        return Right(listings);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ListingEntity>>> getUserListings(
    String userId, {
    ListingStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final listings = await _remoteDataSource.getListings();
        // Filter by userId and status
        var userListings = listings.where((listing) => listing.userId == userId);
        if (status != null) {
          userListings = userListings.where((listing) => listing.status == status);
        }
        return Right(userListings.toList());
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  // Helper methods to convert between request and entity types
  ListingEntity _convertCreateRequestToEntity(CreateListingRequest request) {
    return ListingEntity(
      id: '', // Will be set by backend
      userId: request.userId,
      title: request.title,
      description: request.description,
      category: CategoryEntity(
        id: request.categoryId,
        name: 'Category', // Placeholder
      ),
      condition: request.condition,
      brand: request.brand,
      model: request.model,
      year: request.year,
      media: request.mediaUrls.asMap().entries.map((entry) => ListingMedia(
        id: 'media_${entry.key}',
        type: MediaType.image,
        url: entry.value,
        order: entry.key,
        isPrimary: entry.key == 0,
      )).toList(),
      pricing: ListingPricing(
        cashPrice: request.pricing.cashPrice,
        currency: request.pricing.currency,
        isNegotiable: request.pricing.isNegotiable,
        barterOptions: BarterOptions(
          acceptDirectSwap: request.pricing.barterOptions.acceptDirectSwap,
          acceptSwapWithCash: request.pricing.barterOptions.acceptSwapWithCash,
          acceptBarterPool: request.pricing.barterOptions.acceptBarterPool,
          preferredItems: request.pricing.barterOptions.preferredItems,
          minCashDifference: request.pricing.barterOptions.minCashDifference,
          maxCashDifference: request.pricing.barterOptions.maxCashDifference,
        ),
      ),
      delivery: ListingDelivery(
        methods: request.delivery.methods,
        cargoProviders: request.delivery.cargoProviders,
        shippingCost: request.delivery.shippingCost,
        estimatedDays: request.delivery.estimatedDays,
        isFreeShipping: request.delivery.isFreeShipping,
      ),
      location: ListingLocation(
        city: request.location.city,
        district: request.location.district,
        neighborhood: request.location.neighborhood,
        latitude: null,
        longitude: null,
        address: request.location.address,
      ),
      status: request.saveAsDraft ? ListingStatus.draft : ListingStatus.pending,
      moderation: const ListingModeration(
        status: ModerationStatus.pending,
        reviewedBy: null,
        reviewedAt: null,
        rejectionReason: null,
        level: ModerationLevel.automatic,
      ),
      stats: const ListingStats(),
      boost: null,
      isActive: !request.saveAsDraft,
      isFeatured: false,
      isUrgent: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      expiresAt: null,
    );
  }

  ListingEntity _applyUpdateRequest(ListingEntity existing, UpdateListingRequest request) {
    return ListingEntity(
      id: existing.id,
      userId: existing.userId,
      title: request.title ?? existing.title,
      description: request.description ?? existing.description,
      category: request.categoryId != null
          ? CategoryEntity(id: request.categoryId!, name: 'Category')
          : existing.category,
      condition: request.condition ?? existing.condition,
      brand: request.brand ?? existing.brand,
      model: request.model ?? existing.model,
      year: request.year ?? existing.year,
      media: request.mediaUrls != null
          ? request.mediaUrls!.asMap().entries.map((entry) => ListingMedia(
                id: 'media_${entry.key}',
                type: MediaType.image,
                url: entry.value,
                order: entry.key,
                isPrimary: entry.key == 0,
              )).toList()
          : existing.media,
      pricing: existing.pricing, // TODO: Apply pricing updates
      delivery: existing.delivery, // TODO: Apply delivery updates
      location: existing.location, // TODO: Apply location updates
      status: existing.status,
      moderation: existing.moderation,
      stats: existing.stats,
      boost: existing.boost,
      isActive: request.isActive ?? existing.isActive,
      isFeatured: existing.isFeatured,
      isUrgent: existing.isUrgent,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
      expiresAt: existing.expiresAt,
    );
  }

  // Stub implementations for missing methods
  @override
  Future<Either<Failure, List<ListingEntity>>> getFavoriteListings(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, List<ListingEntity>>> getListingsByCategory(
    String categoryId, {
    ListingQueryParams? params,
    int page = 1,
    int limit = 20,
  }) async {
    return getListings(
      params: params ?? ListingQueryParams(categoryId: categoryId),
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Either<Failure, ListingStatsResponse>> getListingStats(String listingId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, ListingStatsResponse>> incrementViewCount(String listingId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, ListingEntity>> boostListing(String listingId, BoostRequest request) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, ListingEntity>> cancelBoost(String listingId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, ListingEntity>> submitForModeration(String listingId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, ListingEntity>> approveListing(String listingId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, ListingEntity>> rejectListing(String listingId, String reason) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String listingId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String listingId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String listingId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, List<String>>> uploadMedia(List<String> filePaths) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, void>> deleteMedia(String mediaId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, void>> reorderMedia(String listingId, List<String> mediaIds) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({String? parentId}) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String categoryId) async {
    // TODO: Implement
    return const Left(ServerFailure('Not implemented yet'));
  }
}
