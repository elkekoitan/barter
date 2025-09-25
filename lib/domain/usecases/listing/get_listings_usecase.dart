import 'package:dartz/dartz.dart';
import '../../repositories/listing_repository.dart';
import '../../../core/errors/failures.dart';

class GetListingsUseCase {
  final ListingRepository _repository;

  const GetListingsUseCase(this._repository);

  Future<Either<Failure, List<ListingEntity>>> call({
    ListingQueryParams? params,
    int page = 1,
    int limit = 20,
  }) async {
    // Validate query parameters
    final validationFailure = _validateQueryParams(params, page, limit);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Get listings from repository
    return await _repository.getListings(
      params: params,
      page: page,
      limit: limit,
    );
  }

  Failure? _validateQueryParams(ListingQueryParams? params, int page, int limit) {
    if (page < 1) {
      return const ValidationFailure('Page must be greater than 0');
    }

    if (limit < 1 || limit > 100) {
      return const ValidationFailure('Limit must be between 1 and 100');
    }

    if (params != null) {
      // Validate price range
      if (params.minPrice != null && params.minPrice! < 0) {
        return const ValidationFailure('Minimum price cannot be negative');
      }

      if (params.maxPrice != null && params.maxPrice! < 0) {
        return const ValidationFailure('Maximum price cannot be negative');
      }

      if (params.minPrice != null && params.maxPrice != null) {
        if (params.minPrice! > params.maxPrice!) {
          return const ValidationFailure('Minimum price cannot be greater than maximum price');
        }
      }

      // Validate date range
      if (params.createdAfter != null && params.createdBefore != null) {
        if (params.createdAfter!.isAfter(params.createdBefore!)) {
          return const ValidationFailure('Created after date cannot be after created before date');
        }
      }
    }

    return null;
  }
}
