import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../domain/entities/notification.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications(String userId);
  Future<NotificationEntity> getNotificationById(String notificationId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<NotificationSettingsEntity> getNotificationSettings(String userId);
  Future<NotificationSettingsEntity> updateNotificationSettings(String userId, NotificationSettingsEntity settings);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/notifications', queryParameters: {'userId': userId});
    if (response.statusCode == 200) {
      final List notifications = response.data!['data'];
      return notifications.map((notification) => _mapToEntity(notification)).toList();
    }
    throw Exception('Failed to get notifications');
  }

  @override
  Future<NotificationEntity> getNotificationById(String notificationId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/notifications/$notificationId');
    if (response.statusCode == 200) {
      return _mapToEntity(response.data!['data']);
    }
    throw Exception('Failed to get notification');
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final response = await _apiClient.patch('/notifications/$notificationId/read');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to mark notification as read');
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final response = await _apiClient.patch('/notifications/mark-all-read', data: {'userId': userId});
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to mark all notifications as read');
    }
  }

  @override
  Future<NotificationSettingsEntity> getNotificationSettings(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/notifications/settings/$userId');
    if (response.statusCode == 200) {
      return _mapSettingsToEntity(response.data!['data']);
    }
    throw Exception('Failed to get notification settings');
  }

  @override
  Future<NotificationSettingsEntity> updateNotificationSettings(String userId, NotificationSettingsEntity settings) async {
    final response = await _apiClient.patch<Map<String, dynamic>>('/notifications/settings/$userId', data: _mapSettingsFromEntity(settings));
    if (response.statusCode == 200) {
      return _mapSettingsToEntity(response.data!['data']);
    }
    throw Exception('Failed to update notification settings');
  }

  NotificationEntity _mapToEntity(Map<String, dynamic> data) {
    return NotificationEntity(
      id: data['id'],
      userId: data['userId'],
      type: data['type'],
      title: data['title'],
      message: data['message'],
      data: Map<String, dynamic>.from(data['data'] ?? {}),
      isRead: data['isRead'] ?? false,
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  NotificationSettingsEntity _mapSettingsToEntity(Map<String, dynamic> data) {
    return NotificationSettingsEntity(
      userId: data['userId'],
      pushNotifications: data['pushNotifications'] ?? true,
      emailNotifications: data['emailNotifications'] ?? true,
      barterOffers: data['barterOffers'] ?? true,
      newMessages: data['newMessages'] ?? true,
      systemUpdates: data['systemUpdates'] ?? true,
      marketingEmails: data['marketingEmails'] ?? false,
    );
  }

  Map<String, dynamic> _mapSettingsFromEntity(NotificationSettingsEntity settings) {
    return {
      'pushNotifications': settings.pushNotifications,
      'emailNotifications': settings.emailNotifications,
      'barterOffers': settings.barterOffers,
      'newMessages': settings.newMessages,
      'systemUpdates': settings.systemUpdates,
      'marketingEmails': settings.marketingEmails,
    };
  }
}
