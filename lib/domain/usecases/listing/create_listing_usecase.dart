import 'package:dartz/dartz.dart';
import '../../repositories/listing_repository.dart';
import '../../../core/errors/failures.dart';

class CreateListingUseCase {
  final ListingRepository _repository;

  const CreateListingUseCase(this._repository);

  Future<Either<Failure, ListingEntity>> call(CreateListingRequest request) async {
    // Validate listing request
    final validationFailure = _validateListingRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Create the listing
    return await _repository.createListing(request);
  }

  Failure? _validateListingRequest(CreateListingRequest request) {
    // Title validation
    if (request.title.isEmpty) {
      return const ValidationFailure('Title is required');
    }

    if (request.title.length < 10) {
      return const ValidationFailure('Title must be at least 10 characters');
    }

    if (request.title.length > 100) {
      return const ValidationFailure('Title must be less than 100 characters');
    }

    // Description validation
    if (request.description.isEmpty) {
      return const ValidationFailure('Description is required');
    }

    if (request.description.length < 20) {
      return const ValidationFailure('Description must be at least 20 characters');
    }

    if (request.description.length > 2000) {
      return const ValidationFailure('Description must be less than 2000 characters');
    }

    // Category validation
    if (request.categoryId.isEmpty) {
      return const ValidationFailure('Category is required');
    }

    // Media validation
    if (request.mediaUrls.isEmpty) {
      return const ValidationFailure('At least one image is required');
    }

    if (request.mediaUrls.length > 10) {
      return const ValidationFailure('Maximum 10 images allowed');
    }

    // Pricing validation
    if (request.pricing.cashPrice != null && request.pricing.cashPrice! <= 0) {
      return const ValidationFailure('Cash price must be greater than 0');
    }

    if (request.pricing.cashPrice != null && request.pricing.cashPrice! > 1000000) {
      return const ValidationFailure('Cash price cannot exceed 1,000,000 TRY');
    }

    // Location validation
    if (request.location.city.isEmpty) {
      return const ValidationFailure('City is required');
    }

    if (request.location.district.isEmpty) {
      return const ValidationFailure('District is required');
    }

    // Delivery validation
    if (request.delivery.methods.isEmpty) {
      return const ValidationFailure('At least one delivery method is required');
    }

    // Validate barter options
    if (!request.pricing.barterOptions.acceptDirectSwap &&
        !request.pricing.barterOptions.acceptSwapWithCash &&
        !request.pricing.barterOptions.acceptBarterPool) {
      return const ValidationFailure('At least one barter option must be selected');
    }

    return null;
  }
}
