import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notifications;
import 'package:flutter/material.dart';

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  late FirebaseMessaging _firebaseMessaging;
  late local_notifications.FlutterLocalNotificationsPlugin _localNotifications;
  bool _isInitialized = false;

  factory PushNotificationService() {
    return _instance;
  }

  PushNotificationService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase Messaging
      _firebaseMessaging = FirebaseMessaging.instance;

      // Initialize Local Notifications
      _localNotifications = local_notifications.FlutterLocalNotificationsPlugin();

      // Configure notification channels
      await _createNotificationChannels();

      // Configure Firebase Messaging
      await _configureFirebaseMessaging();

      // Set up notification handlers
      await _setupNotificationHandlers();

      _isInitialized = true;
      debugPrint('Push notification service initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize push notification service: $e');
      rethrow;
    }
  }

  Future<void> _createNotificationChannels() async {
    // Android notification channels
    const androidChannel = local_notifications.AndroidNotificationChannel(
      'barter_channel', // id
      'Barter Notifications', // title
      description: 'Notifications for barter offers and messages', // description
      importance: local_notifications.Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    // iOS notification categories
    const iosCategories = [
      local_notifications.DarwinNotificationCategory(
        'barter_offer',
        actions: [
          local_notifications.DarwinNotificationAction.plain('accept', 'Kabul Et'),
          local_notifications.DarwinNotificationAction.plain('reject', 'Reddet'),
        ],
      ),
      local_notifications.DarwinNotificationCategory(
        'barter_message',
        actions: [
          local_notifications.DarwinNotificationAction.plain('reply', 'Cevapla'),
        ],
      ),
    ];

    // Initialize local notifications
    const initializationSettingsAndroid = local_notifications.AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = local_notifications.DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      notificationCategories: iosCategories,
    );
    const initializationSettings = local_notifications.InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<local_notifications.AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> _configureFirebaseMessaging() async {
    // Set foreground notification presentation options
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get initial message if app was opened from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  Future<void> _setupNotificationHandlers() async {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        _showLocalNotification(message);
      }
    });

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Message opened app handler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      _handleMessage(message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null) return;

    final androidDetails = local_notifications.AndroidNotificationDetails(
      'barter_channel',
      'Barter Notifications',
      channelDescription: 'Notifications for barter offers and messages',
      importance: local_notifications.Importance.max,
      priority: local_notifications.Priority.high,
      ticker: 'ticker',
      icon: android?.smallIcon,
      color: const Color(0xFF2563EB), // App primary color
      styleInformation: android?.styleInformation,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: _getNotificationCategory(message),
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  String _getNotificationCategory(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];

    switch (type) {
      case 'barter_offer':
        return 'barter_offer';
      case 'barter_message':
        return 'barter_message';
      default:
        return 'default';
    }
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('Handling message: ${message.messageId}');
    debugPrint('Message data: ${message.data}');

    // Navigate to appropriate screen based on message type
    final data = message.data;
    final type = data['type'];
    final targetId = data['targetId'];

    // TODO: Navigate to appropriate screen based on notification type
    // This would typically be handled by a navigation service or BLoC
  }

  Future<String?> getDeviceToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Failed to get device token: $e');
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Failed to subscribe to topic $topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Failed to unsubscribe from topic $topic: $e');
    }
  }

  Future<List<String>> getSubscribedTopics() async {
    // Firebase doesn't provide a way to get subscribed topics
    // This would need to be tracked locally or via backend
    return [];
  }

  Future<bool> requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<bool> isPermissionGranted() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  void dispose() {
    _isInitialized = false;
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint("Handling a background message: ${message.messageId}");

  // Handle background message
  final pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  // For now, just log the message
  debugPrint('Background message: ${message.data}');
}

// Local notification handlers
void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
  debugPrint('Local notification received: $id, $title, $body, $payload');
}

void _onDidReceiveNotificationResponse(NotificationResponse response) {
  debugPrint('Notification response received: ${response.actionId}, ${response.payload}');

  // Handle notification tap
  final payload = response.payload;
  if (payload != null) {
    debugPrint('Notification payload: $payload');
    // TODO: Navigate to appropriate screen based on payload
  }
}
