import 'package:dartz/dartz.dart';
import '../../repositories/barter_repository.dart';
import '../../../core/errors/failures.dart';

class GetOffersUseCase {
  final BarterRepository _repository;

  const GetOffersUseCase(this._repository);

  Future<Either<Failure, List<BarterOfferEntity>>> call({
    String? listingId,
    String? userId,
    OfferFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    // Validate parameters
    final validationFailure = _validateParameters(listingId, userId, page, limit);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Get offers based on parameters
    if (listingId != null && listingId.isNotEmpty) {
      return await _repository.getOffersByListing(listingId);
    } else if (userId != null && userId.isNotEmpty) {
      return await _repository.getOffersByUser(userId, filter: filter);
    } else {
      return const Left(ValidationFailure('Either listingId or userId must be provided'));
    }
  }

  Failure? _validateParameters(String? listingId, String? userId, int page, int limit) {
    if (page < 1) {
      return const ValidationFailure('Page must be greater than 0');
    }

    if (limit < 1 || limit > 100) {
      return const ValidationFailure('Limit must be between 1 and 100');
    }

    if (listingId != null && listingId.isEmpty) {
      return const ValidationFailure('Listing ID cannot be empty if provided');
    }

    if (userId != null && userId.isEmpty) {
      return const ValidationFailure('User ID cannot be empty if provided');
    }

    return null;
  }
}
