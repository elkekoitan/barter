import 'package:dartz/dartz.dart';
import '../../repositories/barter_repository.dart';
import '../../../core/errors/failures.dart';

class CompleteBarterUseCase {
  final BarterRepository _repository;

  const CompleteBarterUseCase(this._repository);

  Future<Either<Failure, void>> call(String transactionId) async {
    return await _repository.updateTransactionStatus(transactionId, 'completed');
  }
}
