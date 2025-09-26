import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/network/api_client.dart';
import 'core/services/push_notification_service.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/network/interceptors/logging_interceptor.dart';
import 'core/network/interceptors/error_interceptor.dart';
import 'core/network/network_info.dart';

import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/local/cache_manager.dart';
import 'data/datasources/local/notification_local_datasource.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/datasources/remote/user_remote_datasource.dart';
import 'data/datasources/remote/listing_remote_datasource.dart';
import 'data/datasources/remote/barter_remote_datasource.dart';
import 'data/datasources/remote/payment_remote_datasource.dart';
import 'data/datasources/remote/notification_remote_datasource.dart';
import 'data/datasources/remote/push_notification_remote_datasource.dart';
import 'data/datasources/remote/map_remote_datasource.dart';
import 'data/datasources/remote/help_remote_datasource.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/listing_repository_impl.dart';
import 'data/repositories/barter_repository_impl.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/map_repository_impl.dart';
import 'data/repositories/help_repository_impl.dart';

import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/listing_repository.dart';
import 'domain/repositories/barter_repository.dart';
import 'domain/repositories/payment_repository.dart';
import 'domain/repositories/localization_repository.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/repositories/map_repository.dart';
import 'domain/repositories/help_repository.dart';

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
import 'domain/usecases/barter/reject_offer_usecase.dart';
import 'domain/usecases/barter/complete_barter_usecase.dart';

import 'domain/usecases/payment/process_payment_usecase.dart';
import 'domain/usecases/payment/create_escrow_usecase.dart';
import 'domain/usecases/payment/release_escrow_usecase.dart';
import 'domain/usecases/payment/refund_payment_usecase.dart';

import 'domain/usecases/localization/get_localized_string_usecase.dart';

import 'domain/usecases/notification/get_notifications_usecase.dart';
import 'domain/usecases/notification/mark_as_read_usecase.dart';
import 'domain/usecases/notification/mark_all_as_read_usecase.dart';
import 'domain/usecases/notification/update_notification_settings_usecase.dart';

import 'domain/usecases/chat/get_chats_usecase.dart';
import 'domain/usecases/chat/send_message_usecase.dart';
import 'domain/usecases/chat/create_chat_usecase.dart';
import 'domain/usecases/map/map_usecases.dart';
import 'domain/usecases/help/help_usecases.dart';

import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/listing/listing_bloc.dart';
import 'presentation/blocs/barter/barter_bloc.dart';
import 'presentation/blocs/payment/payment_bloc.dart';
import 'presentation/blocs/localization/localization_bloc.dart';
import 'presentation/blocs/notification/notification_bloc.dart';
import 'presentation/blocs/chat/chat_bloc.dart';

part 'injection_container.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async {
  await getIt.init();
}

@module
abstract class RegisterModule {
  // Core
  @lazySingleton
  Dio get dio => Dio(BaseOptions(
        baseUrl: const String.fromEnvironment('API_BASE_URL',
            defaultValue: 'https://api.bogazicibarter.com/v1'),
        connectTimeout: const Duration(
            milliseconds:
                int.fromEnvironment('API_TIMEOUT', defaultValue: 30000)),
        receiveTimeout: const Duration(
            milliseconds:
                int.fromEnvironment('API_TIMEOUT', defaultValue: 30000)),
      ))
        ..interceptors.addAll([
          AuthInterceptor(getIt<FlutterSecureStorage>()),
          LoggingInterceptor(),
          ErrorInterceptor(),
        ]);

  @preResolve
  Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @lazySingleton
  FlutterLocalNotificationsPlugin get localNotificationsPlugin =>
      FlutterLocalNotificationsPlugin();

  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl(getIt<Connectivity>());

  // API Client
  @lazySingleton
  ApiClient get apiClient => ApiClient(getIt<Dio>());

