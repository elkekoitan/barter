import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Core
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/network/interceptors/logging_interceptor.dart';
import 'core/network/interceptors/error_interceptor.dart';

// Data sources
import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/local/notification_local_datasource.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/datasources/remote/user_remote_datasource.dart';
import 'data/datasources/remote/listing_remote_datasource.dart';
import 'data/datasources/remote/barter_remote_datasource.dart';
import 'data/datasources/remote/payment_remote_datasource.dart';
import 'data/datasources/remote/notification_remote_datasource.dart';
import 'data/datasources/remote/push_notification_remote_datasource.dart';
import 'data/datasources/remote/map_remote_datasource.dart';

// Repositories (implementations)
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/listing_repository_impl.dart';
import 'data/repositories/barter_repository_impl.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'data/repositories/localization_repository_impl.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/map_repository_impl.dart';

// Domain repositories (contracts)
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/listing_repository.dart';
import 'domain/repositories/barter_repository.dart';
import 'domain/repositories/payment_repository.dart';
import 'domain/repositories/localization_repository.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/repositories/map_repository.dart';

// Usecases
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/register_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/auth/verify_otp_usecase.dart';

import 'domain/usecases/listing/create_listing_usecase.dart';
import 'domain/usecases/listing/get_listings_usecase.dart';
import 'domain/usecases/listing/update_listing_usecase.dart';
import 'domain/usecases/listing/delete_listing_usecase.dart';

import 'domain/usecases/barter/create_offer_usecase.dart';
import 'domain/usecases/barter/accept_offer_usecase.dart';
import 'domain/usecases/barter/get_offers_usecase.dart';
import 'domain/usecases/barter/create_transaction_usecase.dart';

import 'domain/usecases/payment/process_payment_usecase.dart';

import 'domain/usecases/notification/get_notifications_usecase.dart';
import 'domain/usecases/notification/mark_as_read_usecase.dart';
import 'domain/usecases/notification/mark_all_as_read_usecase.dart';
import 'domain/usecases/notification/update_notification_settings_usecase.dart';

import 'domain/usecases/localization/get_localized_string_usecase.dart';

import 'domain/usecases/chat/get_chats_usecase.dart';
import 'domain/usecases/chat/send_message_usecase.dart';
import 'domain/usecases/chat/create_chat_usecase.dart';

