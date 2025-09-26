import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/repositories/notification_repository.dart';

/// Simple in-memory cache for notifications to keep repository logic working
class NotificationLocalDataSource {
  static final List<NotificationEntity> _cache = [];

  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    NotificationFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    // basic filtering placeholder
    return Right(_cache);
  }

  Future<void> cacheNotifications(List<NotificationEntity> notifications) async {
    _cache
      ..clear()
      ..addAll(notifications);
  }

  Future<void> updateNotification(NotificationEntity notification) async {
    _cache.removeWhere((n) => n.id == notification.id);
    _cache.add(notification);
  }

  Future<void> deleteNotification(String notificationId) async {
    _cache.removeWhere((n) => n.id == notificationId);
  }

  Future<void> clearAllNotifications() async {
    _cache.clear();
  }

  Future<void> updateNotifications(List<NotificationEntity> notifications) async {
    for (final notification in notifications) {
      await updateNotification(notification);
    }
  }

  Future<void> deleteNotifications(List<String> notificationIds) async {
    _cache.removeWhere((n) => notificationIds.contains(n.id));
  }

  Future<Either<Failure, void>> scheduleLocalNotification(
    ScheduledPushNotificationRequest request,
  ) async {
    return const Right(null);
  }

  Future<Either<Failure, void>> cancelScheduledNotification(String notificationId) async {
    return const Right(null);
  }
}

