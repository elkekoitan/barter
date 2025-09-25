import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../../domain/usecases/notification/mark_as_read_usecase.dart';
import '../../../domain/usecases/notification/mark_all_as_read_usecase.dart';
import '../../../domain/usecases/notification/update_notification_settings_usecase.dart';
import '../../../domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;
  final UpdateNotificationSettingsUseCase _updateNotificationSettingsUseCase;
  final NotificationRepository _notificationRepository;

  NotificationBloc({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkAsReadUseCase markAsReadUseCase,
    required MarkAllAsReadUseCase markAllAsReadUseCase,
    required UpdateNotificationSettingsUseCase updateNotificationSettingsUseCase,
    required NotificationRepository notificationRepository,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markAsReadUseCase = markAsReadUseCase,
        _markAllAsReadUseCase = markAllAsReadUseCase,
        _updateNotificationSettingsUseCase = updateNotificationSettingsUseCase,
        _notificationRepository = notificationRepository,
        super(NotificationInitial()) {
    on<GetNotificationsRequested>(_onGetNotificationsRequested);
    on<GetNotificationByIdRequested>(_onGetNotificationByIdRequested);
    on<MarkAsReadRequested>(_onMarkAsReadRequested);
    on<MarkAllAsReadRequested>(_onMarkAllAsReadRequested);
    on<DeleteNotificationRequested>(_onDeleteNotificationRequested);
    on<DeleteAllNotificationsRequested>(_onDeleteAllNotificationsRequested);
    on<GetNotificationSettingsRequested>(_onGetNotificationSettingsRequested);
    on<UpdateNotificationSettingsRequested>(_onUpdateNotificationSettingsRequested);
    on<GetNotificationStatsRequested>(_onGetNotificationStatsRequested);
    on<SearchNotificationsRequested>(_onSearchNotificationsRequested);
    on<UpdatePushTokenRequested>(_onUpdatePushTokenRequested);
    on<RemovePushTokenRequested>(_onRemovePushTokenRequested);
    on<PerformNotificationActionRequested>(_onPerformNotificationActionRequested);
    on<ScheduleLocalNotificationRequested>(_onScheduleLocalNotificationRequested);
    on<CancelScheduledNotificationRequested>(_onCancelScheduledNotificationRequested);
    on<MarkMultipleAsReadRequested>(_onMarkMultipleAsReadRequested);
    on<DeleteMultipleNotificationsRequested>(_onDeleteMultipleNotificationsRequested);
    on<RefreshNotificationsRequested>(_onRefreshNotificationsRequested);
    on<LoadMoreNotificationsRequested>(_onLoadMoreNotificationsRequested);
    on<ClearNotificationCacheRequested>(_onClearNotificationCacheRequested);
    on<NotificationReceived>(_onNotificationReceived);
  }

  Future<void> _onGetNotificationsRequested(
    GetNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationsLoading());

    final result = await _getNotificationsUseCase.call(
      filter: event.filter,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationsLoaded(
        notifications: notifications,
        currentPage: event.page,
        hasMore: notifications.length == event.limit,
        totalCount: notifications.length,
      )),
    );
  }

  Future<void> _onGetNotificationByIdRequested(
    GetNotificationByIdRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    final result = await _notificationRepository.getNotificationById(event.notificationId);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notification) => emit(NotificationLoaded(notification)),
    );
  }

  Future<void> _onMarkAsReadRequested(
    MarkAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _markAsReadUseCase.call(event.notificationId);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notification) => emit(NotificationMarkedAsRead(notification)),
    );
  }

  Future<void> _onMarkAllAsReadRequested(
    MarkAllAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _markAllAsReadUseCase.call();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(AllNotificationsMarkedAsRead()),
    );
  }

  Future<void> _onDeleteNotificationRequested(
    DeleteNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    final result = await _notificationRepository.deleteNotification(event.notificationId);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(NotificationDeleted(event.notificationId)),
    );
  }

  Future<void> _onDeleteAllNotificationsRequested(
    DeleteAllNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    final result = await _notificationRepository.deleteAllNotifications();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(AllNotificationsDeleted()),
    );
  }

  Future<void> _onGetNotificationSettingsRequested(
    GetNotificationSettingsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(SettingsLoading());

    final result = await _notificationRepository.getNotificationSettings();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateNotificationSettingsRequested(
    UpdateNotificationSettingsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(SettingsLoading());

    final result = await _updateNotificationSettingsUseCase.call(event.request);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (settings) => emit(SettingsUpdated(settings)),
    );
  }

  Future<void> _onGetNotificationStatsRequested(
    GetNotificationStatsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    final result = await _notificationRepository.getNotificationStats();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (stats) => emit(NotificationStatsLoaded(stats)),
    );
  }

  Future<void> _onSearchNotificationsRequested(
    SearchNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationsLoading());

    final result = await _notificationRepository.searchNotifications(event.request);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationsSearched(notifications, event.request.query)),
    );
  }

  Future<void> _onUpdatePushTokenRequested(
    UpdatePushTokenRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _notificationRepository.updatePushToken(event.token);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(PushTokenUpdated()),
    );
  }

  Future<void> _onRemovePushTokenRequested(
    RemovePushTokenRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _notificationRepository.removePushToken();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(PushTokenRemoved()),
    );
  }

  Future<void> _onPerformNotificationActionRequested(
    PerformNotificationActionRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _notificationRepository.performNotificationAction(event.notificationId, event.action);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (success) {
        if (success) {
          // Action performed successfully
          debugPrint('Notification action performed: ${event.action.value}');
        } else {
          emit(NotificationError('Failed to perform notification action'));
        }
      },
    );
  }

  Future<void> _onScheduleLocalNotificationRequested(
    ScheduleLocalNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _notificationRepository.scheduleLocalNotification(event.request);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(LocalNotificationScheduled(event.request.id)),
    );
  }

  Future<void> _onCancelScheduledNotificationRequested(
    CancelScheduledNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _notificationRepository.cancelScheduledNotification(event.notificationId);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(LocalNotificationCancelled(event.notificationId)),
    );
  }

  Future<void> _onMarkMultipleAsReadRequested(
    MarkMultipleAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _notificationRepository.markMultipleAsRead(event.notificationIds);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(MultipleNotificationsMarkedAsRead(event.notificationIds)),
    );
  }

  Future<void> _onDeleteMultipleNotificationsRequested(
    DeleteMultipleNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _notificationRepository.deleteMultipleNotifications(event.notificationIds);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(MultipleNotificationsDeleted(event.notificationIds)),
    );
  }

  Future<void> _onRefreshNotificationsRequested(
    RefreshNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    // Refresh notifications by emitting initial state
    emit(NotificationInitial());
  }

  Future<void> _onLoadMoreNotificationsRequested(
    LoadMoreNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationsLoaded && currentState.hasMore) {
      emit(NotificationsLoading(isLoadMore: true));

      final result = await _getNotificationsUseCase.call(
        filter: event.filter,
        page: currentState.currentPage + 1,
        limit: 20,
      );

      result.fold(
        (failure) => emit(NotificationError(failure.message)),
        (notifications) => emit(NotificationsLoaded(
          notifications: [...currentState.notifications, ...notifications],
          currentPage: currentState.currentPage + 1,
          hasMore: notifications.length == 20,
          totalCount: currentState.totalCount + notifications.length,
        )),
      );
    }
  }

  Future<void> _onClearNotificationCacheRequested(
    ClearNotificationCacheRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationCacheCleared());
  }

  Future<void> _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) async {
    if (event.fromBackground) {
      // Handle background notification
      debugPrint('Notification received in background: ${event.notification.title}');
    } else {
      // Handle foreground notification
      emit(NotificationReceivedInForeground(event.notification));
    }
  }

  // Helper methods
  void handleNotificationTap(BuildContext context, NotificationEntity notification) {
    // Perform notification action
    if (notification.actionUrl != null) {
      add(PerformNotificationActionRequested(notification.id, notification.data.action!));
    }

    // Navigate based on notification type
    _navigateToNotificationTarget(context, notification);
  }

  void _navigateToNotificationTarget(BuildContext context, NotificationEntity notification) {
    // TODO: Implement navigation based on notification type
    debugPrint('Navigating to: ${notification.type.displayName}');
  }

  void updateUnreadCount() {
    // Get current unread count and emit it
    _notificationRepository.getUnreadCount().then((result) {
      result.fold(
        (failure) => debugPrint('Failed to get unread count: ${failure.message}'),
        (count) => add(UnreadCountLoaded(count) as NotificationEvent),
      );
    });
  }
}
