import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../repositories/notification_repository.dart';
import '../../../core/errors/failures.dart';

class RequestNotificationPermissionUseCase {
  final NotificationRepository _repository;

  const RequestNotificationPermissionUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.requestNotificationPermission();
  }
}

class CheckNotificationPermissionUseCase {
  final NotificationRepository _repository;

  const CheckNotificationPermissionUseCase(this._repository);

  Future<Either<Failure, bool>> call() async {
    return await _repository.checkNotificationPermission();
  }
}

class GetDeviceTokenUseCase {
  final NotificationRepository _repository;

  const GetDeviceTokenUseCase(this._repository);

  Future<Either<Failure, String?>> call() async {
    return await _repository.getDeviceToken();
  }
}

class SubscribeToTopicUseCase {
  final NotificationRepository _repository;

  const SubscribeToTopicUseCase(this._repository);

  Future<Either<Failure, void>> call(String topic) async {
    if (topic.isEmpty) {
      return const Left(ValidationFailure('Topic cannot be empty'));
    }

    if (topic.length > 50) {
      return const Left(ValidationFailure('Topic name too long (max 50 characters)'));
    }

    // Validate topic format (only alphanumeric, hyphens, and underscores)
    final validTopicPattern = RegExp(r'^[a-zA-Z0-9\-_]+$');
    if (!validTopicPattern.hasMatch(topic)) {
      return const Left(ValidationFailure('Invalid topic format'));
    }

    return await _repository.subscribeToTopic(topic);
  }
}

class UnsubscribeFromTopicUseCase {
  final NotificationRepository _repository;

  const UnsubscribeFromTopicUseCase(this._repository);

  Future<Either<Failure, void>> call(String topic) async {
    if (topic.isEmpty) {
      return const Left(ValidationFailure('Topic cannot be empty'));
    }

    return await _repository.unsubscribeFromTopic(topic);
  }
}

class SendPushNotificationUseCase {
  final NotificationRepository _repository;

  const SendPushNotificationUseCase(this._repository);

  Future<Either<Failure, void>> call(SendPushNotificationRequest request) async {
    // Validate request
    if (!request.isValid) {
      return const Left(ValidationFailure('Invalid push notification request'));
    }

    if (request.title.isEmpty) {
      return const Left(ValidationFailure('Notification title is required'));
    }

    if (request.message.isEmpty) {
      return const Left(ValidationFailure('Notification message is required'));
    }

    if (request.title.length > 100) {
      return const Left(ValidationFailure('Title too long (max 100 characters)'));
    }

    if (request.message.length > 500) {
      return const Left(ValidationFailure('Message too long (max 500 characters)'));
    }

    return await _repository.sendPushNotification(request);
  }
}

class SchedulePushNotificationUseCase {
  final NotificationRepository _repository;

  const SchedulePushNotificationUseCase(this._repository);

  Future<Either<Failure, void>> call(ScheduledPushNotificationRequest request) async {
    // Validate request
    if (request.title.isEmpty) {
      return const Left(ValidationFailure('Notification title is required'));
    }

    if (request.message.isEmpty) {
      return const Left(ValidationFailure('Notification message is required'));
    }

    // Check if scheduled time is in the future
    if (request.scheduledTime.isBefore(DateTime.now())) {
      return const Left(ValidationFailure('Scheduled time must be in the future'));
    }

    // Check if scheduled time is not too far in the future (max 30 days)
    final maxScheduledTime = DateTime.now().add(const Duration(days: 30));
    if (request.scheduledTime.isAfter(maxScheduledTime)) {
      return const Left(ValidationFailure('Cannot schedule notifications more than 30 days in advance'));
    }

    return await _repository.schedulePushNotification(request);
  }
}

class CancelScheduledPushNotificationUseCase {
  final NotificationRepository _repository;

  const CancelScheduledPushNotificationUseCase(this._repository);

  Future<Either<Failure, void>> call(String notificationId) async {
    if (notificationId.isEmpty) {
      return const Left(ValidationFailure('Notification ID is required'));
    }

    try {
      int.parse(notificationId);
    } catch (e) {
      return const Left(ValidationFailure('Invalid notification ID format'));
    }

    return await _repository.cancelScheduledPushNotification(notificationId);
  }
}

class GetSubscribedTopicsUseCase {
  final NotificationRepository _repository;

  const GetSubscribedTopicsUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() async {
    return await _repository.getSubscribedTopics();
  }
}

class HandleBackgroundMessageUseCase {
  final NotificationRepository _repository;

  const HandleBackgroundMessageUseCase(this._repository);

  Future<Either<Failure, void>> call(PushNotificationMessage message) async {
    // Handle background message
    debugPrint('Handling background message: ${message.title}');

    return await _repository.handleBackgroundMessage(message);
  }
}

class UpdatePushTokenUseCase {
  final NotificationRepository _repository;

  const UpdatePushTokenUseCase(this._repository);

  Future<Either<Failure, void>> call(String token) async {
    if (token.isEmpty) {
      return const Left(ValidationFailure('Push token cannot be empty'));
    }

    // Basic FCM token validation (should be around 152 characters)
    if (token.length < 100) {
      return const Left(ValidationFailure('Invalid push token format'));
    }

    return await _repository.updatePushToken(token);
  }
}

class RemovePushTokenUseCase {
  final NotificationRepository _repository;

  const RemovePushTokenUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.removePushToken();
  }
}

class InitializePushNotificationsUseCase {
  final NotificationRepository _repository;

  const InitializePushNotificationsUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    try {
      // Request permission
      final permissionResult = await _repository.requestNotificationPermission();
      if (permissionResult.isLeft()) {
        return permissionResult;
      }

      // Get device token
      final tokenResult = await _repository.getDeviceToken();
      if (tokenResult.isRight() && tokenResult.getOrElse(() => null) != null) {
        final token = tokenResult.getOrElse(() => '');
        await _repository.updatePushToken(token);
      }

      // Subscribe to default topics
      await _repository.subscribeToTopic('general');
      await _repository.subscribeToTopic('barter');

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
