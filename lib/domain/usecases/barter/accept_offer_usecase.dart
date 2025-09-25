import 'package:dartz/dartz.dart';
import '../../repositories/barter_repository.dart';
import '../../../core/errors/failures.dart';

class AcceptOfferUseCase {
  final BarterRepository _repository;

  const AcceptOfferUseCase(this._repository);

  Future<Either<Failure, BarterOfferEntity>> call(String offerId) async {
    // Validate offer ID
    if (offerId.isEmpty) {
      return const Left(ValidationFailure('Offer ID is required'));
    }

    // Accept the offer
    return await _repository.acceptOffer(offerId);
  }
}
