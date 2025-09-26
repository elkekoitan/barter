import 'package:dartz/dartz.dart';
import '../../repositories/barter_repository.dart';
import '../../../core/errors/failures.dart';

class RejectOfferUseCase {
  final BarterRepository _repository;

  const RejectOfferUseCase(this._repository);

  Future<Either<Failure, void>> call(String offerId) async {
    return await _repository.rejectOffer(offerId);
  }
}
