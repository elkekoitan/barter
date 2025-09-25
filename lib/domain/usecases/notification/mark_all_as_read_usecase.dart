import 'package:dartz/dartz.dart';
import '../../repositories/notification_repository.dart';
import '../../../core/errors/failures.dart';

class MarkAllAsReadUseCase {
  final NotificationRepository _repository;

  const MarkAllAsReadUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.markAllAsRead();
  }
}
