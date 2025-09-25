import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  // Basic CRUD Operations
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    NotificationFilter? filter,
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, NotificationEntity>> getNotificationById(String notificationId);
  Future<Either<Failure, NotificationEntity>> markAsRead(String notificationId);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteNotification(String notificationId);
  Future<Either<Failure, void>> deleteAllNotifications();
  Future<Either<Failure, int>> getUnreadCount();

  // Notification Creation (Server-side)
  Future<Either<Failure, NotificationEntity>> createNotification(CreateNotificationRequest request);

  // Settings Management
  Future<Either<Failure, NotificationSettings>> getNotificationSettings();
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(UpdateSettingsRequest request);

  // Analytics
  Future<Either<Failure, NotificationStats>> getNotificationStats();

  // Bulk Operations
  Future<Either<Failure, List<NotificationEntity>>> markMultipleAsRead(List<String> notificationIds);
  Future<Either<Failure, void>> deleteMultipleNotifications(List<String> notificationIds);

  // Search & Filter
  Future<Either<Failure, List<NotificationEntity>>> searchNotifications(SearchNotificationsRequest request);

  // Push Token Management
  Future<Either<Failure, void>> updatePushToken(String token);
  Future<Either<Failure, void>> removePushToken();

  // Push Notification Management
  Future<Either<Failure, void>> requestNotificationPermission();
  Future<Either<Failure, bool>> checkNotificationPermission();
  Future<Either<Failure, String?>> getDeviceToken();
  Future<Either<Failure, void>> subscribeToTopic(String topic);
  Future<Either<Failure, void>> unsubscribeFromTopic(String topic);
  Future<Either<Failure, void>> sendPushNotification(SendPushNotificationRequest request);
  Future<Either<Failure, void>> schedulePushNotification(ScheduledPushNotificationRequest request);
  Future<Either<Failure, void>> cancelScheduledPushNotification(String notificationId);
  Future<Either<Failure, List<String>>> getSubscribedTopics();
  Future<Either<Failure, void>> handleBackgroundMessage(PushNotificationMessage message);

  // Notification Actions
  Future<Either<Failure, bool>> performNotificationAction(String notificationId, NotificationAction action);

  // Local Notifications (for offline support)
  Future<Either<Failure, void>> scheduleLocalNotification(ScheduledNotificationRequest request);
  Future<Either<Failure, void>> cancelScheduledNotification(String notificationId);
}

// Request/Response Models
class CreateNotificationRequest {
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final NotificationData? data;
  final String? imageUrl;
  final bool isImportant;
  final NotificationPriority priority;
  final List<NotificationChannel> channels;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;
  final DateTime? scheduledAt;

  const CreateNotificationRequest({
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.imageUrl,
    this.isImportant = false,
    this.priority = NotificationPriority.normal,
    this.channels = const [NotificationChannel.push, NotificationChannel.inApp],
    this.actionUrl,
    this.metadata,
    this.scheduledAt,
  });
}

class UpdateSettingsRequest {
  final bool? pushEnabled;
  final bool? emailEnabled;
  final bool? smsEnabled;
  final bool? inAppEnabled;
  final NotificationCategorySettings? categories;

  const UpdateSettingsRequest({
    this.pushEnabled,
    this.emailEnabled,
    this.smsEnabled,
    this.inAppEnabled,
    this.categories,
  });
}

class NotificationFilter {
  final NotificationType? type;
  final bool? isRead;
  final bool? isImportant;
  final NotificationPriority? priority;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final String? searchQuery;
  final List<String>? excludeTypes;

  const NotificationFilter({
    this.type,
    this.isRead,
    this.isImportant,
    this.priority,
    this.createdAfter,
    this.createdBefore,
    this.searchQuery,
    this.excludeTypes,
  });
}

class SearchNotificationsRequest {
  final String query;
  final NotificationFilter? filter;
  final int page;
  final int limit;
  final NotificationSearchSort sortBy;
  final bool sortDescending;

  const SearchNotificationsRequest({
    required this.query,
    this.filter,
    this.page = 1,
    this.limit = 20,
    this.sortBy = NotificationSearchSort.createdAt,
    this.sortDescending = true,
  });
}

class ScheduledNotificationRequest {
  final String id;
  final String title;
  final String message;
  final String? imageUrl;
  final DateTime scheduledAt;
  final NotificationPriority priority;
  final Map<String, dynamic>? payload;

  const ScheduledNotificationRequest({
    required this.id,
    required this.title,
    required this.message,
    this.imageUrl,
    required this.scheduledAt,
    this.priority = NotificationPriority.normal,
    this.payload,
  });
}

class SendPushNotificationRequest {
  final String? userId;
  final String? deviceToken;
  final String? topic;
  final String title;
  final String message;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final NotificationPriority priority;
  final bool isScheduled;
  final DateTime? scheduledTime;
  final String? sound;
  final String? channelId;

  const SendPushNotificationRequest({
    this.userId,
    this.deviceToken,
    this.topic,
    required this.title,
    required this.message,
    this.imageUrl,
    this.data,
    this.priority = NotificationPriority.normal,
    this.isScheduled = false,
    this.scheduledTime,
    this.sound = 'default',
    this.channelId,
  });

  bool get hasTarget => userId != null || deviceToken != null || topic != null;

  bool get isValid => hasTarget && title.isNotEmpty && message.isNotEmpty;
}

class ScheduledPushNotificationRequest extends SendPushNotificationRequest {
  final DateTime scheduledTime;

  const ScheduledPushNotificationRequest({
    required String title,
    required String message,
    required this.scheduledTime,
    super.userId,
    super.deviceToken,
    super.topic,
    super.imageUrl,
    super.data,
    super.priority,
    super.sound,
    super.channelId,
  }) : super(isScheduled: true);
}

class PushNotificationMessage extends Equatable {
  final String token;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? sound;
  final String? clickAction;
  final Map<String, String>? androidConfig;
  final Map<String, String>? iosConfig;

  const PushNotificationMessage({
    required this.token,
    required this.title,
    required this.body,
    this.data,
    this.imageUrl,
    this.sound = 'default',
    this.clickAction,
    this.androidConfig,
    this.iosConfig,
  });

  @override
  List<Object?> get props => [
        token,
        title,
        body,
        data,
        imageUrl,
        sound,
        clickAction,
        androidConfig,
        iosConfig,
      ];
}

enum NotificationSearchSort {
  createdAt('created_at', 'Oluşturulma Tarihi'),
  priority('priority', 'Öncelik'),
  type('type', 'Tür'),
  title('title', 'Başlık'),
  relevance('relevance', 'Alaka');

  const NotificationSearchSort(this.value, this.displayName);
  final String value;
  final String displayName;
}
