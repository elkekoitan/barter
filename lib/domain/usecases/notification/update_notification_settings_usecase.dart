import 'package:dartz/dartz.dart';
import '../../repositories/notification_repository.dart';
import '../../../core/errors/failures.dart';

class UpdateNotificationSettingsUseCase {
  final NotificationRepository _repository;

  const UpdateNotificationSettingsUseCase(this._repository);

  Future<Either<Failure, NotificationSettings>> call(UpdateSettingsRequest request) async {
    // Validate request
    final validationFailure = _validateRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Update settings
    return await _repository.updateNotificationSettings(request);
  }

  Failure? _validateRequest(UpdateSettingsRequest request) {
    // At least one channel should be enabled
    final hasAnyChannel = request.pushEnabled == true ||
                         request.emailEnabled == true ||
                         request.smsEnabled == true ||
                         request.inAppEnabled == true;

    if (!hasAnyChannel) {
      return const ValidationFailure('At least one notification channel must be enabled');
    }

    return null;
  }
}
