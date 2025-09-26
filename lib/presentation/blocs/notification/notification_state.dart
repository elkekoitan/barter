import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/entities/notification_settings.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoading extends NotificationState {
  final bool isLoadMore;

  const NotificationsLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class SettingsLoading extends NotificationState {}

// Success States
class NotificationsLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const NotificationsLoaded({
    required this.notifications,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [notifications, hasMore, currentPage, totalCount];
}

class NotificationLoaded extends NotificationState {
  final NotificationEntity notification;

  const NotificationLoaded(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationMarkedAsRead extends NotificationState {
  final NotificationEntity notification;

  const NotificationMarkedAsRead(this.notification);

  @override
  List<Object?> get props => [notification];
}

class AllNotificationsMarkedAsRead extends NotificationState {}

class NotificationDeleted extends NotificationState {
  final String notificationId;

  const NotificationDeleted(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class AllNotificationsDeleted extends NotificationState {}

class SettingsLoaded extends NotificationState {
  final NotificationSettings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsUpdated extends NotificationState {
  final NotificationSettings settings;

  const SettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}

class NotificationStatsLoaded extends NotificationState {
  final NotificationStats stats;

  const NotificationStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class UnreadCountLoaded extends NotificationState {
  final int unreadCount;

  const UnreadCountLoaded(this.unreadCount);

  @override
  List<Object?> get props => [unreadCount];
}

class PushTokenUpdated extends NotificationState {}

class PushTokenRemoved extends NotificationState {}

class LocalNotificationScheduled extends NotificationState {
  final String notificationId;

  const LocalNotificationScheduled(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class LocalNotificationCancelled extends NotificationState {
  final String notificationId;

  const LocalNotificationCancelled(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MultipleNotificationsMarkedAsRead extends NotificationState {
  final List<String> notificationIds;

  const MultipleNotificationsMarkedAsRead(this.notificationIds);

  @override
  List<Object?> get props => [notificationIds];
}

class MultipleNotificationsDeleted extends NotificationState {
  final List<String> notificationIds;

  const MultipleNotificationsDeleted(this.notificationIds);

  @override
  List<Object?> get props => [notificationIds];
}

class NotificationsSearched extends NotificationState {
  final List<NotificationEntity> notifications;
  final String query;

  const NotificationsSearched(this.notifications, this.query);

  @override
  List<Object?> get props => [notifications, query];
}

class NotificationCacheCleared extends NotificationState {}

class NotificationReceivedInForeground extends NotificationState {
  final NotificationEntity notification;

  const NotificationReceivedInForeground(this.notification);

  @override
  List<Object?> get props => [notification];
}

// Error State
class NotificationError extends NotificationState {
  final String message;
  final String? code;
  final NotificationErrorType? errorType;

  const NotificationError(this.message, {this.code, this.errorType});

  @override
  List<Object?> get props => [message, code, errorType];
}

enum NotificationErrorType {
  network('network', 'Ağ Hatası'),
  permission('permission', 'İzin Hatası'),
  quota('quota', 'Kota Aşımı'),
  invalidData('invalid_data', 'Geçersiz Veri'),
  unknown('unknown', 'Bilinmeyen Hata');

  const NotificationErrorType(this.value, this.displayName);
  final String value;
  final String displayName;
}

// Settings States
class SettingsLoaded extends NotificationState {
  final NotificationSettingsEntity settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsUpdated extends NotificationState {
  final NotificationSettingsEntity settings;

  const SettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}