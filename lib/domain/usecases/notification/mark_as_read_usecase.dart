import 'package:dartz/dartz.dart';
import '../../repositories/notification_repository.dart';
import '../../../core/errors/failures.dart';

class MarkAsReadUseCase {
  final NotificationRepository _repository;

  const MarkAsReadUseCase(this._repository);

  Future<Either<Failure, NotificationEntity>> call(String notificationId) async {
    // Validate notification ID
    if (notificationId.isEmpty) {
      return const Left(ValidationFailure('Notification ID is required'));
    }

    // Mark as read
    return await _repository.markAsRead(notificationId);
  }
}
