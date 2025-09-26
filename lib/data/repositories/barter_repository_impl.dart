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
  Future<Either<Failure, BarterOfferEntity>> createOffer(BarterOfferEntity offer) async {
    if (await _networkInfo.isConnected) {
      try {
        final createdOffer = await _remoteDataSource.createOffer(offer);
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
  Future<Either<Failure, BarterTransactionEntity>> createTransaction(BarterTransactionEntity transaction) async {
    if (await _networkInfo.isConnected) {
      try {
        final createdTransaction = await _remoteDataSource.createTransaction(transaction);
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
  Future<Either<Failure, BarterOfferEntity>> rejectOffer(String offerId) async {
    return updateOfferStatus(offerId, 'rejected');
  }
}
