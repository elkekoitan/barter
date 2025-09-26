import 'package:dartz/dartz.dart';
import '../../repositories/payment_repository.dart';
import '../../../core/errors/failures.dart';

class CreateEscrowUseCase {
  final PaymentRepository _repository;

  const CreateEscrowUseCase(this._repository);

  Future<Either<Failure, void>> call(String barterId, double amount, String currency) async {
    final escrowRequest = EscrowRequest(
      barterId: barterId,
      userId: '', // TODO: Get current user ID
      amount: amount,
      currency: currency,
    );
    return await _repository.createEscrow(escrowRequest);
  }
}

class EscrowRequest {
  final String barterId;
  final String userId;
  final double amount;
  final String currency;
  final DateTime? releaseDate;

  const EscrowRequest({
    required this.barterId,
    required this.userId,
    required this.amount,
    required this.currency,
    this.releaseDate,
  });
}
