import 'package:dartz/dartz.dart';
import '../../repositories/payment_repository.dart';
import '../../../core/errors/failures.dart';

class ReleaseEscrowUseCase {
  final PaymentRepository _repository;

  const ReleaseEscrowUseCase(this._repository);

  Future<Either<Failure, void>> call(String escrowId) async {
    return await _repository.releaseEscrow(escrowId);
  }
}
