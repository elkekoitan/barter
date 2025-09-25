import 'package:dartz/dartz.dart';
import '../../repositories/listing_repository.dart';
import '../../../core/errors/failures.dart';

class DeleteListingUseCase {
  final ListingRepository _repository;

  const DeleteListingUseCase(this._repository);

  Future<Either<Failure, void>> call(String listingId) async {
    // Validate listing ID
    if (listingId.isEmpty) {
      return const Left(ValidationFailure('Listing ID is required'));
    }

    // Delete the listing
    return await _repository.deleteListing(listingId);
  }
}
