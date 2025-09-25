import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/local/notification_local_datasource.dart';
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
      final remoteNotifications = await _remoteDataSource.getNotifications(
        filter: filter,
        page: page,
        limit: limit,
      );

      return remoteNotifications.fold(
        (failure) => Left(failure),
        (notifications) async {
          // Cache the notifications
          await _localDataSource.cacheNotifications(notifications);
          return Right(notifications);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> getNotificationById(String notificationId) async {
    try {
      return await _remoteDataSource.getNotificationById(notificationId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> markAsRead(String notificationId) async {
    try {
      final result = await _remoteDataSource.markAsRead(notificationId);
      return result.fold(
        (failure) => Left(failure),
        (notification) async {
          // Update local cache
          await _localDataSource.updateNotification(notification);
          return Right(notification);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      final result = await _remoteDataSource.deleteNotification(notificationId);
      return result.fold(
        (failure) => Left(failure),
        (_) async {
          // Remove from local cache
          await _localDataSource.deleteNotification(notificationId);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllNotifications() async {
    try {
      final result = await _remoteDataSource.deleteAllNotifications();
      return result.fold(
        (failure) => Left(failure),
        (_) async {
          // Clear local cache
          await _localDataSource.clearAllNotifications();
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> createNotification(CreateNotificationRequest request) async {
    try {
      return await _remoteDataSource.createNotification(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> getNotificationSettings() async {
    try {
      return await _remoteDataSource.getNotificationSettings();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(UpdateSettingsRequest request) async {
    try {
      return await _remoteDataSource.updateNotificationSettings(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationStats>> getNotificationStats() async {
    try {
      return await _remoteDataSource.getNotificationStats();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> markMultipleAsRead(List<String> notificationIds) async {
    try {
      final result = await _remoteDataSource.markMultipleAsRead(notificationIds);
      return result.fold(
        (failure) => Left(failure),
        (notifications) async {
          // Update local cache
          await _localDataSource.updateNotifications(notifications);
          return Right(notifications);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMultipleNotifications(List<String> notificationIds) async {
    try {
      final result = await _remoteDataSource.deleteMultipleNotifications(notificationIds);
      return result.fold(
        (failure) => Left(failure),
        (_) async {
          // Remove from local cache
          await _localDataSource.deleteNotifications(notificationIds);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> searchNotifications(SearchNotificationsRequest request) async {
    try {
      return await _remoteDataSource.searchNotifications(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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
