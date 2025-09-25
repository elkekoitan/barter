import 'package:dartz/dartz.dart';
import '../../repositories/notification_repository.dart';
import '../../../core/errors/failures.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;

  const GetNotificationsUseCase(this._repository);

  Future<Either<Failure, List<NotificationEntity>>> call({
    NotificationFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    // Validate parameters
    final validationFailure = _validateParameters(page, limit);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Get notifications from repository
    return await _repository.getNotifications(
      filter: filter,
      page: page,
      limit: limit,
    );
  }

  Failure? _validateParameters(int page, int limit) {
    if (page < 1) {
      return const ValidationFailure('Page must be greater than 0');
    }

    if (limit < 1 || limit > 100) {
      return const ValidationFailure('Limit must be between 1 and 100');
    }

    return null;
  }
}