  // Data Sources
  @lazySingleton
  AuthLocalDataSource get authLocalDataSource => AuthLocalDataSourceImpl(
      getIt<FlutterSecureStorage>(), getIt<SharedPreferences>());

  @lazySingleton
  AuthRemoteDataSource get authRemoteDataSource =>
      AuthRemoteDataSourceImpl(getIt<ApiClient>());

  @lazySingleton
  UserRemoteDataSource get userRemoteDataSource =>
      UserRemoteDataSourceImpl(getIt<ApiClient>());

  @lazySingleton
  ListingRemoteDataSource get listingRemoteDataSource =>
      ListingRemoteDataSourceImpl(getIt<ApiClient>());

  @lazySingleton
  BarterRemoteDataSource get barterRemoteDataSource =>
      BarterRemoteDataSourceImpl(getIt<ApiClient>());

  @lazySingleton
  PaymentRemoteDataSource get paymentRemoteDataSource =>
      PaymentRemoteDataSourceImpl(getIt<ApiClient>());

  @lazySingleton
  CacheManager get cacheManager => CacheManagerImpl(getIt<SharedPreferences>());

  @lazySingleton
  NotificationLocalDataSource get notificationLocalDataSource =>
      NotificationLocalDataSource();

  // Push Notification Data Sources
  @lazySingleton
  PushNotificationRemoteDataSource get pushNotificationRemoteDataSource =>
      PushNotificationRemoteDataSourceImpl(
        firebaseMessaging: getIt<FirebaseMessaging>(),
        localNotifications: getIt<FlutterLocalNotificationsPlugin>(),
      );