// BLoCs
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/listing/listing_bloc.dart';
import 'presentation/blocs/barter/barter_bloc.dart';
import 'presentation/blocs/payment/payment_bloc.dart';
import 'presentation/blocs/notification/notification_bloc.dart';
import 'presentation/blocs/localization/localization_bloc.dart';
import 'presentation/blocs/chat/chat_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Async singletons
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt<Connectivity>()));

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.bogazicibarter.com/v1'),
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      ),
    );
    dio.interceptors.addAll([
          AuthInterceptor(getIt<FlutterSecureStorage>()),
          LoggingInterceptor(),
          ErrorInterceptor(),
        ]);
    return dio;
  });

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  // Notifications (optional, used by push data source)
  getIt.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<FlutterSecureStorage>(), getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<ListingRemoteDataSource>(
    () => ListingRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<BarterRemoteDataSource>(
    () => BarterRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSource(),
  );
  getIt.registerLazySingleton<PushNotificationRemoteDataSource>(
    () => PushNotificationRemoteDataSourceImpl(
        firebaseMessaging: getIt<FirebaseMessaging>(),
        localNotifications: getIt<FlutterLocalNotificationsPlugin>(),
    ),
      );
  getIt.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(googleMapsApiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: '')), 
      );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<ApiClient>(),
      getIt<AuthLocalDataSource>(),
      getIt<AuthRemoteDataSource>(),
      getIt<FlutterSecureStorage>(),
      getIt<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<ListingRepository>(
    () => ListingRepositoryImpl(getIt<ListingRemoteDataSource>(), getIt<NetworkInfo>()),
  );
  getIt.registerLazySingleton<BarterRepository>(
    () => BarterRepositoryImpl(getIt<BarterRemoteDataSource>(), getIt<NetworkInfo>()),
  );
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(getIt<ApiClient>(), getIt<PaymentRemoteDataSource>()),
  );
  getIt.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
          getIt<NotificationLocalDataSource>(),
          getIt<NotificationRemoteDataSource>(),
      getIt<PushNotificationRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(getIt<MapRemoteDataSource>()),
  );

  // Usecases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>(), getIt<NetworkInfo>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>(), getIt<NetworkInfo>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(getIt<AuthRepository>(), getIt<NetworkInfo>()),
  );

  getIt.registerLazySingleton<CreateListingUseCase>(
    () => CreateListingUseCase(getIt<ListingRepository>()),
  );
  getIt.registerLazySingleton<GetListingsUseCase>(
    () => GetListingsUseCase(getIt<ListingRepository>()),
  );
  getIt.registerLazySingleton<UpdateListingUseCase>(
    () => UpdateListingUseCase(getIt<ListingRepository>()),
  );
  getIt.registerLazySingleton<DeleteListingUseCase>(
    () => DeleteListingUseCase(getIt<ListingRepository>()),
  );

  getIt.registerLazySingleton<CreateOfferUseCase>(
    () => CreateOfferUseCase(getIt<BarterRepository>()),
  );
  getIt.registerLazySingleton<AcceptOfferUseCase>(
    () => AcceptOfferUseCase(getIt<BarterRepository>()),
  );
  getIt.registerLazySingleton<GetOffersUseCase>(
    () => GetOffersUseCase(getIt<BarterRepository>()),
  );
  getIt.registerLazySingleton<CreateTransactionUseCase>(
    () => CreateTransactionUseCase(getIt<BarterRepository>()),
  );

  getIt.registerLazySingleton<ProcessPaymentUsecase>(
    () => ProcessPaymentUsecase(getIt<PaymentRepository>()),
  );

  getIt.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<MarkAsReadUseCase>(
    () => MarkAsReadUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<MarkAllAsReadUseCase>(
    () => MarkAllAsReadUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<UpdateNotificationSettingsUseCase>(
    () => UpdateNotificationSettingsUseCase(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<GetLocalizedStringUseCase>(
    () => GetLocalizedStringUseCase(getIt<LocalizationRepository>()),
  );
}

class InjectionContainer {
  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          loginUseCase: getIt<LoginUseCase>(),
          registerUseCase: getIt<RegisterUseCase>(),
          logoutUseCase: getIt<LogoutUseCase>(),
          verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
          authRepository: getIt<AuthRepository>(),
        ),
      ),
      BlocProvider<ListingBloc>(
        create: (context) => ListingBloc(
          createListingUseCase: getIt<CreateListingUseCase>(),
          getListingsUseCase: getIt<GetListingsUseCase>(),
          updateListingUseCase: getIt<UpdateListingUseCase>(),
          deleteListingUseCase: getIt<DeleteListingUseCase>(),
          listingRepository: getIt<ListingRepository>(),
        ),
      ),
      BlocProvider<BarterBloc>(
        create: (context) => BarterBloc(
          createOfferUseCase: getIt<CreateOfferUseCase>(),
          acceptOfferUseCase: getIt<AcceptOfferUseCase>(),
          getOffersUseCase: getIt<GetOffersUseCase>(),
          createTransactionUseCase: getIt<CreateTransactionUseCase>(),
          barterRepository: getIt<BarterRepository>(),
        ),
      ),
      BlocProvider<PaymentBloc>(
        create: (context) => PaymentBloc(
          processPaymentUsecase: getIt<ProcessPaymentUsecase>(),
        ),
      ),
      BlocProvider<NotificationBloc>(
        create: (context) => NotificationBloc(
          getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
          markAsReadUseCase: getIt<MarkAsReadUseCase>(),
          markAllAsReadUseCase: getIt<MarkAllAsReadUseCase>(),
          updateNotificationSettingsUseCase: getIt<UpdateNotificationSettingsUseCase>(),
          notificationRepository: getIt<NotificationRepository>(),
        ),
      ),
      BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          getChatsUseCase: getIt<GetChatsUseCase>(),
          sendMessageUseCase: getIt<SendMessageUseCase>(),
          createChatUseCase: getIt<CreateChatUseCase>(),
          chatRepository: getIt<ChatRepository>(),
        ),
      ),
      BlocProvider<LocalizationBloc>(
        create: (context) => LocalizationBloc(
          repository: getIt<LocalizationRepository>(),
          getLocalizedStringUseCase: getIt<GetLocalizedStringUseCase>(),
        ),
      ),
    ];
  }
}
