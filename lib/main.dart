import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/services/push_notification_service.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Determine environment and load appropriate environment variables
  const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  String envFileName = ".env";

  switch (environment) {
    case 'production':
      envFileName = "env.production";
      break;
    case 'staging':
      envFileName = "env.staging";
      break;
    default:
      envFileName = ".env"; // development
      break;
  }

  // Load environment variables
  await dotenv.load(fileName: envFileName);

  // Initialize Firebase with environment-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize push notifications
  await PushNotificationService().initialize();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr', 'TR'),
      child: const BogaziciBarterApp(),
    ),
  );
}
