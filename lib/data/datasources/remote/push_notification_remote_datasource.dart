import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/repositories/notification_repository.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

abstract class PushNotificationRemoteDataSource {
  Future<Either<Failure, void>> requestPermission();
  Future<Either<Failure, bool>> checkPermission();
  Future<Either<Failure, String?>> getDeviceToken();
  Future<Either<Failure, void>> subscribeToTopic(String topic);
  Future<Either<Failure, void>> unsubscribeFromTopic(String topic);
  Future<Either<Failure, void>> sendPushNotification(SendPushNotificationRequest request);
  Future<Either<Failure, void>> schedulePushNotification(ScheduledPushNotificationRequest request);
  Future<Either<Failure, void>> cancelScheduledPushNotification(String notificationId);
  Future<Either<Failure, List<String>>> getSubscribedTopics();
  Future<Either<Failure, void>> handleBackgroundMessage(PushNotificationMessage message);
  Stream<Either<Failure, PushNotificationMessage>> onMessageReceived();
  Stream<Either<Failure, PushNotificationMessage>> onMessageOpenedApp();
  Future<Either<Failure, void>> updatePushToken(String token);
  Future<Either<Failure, void>> removePushToken();
}

class PushNotificationRemoteDataSourceImpl implements PushNotificationRemoteDataSource {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  PushNotificationRemoteDataSourceImpl({
    required FirebaseMessaging firebaseMessaging,
    required FlutterLocalNotificationsPlugin localNotifications,
  })  : _firebaseMessaging = firebaseMessaging,
        _localNotifications = localNotifications;

  @override
  Future<Either<Failure, void>> requestPermission() async {
    try {
      // Request permission for iOS
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        return const Right(null);
      } else {
        return const Left(PermissionFailure('Notification permission denied'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPermission() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return Right(settings.authorizationStatus == AuthorizationStatus.authorized);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPushNotification(SendPushNotificationRequest request) async {
    try {
      // This would typically be handled by a backend service
      // For now, we'll just log the request
      debugPrint('Send push notification: ${request.title} - ${request.message}');

      // In a real implementation, you would call your backend API here
      // which would then use Firebase Admin SDK to send the notification

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> schedulePushNotification(ScheduledPushNotificationRequest request) async {
    try {
      // Schedule local notification using Flutter Local Notifications
      final androidDetails = const AndroidNotificationDetails(
        'barter_channel',
        'Barter Notifications',
        channelDescription: 'Notifications for barter offers and messages',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      final iosDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.zonedSchedule(
        request.scheduledTime.millisecondsSinceEpoch ~/ 1000,
        request.title,
        request.message,
        request.scheduledTime.toTimeZone(),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelScheduledPushNotification(String notificationId) async {
    try {
      await _localNotifications.cancel(int.parse(notificationId));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSubscribedTopics() async {
    try {
      // Firebase Messaging doesn't provide a way to get subscribed topics
      // In a real implementation, you would track this locally or in your backend
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> handleBackgroundMessage(PushNotificationMessage message) async {
    try {
      // Handle background message
      debugPrint('Handling background message: ${message.title}');

      // Show local notification for background messages
      await _showLocalNotification(message);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePushToken(String token) async {
    try {
      // Update push token in Firebase
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint('Push token updated: $token');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removePushToken() async {
    try {
      // Remove push token by deleting it
      await _firebaseMessaging.deleteToken();

      debugPrint('Push token removed');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, PushNotificationMessage>> onMessageReceived() {
    return FirebaseMessaging.onMessage.map((remoteMessage) {
      try {
        return Right(_convertRemoteMessageToPushMessage(remoteMessage));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    });
  }

  @override
  Stream<Either<Failure, PushNotificationMessage>> onMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp.map((remoteMessage) {
      try {
        return Right(_convertRemoteMessageToPushMessage(remoteMessage));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    });
  }

  Future<void> _showLocalNotification(PushNotificationMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'barter_channel',
      'Barter Notifications',
      channelDescription: 'Notifications for barter offers and messages',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.title,
      message.body,
      notificationDetails,
    );
  }

  PushNotificationMessage _convertRemoteMessageToPushMessage(RemoteMessage message) {
    return PushNotificationMessage(
      token: message.data['token'] ?? '',
      title: message.notification?.title ?? 'Barter',
      body: message.notification?.body ?? '',
      data: message.data,
      imageUrl: message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl,
      sound: (message.notification?.android?.sound ?? message.notification?.apple?.sound ?? 'default').toString(),
      clickAction: message.notification?.android?.clickAction,
      category: message.category?.toString(),
      androidConfig: message.notification?.android != null
          ? {
              'channelId': message.notification!.android!.channelId ?? 'default',
              'color': message.notification!.android!.color ?? 'default',
              'smallIcon': message.notification!.android!.smallIcon ?? 'ic_notification',
              'priority': message.notification!.android!.priority.toString(),
            }
          : null,
      iosConfig: message.notification?.apple != null
          ? {
              'subtitle': message.notification!.apple!.subtitle ?? '',
              'badge': message.notification!.apple!.badge?.toString() ?? '1',
              'sound': message.notification!.apple!.sound ?? 'default',
              'category': 'default',
            }
          : null,
    );
  }
}

// Extension for DateTime to work with Flutter Local Notifications
extension DateTimeExtension on DateTime {
  tz.TZDateTime toTimeZone() {
    return tz.TZDateTime.from(this, tz.local);
  }
}

