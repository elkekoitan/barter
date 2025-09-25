import 'package:dartz/dartz.dart';
import '../../repositories/listing_repository.dart';
import '../../../core/errors/failures.dart';

class UpdateListingUseCase {
  final ListingRepository _repository;

  const UpdateListingUseCase(this._repository);

  Future<Either<Failure, ListingEntity>> call(String listingId, UpdateListingRequest request) async {
    // Validate listing ID
    if (listingId.isEmpty) {
      return const Left(ValidationFailure('Listing ID is required'));
    }

    // Validate update request
    final validationFailure = _validateUpdateRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Update the listing
    return await _repository.updateListing(listingId, request);
  }

  Failure? _validateUpdateRequest(UpdateListingRequest request) {
    // Title validation (if provided)
    if (request.title != null) {
      if (request.title!.isEmpty) {
        return const ValidationFailure('Title cannot be empty');
      }

      if (request.title!.length < 10) {
        return const ValidationFailure('Title must be at least 10 characters');
      }

      if (request.title!.length > 100) {
        return const ValidationFailure('Title must be less than 100 characters');
      }
    }

    // Description validation (if provided)
    if (request.description != null) {
      if (request.description!.isEmpty) {
        return const ValidationFailure('Description cannot be empty');
      }

      if (request.description!.length < 20) {
        return const ValidationFailure('Description must be at least 20 characters');
      }

      if (request.description!.length > 2000) {
        return const ValidationFailure('Description must be less than 2000 characters');
      }
    }

    // Pricing validation (if provided)
    if (request.pricing != null) {
      if (request.pricing!.cashPrice != null && request.pricing!.cashPrice! <= 0) {
        return const ValidationFailure('Cash price must be greater than 0');
      }

      if (request.pricing!.cashPrice != null && request.pricing!.cashPrice! > 1000000) {
        return const ValidationFailure('Cash price cannot exceed 1,000,000 TRY');
      }
    }

    // Barter options validation (if provided)
    if (request.pricing?.barterOptions != null) {
      final barterOptions = request.pricing!.barterOptions!;

      if (!barterOptions.acceptDirectSwap &&
          !barterOptions.acceptSwapWithCash &&
          !barterOptions.acceptBarterPool) {
        return const ValidationFailure('At least one barter option must be selected');
      }
    }

    // Location validation (if provided)
    if (request.location != null) {
      if (request.location!.city.isEmpty) {
        return const ValidationFailure('City cannot be empty');
      }

      if (request.location!.district.isEmpty) {
        return const ValidationFailure('District cannot be empty');
      }
    }

    return null;
  }
}
