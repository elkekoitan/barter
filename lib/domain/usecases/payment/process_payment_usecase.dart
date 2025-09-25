import 'package:dartz/dartz.dart';
import '../../repositories/payment_repository.dart';
import '../../entities/payment.dart';
import '../../../core/errors/failures.dart';

class ProcessPaymentUsecase {
  final PaymentRepository _repository;

  const ProcessPaymentUsecase(this._repository);

  Future<Either<Failure, PaymentEntity>> call(PaymentRequest request) async {
    // Validate payment request
    final validationFailure = _validatePaymentRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Process payment through repository
    return await _repository.processPayment(request);
  }

  Failure? _validatePaymentRequest(PaymentRequest request) {
    if (request.amount <= 0) {
      return ValidationFailure('Amount must be greater than 0');
    }

    if (request.amount < 1.0 || request.amount > 50000.0) {
      return ValidationFailure('Amount must be between 1.0 and 50000.0 TRY');
    }

    if (!['TRY', 'USD', 'EUR'].contains(request.currency)) {
      return ValidationFailure('Unsupported currency');
    }

    if (!['papara', 'tosla', 'iyzico', 'paytr', 'bkm_express', 'paycell', 'param']
        .contains(request.provider)) {
      return ValidationFailure('Unsupported payment provider');
    }

    return null;
  }
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}