  // Map Data Sources
  @lazySingleton
  MapRemoteDataSource get mapRemoteDataSource => MapRemoteDataSourceImpl(
        googleMapsApiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY',
            defaultValue: 'YOUR_API_KEY'),
      );

  // Help Data Sources
  @lazySingleton
  HelpRemoteDataSource get helpRemoteDataSource => HelpRemoteDataSourceImpl(
        baseUrl: const String.fromEnvironment('API_BASE_URL',
            defaultValue: 'https://api.bogazicibarter.com/v1'),
      );

  // Repositories
  @lazySingleton
  AuthRepository get authRepository => AuthRepositoryImpl(
      getIt<ApiClient>(),
      getIt<AuthLocalDataSource>(),
      getIt<AuthRemoteDataSource>(),
      getIt<FlutterSecureStorage>(),
      getIt<SharedPreferences>());

  @lazySingleton
  UserRepository get userRepository => UserRepositoryImpl(
      getIt<UserRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
      getIt<NetworkInfo>());

  @lazySingleton
  ListingRepository get listingRepository => ListingRepositoryImpl(
      getIt<ListingRemoteDataSource>(), getIt<NetworkInfo>());

  @lazySingleton
  BarterRepository get barterRepository => BarterRepositoryImpl(
      getIt<BarterRemoteDataSource>(), getIt<NetworkInfo>());

  @lazySingleton
  PaymentRepository get paymentRepository => PaymentRepositoryImpl(
      getIt<ApiClient>(), getIt<PaymentRemoteDataSource>());

  @lazySingleton
  LocalizationRepository get localizationRepository =>
      LocalizationRepositoryImpl(getIt<SharedPreferences>());

  @lazySingleton
  NotificationRepository get notificationRepository =>
      NotificationRepositoryImpl(
          getIt<NotificationLocalDataSource>(),
          getIt<NotificationRemoteDataSource>(),
          getIt<PushNotificationRemoteDataSource>());

  @lazySingleton
  ChatRepository get chatRepository => ChatRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
      getIt<NetworkInfo>());

  @lazySingleton
  MapRepository get mapRepository =>
      MapRepositoryImpl(getIt<MapRemoteDataSource>());

  @lazySingleton
  HelpRepository get helpRepository =>
      HelpRepositoryImpl(getIt<HelpRemoteDataSource>());

  // Use Cases
  @lazySingleton
  LoginUseCase get loginUseCase =>
      LoginUseCase(getIt<AuthRepository>(), getIt<NetworkInfo>());

  @lazySingleton
  RegisterUseCase get registerUseCase =>
      RegisterUseCase(getIt<AuthRepository>(), getIt<NetworkInfo>());

  @lazySingleton
  LogoutUseCase get logoutUseCase => LogoutUseCase(getIt<AuthRepository>());

  @lazySingleton
  VerifyOtpUseCase get verifyOtpUseCase =>
      VerifyOtpUseCase(getIt<AuthRepository>(), getIt<NetworkInfo>());

  @lazySingleton
  CreateListingUseCase get createListingUseCase =>
      CreateListingUseCase(getIt<ListingRepository>());

  @lazySingleton
  GetListingsUseCase get getListingsUseCase =>
      GetListingsUseCase(getIt<ListingRepository>());

  @lazySingleton
  UpdateListingUseCase get updateListingUseCase =>
      UpdateListingUseCase(getIt<ListingRepository>());

  @lazySingleton
  DeleteListingUseCase get deleteListingUseCase =>
      DeleteListingUseCase(getIt<ListingRepository>());

  @lazySingleton
  CreateOfferUseCase get createOfferUseCase =>
      CreateOfferUseCase(getIt<BarterRepository>());

  @lazySingleton
  AcceptOfferUseCase get acceptOfferUseCase =>
      AcceptOfferUseCase(getIt<BarterRepository>());

  @lazySingleton
  RejectOfferUseCase get rejectOfferUseCase =>
      RejectOfferUseCase(getIt<BarterRepository>());

  @lazySingleton
  CompleteBarterUseCase get completeBarterUseCase =>
      CompleteBarterUseCase(getIt<BarterRepository>());

  @lazySingleton
  ProcessPaymentUsecase get processPaymentUsecase =>
      ProcessPaymentUsecase(getIt<PaymentRepository>());

  @lazySingleton
  CreateEscrowUseCase get createEscrowUseCase =>
      CreateEscrowUseCase(getIt<PaymentRepository>());

  @lazySingleton
  ReleaseEscrowUseCase get releaseEscrowUseCase =>
      ReleaseEscrowUseCase(getIt<PaymentRepository>());

  @lazySingleton
  RefundPaymentUseCase get refundPaymentUseCase =>
      RefundPaymentUseCase(getIt<PaymentRepository>());

  @lazySingleton
  GetLocalizedStringUseCase get getLocalizedStringUseCase =>
      GetLocalizedStringUseCase(getIt<LocalizationRepository>());

  @lazySingleton
  GetNotificationsUseCase get getNotificationsUseCase =>
      GetNotificationsUseCase(getIt<NotificationRepository>());

  @lazySingleton
  MarkAsReadUseCase get markAsReadUseCase =>
      MarkAsReadUseCase(getIt<NotificationRepository>());

  @lazySingleton
  MarkAllAsReadUseCase get markAllAsReadUseCase =>
      MarkAllAsReadUseCase(getIt<NotificationRepository>());

  @lazySingleton
  UpdateNotificationSettingsUseCase get updateNotificationSettingsUseCase =>
      UpdateNotificationSettingsUseCase(getIt<NotificationRepository>());

  // Push Notification Use Cases
  @lazySingleton
  RequestNotificationPermissionUseCase
      get requestNotificationPermissionUseCase =>
          RequestNotificationPermissionUseCase(getIt<NotificationRepository>());

  @lazySingleton
  CheckNotificationPermissionUseCase get checkNotificationPermissionUseCase =>
      CheckNotificationPermissionUseCase(getIt<NotificationRepository>());

  @lazySingleton
  GetDeviceTokenUseCase get getDeviceTokenUseCase =>
      GetDeviceTokenUseCase(getIt<NotificationRepository>());

  @lazySingleton
  SubscribeToTopicUseCase get subscribeToTopicUseCase =>
      SubscribeToTopicUseCase(getIt<NotificationRepository>());

  @lazySingleton
  UnsubscribeFromTopicUseCase get unsubscribeFromTopicUseCase =>
      UnsubscribeFromTopicUseCase(getIt<NotificationRepository>());

  @lazySingleton
  SendPushNotificationUseCase get sendPushNotificationUseCase =>
      SendPushNotificationUseCase(getIt<NotificationRepository>());

  @lazySingleton
  SchedulePushNotificationUseCase get schedulePushNotificationUseCase =>
      SchedulePushNotificationUseCase(getIt<NotificationRepository>());

  @lazySingleton
  CancelScheduledPushNotificationUseCase
      get cancelScheduledPushNotificationUseCase =>
          CancelScheduledPushNotificationUseCase(
              getIt<NotificationRepository>());

  @lazySingleton
  GetSubscribedTopicsUseCase get getSubscribedTopicsUseCase =>
      GetSubscribedTopicsUseCase(getIt<NotificationRepository>());

  @lazySingleton
  HandleBackgroundMessageUseCase get handleBackgroundMessageUseCase =>
      HandleBackgroundMessageUseCase(getIt<NotificationRepository>());

  @lazySingleton
  UpdatePushTokenUseCase get updatePushTokenUseCase =>
      UpdatePushTokenUseCase(getIt<NotificationRepository>());

  @lazySingleton
  RemovePushTokenUseCase get removePushTokenUseCase =>
      RemovePushTokenUseCase(getIt<NotificationRepository>());

  @lazySingleton
  InitializePushNotificationsUseCase get initializePushNotificationsUseCase =>
      InitializePushNotificationsUseCase(getIt<NotificationRepository>());

  // Map Use Cases
  @lazySingleton
  GetCurrentLocationUseCase get getCurrentLocationUseCase =>
      GetCurrentLocationUseCase(getIt<MapRepository>());

  @lazySingleton
  SearchPlacesUseCase get searchPlacesUseCase =>
      SearchPlacesUseCase(getIt<MapRepository>());

  @lazySingleton
  GetNearbyPlacesUseCase get getNearbyPlacesUseCase =>
      GetNearbyPlacesUseCase(getIt<MapRepository>());

  @lazySingleton
  GetRouteUseCase get getRouteUseCase =>
      GetRouteUseCase(getIt<MapRepository>());

  @lazySingleton
  CalculateDistanceUseCase get calculateDistanceUseCase =>
      CalculateDistanceUseCase(getIt<MapRepository>());

  @lazySingleton
  GeocodeAddressUseCase get geocodeAddressUseCase =>
      GeocodeAddressUseCase(getIt<MapRepository>());

  @lazySingleton
  ReverseGeocodeUseCase get reverseGeocodeUseCase =>
      ReverseGeocodeUseCase(getIt<MapRepository>());

  @lazySingleton
  SaveLocationUseCase get saveLocationUseCase =>
      SaveLocationUseCase(getIt<MapRepository>());

  @lazySingleton
  GetSavedLocationsUseCase get getSavedLocationsUseCase =>
      GetSavedLocationsUseCase(getIt<MapRepository>());

  @lazySingleton
  SearchMapUseCase get searchMapUseCase =>
      SearchMapUseCase(getIt<MapRepository>());

  @lazySingleton
  GetMapMarkersUseCase get getMapMarkersUseCase =>
      GetMapMarkersUseCase(getIt<MapRepository>());

  @lazySingleton
  UpdateUserLocationUseCase get updateUserLocationUseCase =>
      UpdateUserLocationUseCase(getIt<MapRepository>());

  @lazySingleton
  EnableLocationSharingUseCase get enableLocationSharingUseCase =>
      EnableLocationSharingUseCase(getIt<MapRepository>());

  @lazySingleton
  GetNearbyUsersUseCase get getNearbyUsersUseCase =>
      GetNearbyUsersUseCase(getIt<MapRepository>());

  @lazySingleton
  OpenInMapsUseCase get openInMapsUseCase =>
      OpenInMapsUseCase(getIt<MapRepository>());

  @lazySingleton
  GetMapDataUseCase get getMapDataUseCase =>
      GetMapDataUseCase(getIt<MapRepository>());

  @lazySingleton
  CheckLocationPermissionUseCase get checkLocationPermissionUseCase =>
      CheckLocationPermissionUseCase(getIt<MapRepository>());

  @lazySingleton
  RequestLocationPermissionUseCase get requestLocationPermissionUseCase =>
      RequestLocationPermissionUseCase(getIt<MapRepository>());

  // Help Use Cases
  @lazySingleton
  GetArticlesUseCase get getArticlesUseCase =>
      GetArticlesUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetArticleByIdUseCase get getArticleByIdUseCase =>
      GetArticleByIdUseCase(getIt<HelpRepository>());

  @lazySingleton
  CreateArticleUseCase get createArticleUseCase =>
      CreateArticleUseCase(getIt<HelpRepository>());

  @lazySingleton
  UpdateArticleUseCase get updateArticleUseCase =>
      UpdateArticleUseCase(getIt<HelpRepository>());

  @lazySingleton
  DeleteArticleUseCase get deleteArticleUseCase =>
      DeleteArticleUseCase(getIt<HelpRepository>());

  @lazySingleton
  SearchArticlesUseCase get searchArticlesUseCase =>
      SearchArticlesUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetCategoriesUseCase get getCategoriesUseCase =>
      GetCategoriesUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetCategoryByIdUseCase get getCategoryByIdUseCase =>
      GetCategoryByIdUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetSubcategoriesUseCase get getSubcategoriesUseCase =>
      GetSubcategoriesUseCase(getIt<HelpRepository>());

  @lazySingleton
  CreateCategoryUseCase get createCategoryUseCase =>
      CreateCategoryUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetFAQsUseCase get getFAQsUseCase => GetFAQsUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetPopularFAQsUseCase get getPopularFAQsUseCase =>
      GetPopularFAQsUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetPopularArticlesUseCase get getPopularArticlesUseCase =>
      GetPopularArticlesUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetRecentArticlesUseCase get getRecentArticlesUseCase =>
      GetRecentArticlesUseCase(getIt<HelpRepository>());

  @lazySingleton
  MarkArticleAsHelpfulUseCase get markArticleAsHelpfulUseCase =>
      MarkArticleAsHelpfulUseCase(getIt<HelpRepository>());

  @lazySingleton
  BookmarkArticleUseCase get bookmarkArticleUseCase =>
      BookmarkArticleUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetBookmarkedArticlesUseCase get getBookmarkedArticlesUseCase =>
      GetBookmarkedArticlesUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetSearchSuggestionsUseCase get getSearchSuggestionsUseCase =>
      GetSearchSuggestionsUseCase(getIt<HelpRepository>());

  @lazySingleton
  SaveSearchTermUseCase get saveSearchTermUseCase =>
      SaveSearchTermUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetRecentSearchesUseCase get getRecentSearchesUseCase =>
      GetRecentSearchesUseCase(getIt<HelpRepository>());

  @lazySingleton
  ClearSearchHistoryUseCase get clearSearchHistoryUseCase =>
      ClearSearchHistoryUseCase(getIt<HelpRepository>());

  @lazySingleton
  SubmitHelpFeedbackUseCase get submitHelpFeedbackUseCase =>
      SubmitHelpFeedbackUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetHelpStatsUseCase get getHelpStatsUseCase =>
      GetHelpStatsUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetRecommendedArticlesUseCase get getRecommendedArticlesUseCase =>
      GetRecommendedArticlesUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetRelatedArticlesUseCase get getRelatedArticlesUseCase =>
      GetRelatedArticlesUseCase(getIt<HelpRepository>());

  @lazySingleton
  IncrementArticleViewsUseCase get incrementArticleViewsUseCase =>
      IncrementArticleViewsUseCase(getIt<HelpRepository>());

  @lazySingleton
  PublishArticleUseCase get publishArticleUseCase =>
      PublishArticleUseCase(getIt<HelpRepository>());

  @lazySingleton
  UnpublishArticleUseCase get unpublishArticleUseCase =>
      UnpublishArticleUseCase(getIt<HelpRepository>());

  @lazySingleton
  ReorderCategoriesUseCase get reorderCategoriesUseCase =>
      ReorderCategoriesUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetArticlesByCategoryUseCase get getArticlesByCategoryUseCase =>
      GetArticlesByCategoryUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetArticlesByAuthorUseCase get getArticlesByAuthorUseCase =>
      GetArticlesByAuthorUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetUserHelpSettingsUseCase get getUserHelpSettingsUseCase =>
      GetUserHelpSettingsUseCase(getIt<HelpRepository>());

  @lazySingleton
  UpdateUserHelpSettingsUseCase get updateUserHelpSettingsUseCase =>
      UpdateUserHelpSettingsUseCase(getIt<HelpRepository>());

  @lazySingleton
  GetChatsUseCase get getChatsUseCase =>
      GetChatsUseCase(getIt<ChatRepository>());

  @lazySingleton
  SendMessageUseCase get sendMessageUseCase =>
      SendMessageUseCase(getIt<ChatRepository>());

  @lazySingleton
  CreateChatUseCase get createChatUseCase =>
      CreateChatUseCase(getIt<ChatRepository>());

  // BLoCs
  @lazySingleton
  AuthBloc get authBloc => AuthBloc(
        loginUseCase: getIt<LoginUseCase>(),
        registerUseCase: getIt<RegisterUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      );

  @lazySingleton
  ListingBloc get listingBloc => ListingBloc(
        createListingUseCase: getIt<CreateListingUseCase>(),
        getListingsUseCase: getIt<GetListingsUseCase>(),
        updateListingUseCase: getIt<UpdateListingUseCase>(),
        deleteListingUseCase: getIt<DeleteListingUseCase>(),
      );

  @lazySingleton
  BarterBloc get barterBloc => BarterBloc(
        createOfferUseCase: getIt<CreateOfferUseCase>(),
        acceptOfferUseCase: getIt<AcceptOfferUseCase>(),
        rejectOfferUseCase: getIt<RejectOfferUseCase>(),
        completeBarterUseCase: getIt<CompleteBarterUseCase>(),
      );

  @lazySingleton
  PaymentBloc get paymentBloc => PaymentBloc(
        processPaymentUsecase: getIt<ProcessPaymentUsecase>(),
      );

  @lazySingleton
  LocalizationBloc get localizationBloc => LocalizationBloc(
        repository: getIt<LocalizationRepository>(),
        getLocalizedStringUseCase: getIt<GetLocalizedStringUseCase>(),
      );

  @lazySingleton
  NotificationBloc get notificationBloc => NotificationBloc(
        getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
        markAsReadUseCase: getIt<MarkAsReadUseCase>(),
        markAllAsReadUseCase: getIt<MarkAllAsReadUseCase>(),
        updateNotificationSettingsUseCase:
            getIt<UpdateNotificationSettingsUseCase>(),
        notificationRepository: getIt<NotificationRepository>(),
      );

  @lazySingleton
  ChatBloc get chatBloc => ChatBloc(
        getChatsUseCase: getIt<GetChatsUseCase>(),
        sendMessageUseCase: getIt<SendMessageUseCase>(),
        createChatUseCase: getIt<CreateChatUseCase>(),
        chatRepository: getIt<ChatRepository>(),
      );
}
