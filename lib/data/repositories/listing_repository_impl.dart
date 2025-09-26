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
  Future<Either<Failure, ListingEntity>> createListing(ListingEntity listing) async {
    if (await _networkInfo.isConnected) {
      try {
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
  Future<Either<Failure, List<ListingEntity>>> getListings({String? category, String? location}) async {
    if (await _networkInfo.isConnected) {
      try {
        final listings = await _remoteDataSource.getListings(category: category, location: location);
        return Right(listings);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ListingEntity>> updateListing(String listingId, ListingEntity listing) async {
    if (await _networkInfo.isConnected) {
      try {
        final updatedListing = await _remoteDataSource.updateListing(listingId, listing);
        return Right(updatedListing);
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
  Future<Either<Failure, List<ListingEntity>>> searchListings(String query) async {
    if (await _networkInfo.isConnected) {
      try {
        final listings = await _remoteDataSource.searchListings(query);
        return Right(listings);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ListingEntity>>> getUserListings(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final listings = await _remoteDataSource.getListings();
        // Filter by userId (assuming the API doesn't support this directly)
        final userListings = listings.where((listing) => listing.userId == userId).toList();
        return Right(userListings);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
