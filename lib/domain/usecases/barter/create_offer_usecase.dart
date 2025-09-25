import 'package:dartz/dartz.dart';
import '../../repositories/barter_repository.dart';
import '../../../core/errors/failures.dart';

class CreateOfferUseCase {
  final BarterRepository _repository;

  const CreateOfferUseCase(this._repository);

  Future<Either<Failure, BarterOfferEntity>> call(CreateOfferRequest request) async {
    // Validate offer request
    final validationFailure = _validateOfferRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Create the offer
    return await _repository.createOffer(request);
  }

  Failure? _validateOfferRequest(CreateOfferRequest request) {
    // Listing ID validation
    if (request.listingId.isEmpty) {
      return const ValidationFailure('Listing ID is required');
    }

    // Buyer ID validation
    if (request.buyerId.isEmpty) {
      return const ValidationFailure('Buyer ID is required');
    }

    // Offer details validation
    final offerValidation = _validateOfferDetails(request.offer);
    if (offerValidation != null) {
      return offerValidation;
    }

    return null;
  }

  Failure? _validateOfferDetails(CreateOfferDetails offer) {
    // Check if offer has any value
    if (offer.items.isEmpty && offer.cashAmount <= 0) {
      return const ValidationFailure('Offer must contain items or cash');
    }

    // Validate cash amount
    if (offer.cashAmount < 0) {
      return const ValidationFailure('Cash amount cannot be negative');
    }

    if (offer.cashAmount > 1000000) {
      return const ValidationFailure('Cash amount cannot exceed 1,000,000 TRY');
    }

    // Validate items
    if (offer.items.isNotEmpty) {
      for (final item in offer.items) {
        final itemValidation = _validateOfferItem(item);
        if (itemValidation != null) {
          return itemValidation;
        }
      }
    }

    // Validate total value
    final totalValue = _calculateTotalValue(offer);
    if (totalValue <= 0) {
      return const ValidationFailure('Offer must have a positive total value');
    }

    return null;
  }

  Failure? _validateOfferItem(CreateOfferItem item) {
    if (item.listingId.isEmpty) {
      return const ValidationFailure('Item listing ID is required');
    }

    if (item.estimatedValue <= 0) {
      return const ValidationFailure('Item value must be greater than 0');
    }

    if (item.estimatedValue > 500000) {
      return const ValidationFailure('Item value cannot exceed 500,000 TRY');
    }

    return null;
  }

  double _calculateTotalValue(CreateOfferDetails offer) {
    double total = offer.cashAmount;
    for (final item in offer.items) {
      total += item.estimatedValue;
    }
    return total;
  }
}
