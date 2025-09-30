import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/barter_offer.dart';
import '../../domain/entities/barter_transaction.dart';
import '../../domain/repositories/barter_repository.dart';
import '../datasources/remote/barter_remote_datasource.dart';

class BarterRepositoryImpl implements BarterRepository {
  final BarterRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  BarterRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, BarterOfferEntity>> createOffer(CreateOfferRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final createdOffer = await _remoteDataSource.createOfferFromRequest(request);
        return Right(createdOffer);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterOfferEntity>> getOfferById(String offerId) async {
    if (await _networkInfo.isConnected) {
      try {
        final offer = await _remoteDataSource.getOfferById(offerId);
        return Right(offer);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BarterOfferEntity>>> getOffersByListingId(String listingId) async {
    if (await _networkInfo.isConnected) {
      try {
        final offers = await _remoteDataSource.getOffersByListingId(listingId);
        return Right(offers);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BarterOfferEntity>>> getOffersByUserId(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final offers = await _remoteDataSource.getOffersByUserId(userId);
        return Right(offers);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterOfferEntity>> updateOfferStatus(String offerId, String status) async {
    if (await _networkInfo.isConnected) {
      try {
        final updatedOffer = await _remoteDataSource.updateOfferStatus(offerId, status);
        return Right(updatedOffer);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> createTransaction(CreateTransactionRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final createdTransaction = await _remoteDataSource.createTransactionFromRequest(request);
        return Right(createdTransaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> getTransactionById(String transactionId) async {
    if (await _networkInfo.isConnected) {
      try {
        final transaction = await _remoteDataSource.getTransactionById(transactionId);
        return Right(transaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BarterTransactionEntity>>> getTransactionsByUserId(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final transactions = await _remoteDataSource.getTransactionsByUserId(userId);
        return Right(transactions);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> updateTransactionStatus(String transactionId, String status) async {
    if (await _networkInfo.isConnected) {
      try {
        final updatedTransaction = await _remoteDataSource.updateTransactionStatus(transactionId, status);
        return Right(updatedTransaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterOfferEntity>> acceptOffer(String offerId) async {
    return updateOfferStatus(offerId, 'accepted');
  }

  @override
  Future<Either<Failure, BarterOfferEntity>> rejectOffer(String offerId, String reason) async {
    // TODO: Add reason to the API call when backend supports it
    return updateOfferStatus(offerId, 'rejected');
  }

  @override
  Future<Either<Failure, List<BarterOfferEntity>>> getOffersByListing(String listingId) async {
    if (await _networkInfo.isConnected) {
      try {
        final offers = await _remoteDataSource.getOffersByListing(listingId);
        return Right(offers);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BarterOfferEntity>>> getOffersByUser(String userId, {OfferFilter? filter}) async {
    if (await _networkInfo.isConnected) {
      try {
        final offers = await _remoteDataSource.getOffersByUser(userId, filter: filter);
        return Right(offers);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterOfferEntity>> updateOffer(String offerId, UpdateOfferRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final offer = await _remoteDataSource.updateOffer(offerId, request);
        return Right(offer);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOffer(String offerId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteOffer(offerId);
        return const Right(null);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterOfferEntity>> counterOffer(String offerId, CounterOfferRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final offer = await _remoteDataSource.counterOffer(offerId, request);
        return Right(offer);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterOfferEntity>> cancelOffer(String offerId) async {
    return updateOfferStatus(offerId, 'cancelled');
  }

  // Transaction methods
  @override
  Future<Either<Failure, List<BarterTransactionEntity>>> getTransactionsByUser(String userId, {TransactionFilter? filter}) async {
    if (await _networkInfo.isConnected) {
      try {
        final transactions = await _remoteDataSource.getTransactionsByUser(userId, filter: filter);
        return Right(transactions);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> updateTransaction(String transactionId, UpdateTransactionRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final transaction = await _remoteDataSource.updateTransaction(transactionId, request);
        return Right(transaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> confirmDelivery(String transactionId, DeliveryConfirmationRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final transaction = await _remoteDataSource.confirmDelivery(transactionId, request);
        return Right(transaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> confirmReceipt(String transactionId, ReceiptConfirmationRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final transaction = await _remoteDataSource.confirmReceipt(transactionId, request);
        return Right(transaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> completeTransaction(String transactionId) async {
    if (await _networkInfo.isConnected) {
      try {
        final transaction = await _remoteDataSource.completeTransaction(transactionId);
        return Right(transaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> cancelTransaction(String transactionId, String reason) async {
    if (await _networkInfo.isConnected) {
      try {
        final transaction = await _remoteDataSource.cancelTransaction(transactionId, reason);
        return Right(transaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> openDispute(String transactionId, DisputeRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final transaction = await _remoteDataSource.openDispute(transactionId, request);
        return Right(transaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterTransactionEntity>> resolveDispute(String transactionId, DisputeResolutionRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final transaction = await _remoteDataSource.resolveDispute(transactionId, request);
        return Right(transaction);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> submitReview(String transactionId, ReviewRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.submitReview(transactionId, request);
        return const Right(null);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Review>> getReview(String reviewId) async {
    if (await _networkInfo.isConnected) {
      try {
        final review = await _remoteDataSource.getReview(reviewId);
        return Right(review);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BarterOfferEntity>>> searchOffers(SearchOffersRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final offers = await _remoteDataSource.searchOffers(request);
        return Right(offers);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BarterStats>> getBarterStats(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final stats = await _remoteDataSource.getBarterStats(userId);
        return Right(stats);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TransactionStats>> getTransactionStats(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final stats = await _remoteDataSource.getTransactionStats(userId);
        return Right(stats);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
