import '../datasources/local/notification_local_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/remote/notification_remote_datasource.dart';
import '../datasources/remote/push_notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {

  final NotificationLocalDataSource _localDataSource;
  final NotificationRemoteDataSource _remoteDataSource;
  final PushNotificationRemoteDataSource _pushDataSource;

  const NotificationRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._pushDataSource,
  );

  // Notification Management
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    NotificationFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Try to get from local cache first
      final cachedNotifications = await _localDataSource.getNotifications(
        filter: filter,
        page: page,
        limit: limit,
      );

      if (cachedNotifications.isRight()) {
        final notifications = cachedNotifications.getOrElse(() => []);
        if (notifications.isNotEmpty) {
          return Right(notifications);
        }
      }

      // If no cached data, get from remote
      final remoteNotifications = await _remoteDataSource.getNotifications('');
      return Right(remoteNotifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> getNotificationById(String notificationId) async {
    try {
      final notification = await _remoteDataSource.getNotificationById(notificationId);
      return Right(notification);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> markAsRead(String notificationId) async {
    try {
      final notification = await _remoteDataSource.markAsRead(notificationId);
      return Right(notification);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      // For now, just delete from local cache
      await _localDataSource.deleteNotification(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllNotifications() async {
    try {
      // Clear local cache
      await _localDataSource.clearAllNotifications();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> createNotification(CreateNotificationRequest request) async {
    try {
      // TODO: Implement remote creation when backend is ready
      return const Left(ServerFailure('Not implemented yet'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> getNotificationSettings() async {
    try {
      final settingsEntity = await _remoteDataSource.getNotificationSettings('');
      // Convert to NotificationSettings
      final settings = NotificationSettings(
        userId: '',
        pushEnabled: settingsEntity.pushNotifications,
        emailEnabled: settingsEntity.emailNotifications,
        smsEnabled: settingsEntity.smsNotifications,
        inAppEnabled: true,
        categories: NotificationCategorySettings(
          messages: settingsEntity.messages,
          offers: settingsEntity.offers,
          transactions: settingsEntity.transactions,
          system: settingsEntity.system,
        ),
      );
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(UpdateSettingsRequest request) async {
    try {
      // Convert request to entity
      final settingsEntity = NotificationSettingsEntity(
        userId: '',
        pushNotifications: request.pushEnabled ?? true,
        emailNotifications: request.emailEnabled ?? false,
        smsNotifications: request.smsEnabled ?? false,
        messages: request.categories?.messages ?? true,
        offers: request.categories?.offers ?? true,
        transactions: request.categories?.transactions ?? true,
        system: request.categories?.system ?? true,
      );
      final updatedEntity = await _remoteDataSource.updateNotificationSettings('', settingsEntity);
      final settings = NotificationSettings(
        userId: '',
        pushEnabled: updatedEntity.pushNotifications,
        emailEnabled: updatedEntity.emailNotifications,
        smsEnabled: updatedEntity.smsNotifications,
        inAppEnabled: true,
        categories: NotificationCategorySettings(
          messages: updatedEntity.messages,
          offers: updatedEntity.offers,
          transactions: updatedEntity.transactions,
          system: updatedEntity.system,
        ),
      );
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationStats>> getNotificationStats() async {
    try {
      // TODO: Implement when backend is ready
      return const Right(NotificationStats(
        total: 0,
        unread: 0,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> markMultipleAsRead(List<String> notificationIds) async {
    try {
      // TODO: Implement batch marking
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMultipleNotifications(List<String> notificationIds) async {
    try {
      // Remove from local cache
      await _localDataSource.deleteNotifications(notificationIds);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> searchNotifications(SearchNotificationsRequest request) async {
    try {
      // TODO: Implement search
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Missing methods implementation
  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final notifications = await _localDataSource.getNotifications();
      return notifications.fold(
        (failure) => Left(failure),
        (notifs) => Right(notifs.where((n) => !n.isRead).length),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _localDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateNotificationSettingsByUserId(String userId, UpdateSettingsRequest request) async {
    // Same as updateNotificationSettings but with userId
    return updateNotificationSettings(request);
  }

  // Push Token Management
  @override
  Future<Either<Failure, void>> updatePushToken(String token) async {
    try {
      // Update push token via push notification data source
      await _pushDataSource.updatePushToken(token);
      debugPrint('Push token updated: $token');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removePushToken() async {
    try {
      // Remove push token via push notification data source
      await _pushDataSource.removePushToken();
      debugPrint('Push token removed');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Push Notification Management
  @override
  Future<Either<Failure, void>> requestNotificationPermission() async {
    try {
      return await _pushDataSource.requestPermission();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkNotificationPermission() async {
    try {
      return await _pushDataSource.checkPermission();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getDeviceToken() async {
    try {
      return await _pushDataSource.getDeviceToken();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToTopic(String topic) async {
    try {
      return await _pushDataSource.subscribeToTopic(topic);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromTopic(String topic) async {
    try {
      return await _pushDataSource.unsubscribeFromTopic(topic);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPushNotification(SendPushNotificationRequest request) async {
    try {
      return await _pushDataSource.sendPushNotification(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> schedulePushNotification(ScheduledPushNotificationRequest request) async {
    try {
      return await _pushDataSource.schedulePushNotification(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelScheduledPushNotification(String notificationId) async {
    try {
      return await _pushDataSource.cancelScheduledPushNotification(notificationId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSubscribedTopics() async {
    try {
      return await _pushDataSource.getSubscribedTopics();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> handleBackgroundMessage(PushNotificationMessage message) async {
    try {
      return await _pushDataSource.handleBackgroundMessage(message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Notification Actions
  @override
  Future<Either<Failure, bool>> performNotificationAction(String notificationId, NotificationAction action) async {
    try {
      return await _remoteDataSource.performNotificationAction(notificationId, action);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Local Notifications
  @override
  Future<Either<Failure, void>> scheduleLocalNotification(ScheduledNotificationRequest request) async {
    try {
      return await _localDataSource.scheduleLocalNotification(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelScheduledNotification(String notificationId) async {
    try {
      return await _localDataSource.cancelScheduledNotification(notificationId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
