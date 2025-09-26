import 'package:dartz/dartz.dart';
import '../../repositories/payment_repository.dart';
import '../../../core/errors/failures.dart';

class RefundPaymentUseCase {
  final PaymentRepository _repository;

  const RefundPaymentUseCase(this._repository);

  Future<Either<Failure, void>> call(String paymentId, double amount) async {
    return await _repository.refundPayment(paymentId, amount);
  }
}
