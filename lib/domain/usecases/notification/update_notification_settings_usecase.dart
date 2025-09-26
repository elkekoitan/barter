import 'package:dartz/dartz.dart';
import '../../repositories/notification_repository.dart';
import '../../../core/errors/failures.dart';

class UpdateNotificationSettingsUseCase {
  final NotificationRepository _repository;

  const UpdateNotificationSettingsUseCase(this._repository);

  Future<Either<Failure, NotificationSettings>> call(NotificationSettingsEntity settings) async {
    // Validate settings
    final validationFailure = _validateSettings(settings);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Update settings by user ID
    return await _repository.updateNotificationSettingsByUserId(settings.userId, _mapToRequest(settings));
  }

  Failure? _validateSettings(NotificationSettingsEntity settings) {
    // At least one channel should be enabled
    final hasAnyChannel = settings.pushNotifications ||
                         settings.emailNotifications ||
                         (settings.categorySettings.values.any((enabled) => enabled));

    if (!hasAnyChannel) {
      return const ValidationFailure('At least one notification channel must be enabled');
    }

    return null;
  }

  UpdateSettingsRequest _mapToRequest(NotificationSettingsEntity settings) {
    return UpdateSettingsRequest(
      userId: settings.userId,
      pushEnabled: settings.pushNotifications,
      emailEnabled: settings.emailNotifications,
      inAppEnabled: settings.categorySettings.values.any((enabled) => enabled),
    );
  }
}
