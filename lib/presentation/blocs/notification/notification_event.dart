import 'package:equatable/equatable.dart';
import '../../../domain/repositories/notification_repository.dart';
import '../../../domain/entities/notification_settings.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

// Basic Events
class GetNotificationsRequested extends NotificationEvent {
  final NotificationFilter? filter;
  final int page;
  final int limit;

  const GetNotificationsRequested({
    this.filter,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [filter, page, limit];
}

class GetNotificationByIdRequested extends NotificationEvent {
  final String notificationId;

  const GetNotificationByIdRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAsReadRequested extends NotificationEvent {
  final String notificationId;

  const MarkAsReadRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllAsReadRequested extends NotificationEvent {}

class DeleteNotificationRequested extends NotificationEvent {
  final String notificationId;

  const DeleteNotificationRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class DeleteAllNotificationsRequested extends NotificationEvent {}

// Settings Events
class GetNotificationSettingsRequested extends NotificationEvent {
  final String userId;

  const GetNotificationSettingsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateNotificationSettingsRequested extends NotificationEvent {
  final String userId;
  final NotificationSettingsEntity settings;

  const UpdateNotificationSettingsRequested(this.userId, this.settings);

  @override
  List<Object?> get props => [userId, settings];
}

class ToggleNotificationChannelRequested extends NotificationEvent {
  final NotificationChannel channel;
  final bool enabled;

  const ToggleNotificationChannelRequested(this.channel, this.enabled);

  @override
  List<Object?> get props => [channel, enabled];
}

// Analytics Events
class GetNotificationStatsRequested extends NotificationEvent {}

// Search Events
class SearchNotificationsRequested extends NotificationEvent {
  final SearchNotificationsRequest request;

  const SearchNotificationsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// Push Token Events
class UpdatePushTokenRequested extends NotificationEvent {
  final String token;

  const UpdatePushTokenRequested(this.token);

  @override
  List<Object?> get props => [token];
}

class RemovePushTokenRequested extends NotificationEvent {}

// Action Events
class PerformNotificationActionRequested extends NotificationEvent {
  final String notificationId;
  final NotificationAction action;

  const PerformNotificationActionRequested(this.notificationId, this.action);

  @override
  List<Object?> get props => [notificationId, action];
}

// Local Notification Events
class ScheduleLocalNotificationRequested extends NotificationEvent {
  final ScheduledNotificationRequest request;

  const ScheduleLocalNotificationRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class CancelScheduledNotificationRequested extends NotificationEvent {
  final String notificationId;

  const CancelScheduledNotificationRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

// Bulk Operations
class MarkMultipleAsReadRequested extends NotificationEvent {
  final List<String> notificationIds;

  const MarkMultipleAsReadRequested(this.notificationIds);

  @override
  List<Object?> get props => [notificationIds];
}

class DeleteMultipleNotificationsRequested extends NotificationEvent {
  final List<String> notificationIds;

  const DeleteMultipleNotificationsRequested(this.notificationIds);

  @override
  List<Object?> get props => [notificationIds];
}

// UI Events
class RefreshNotificationsRequested extends NotificationEvent {}

class LoadMoreNotificationsRequested extends NotificationEvent {
  final NotificationFilter? filter;

  const LoadMoreNotificationsRequested({this.filter});

  @override
  List<Object?> get props => [filter];
}

class ClearNotificationCacheRequested extends NotificationEvent {}

class NotificationReceived extends NotificationEvent {
  final NotificationEntity notification;
  final bool fromBackground;

  const NotificationReceived(this.notification, {this.fromBackground = false});

  @override
  List<Object?> get props => [notification, fromBackground];
}
