import 'package:dartz/dartz.dart';
import '../../repositories/barter_repository.dart';
import '../../../core/errors/failures.dart';

class CreateTransactionUseCase {
  final BarterRepository _repository;

  const CreateTransactionUseCase(this._repository);

  Future<Either<Failure, BarterTransactionEntity>> call(CreateTransactionRequest request) async {
    // Validate transaction request
    final validationFailure = _validateTransactionRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Create the transaction
    return await _repository.createTransaction(request);
  }

  Failure? _validateTransactionRequest(CreateTransactionRequest request) {
    // Offer ID validation
    if (request.offerId.isEmpty) {
      return const ValidationFailure('Offer ID is required');
    }

    // Delivery info validation (if provided)
    if (request.deliveryInfo != null) {
      final deliveryValidation = _validateDeliveryInfo(request.deliveryInfo!);
      if (deliveryValidation != null) {
        return deliveryValidation;
      }
    }

    return null;
  }

  Failure? _validateDeliveryInfo(TransactionDelivery delivery) {
    // Method validation
    if (delivery.method == DeliveryMethod.cargo) {
      // Cargo delivery requires tracking information
      if (delivery.trackingNumber?.isEmpty ?? true) {
        return const ValidationFailure('Tracking number is required for cargo delivery');
      }

      if (delivery.carrier?.isEmpty ?? true) {
        return const ValidationFailure('Carrier is required for cargo delivery');
      }
    }

    // Location validation
    if (delivery.pickupLocation != null) {
      if (delivery.pickupLocation!.city.isEmpty || delivery.pickupLocation!.district.isEmpty) {
        return const ValidationFailure('Valid pickup location is required');
      }
    }

    if (delivery.deliveryLocation != null) {
      if (delivery.deliveryLocation!.city.isEmpty || delivery.deliveryLocation!.district.isEmpty) {
        return const ValidationFailure('Valid delivery location is required');
      }
    }

    return null;
  }
}
