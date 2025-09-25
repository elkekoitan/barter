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
        baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.bogazicibarter.com/v1'),
        connectTimeout: const Duration(milliseconds: int.fromEnvironment('API_TIMEOUT', defaultValue: 30000)),
        receiveTimeout: const Duration(milliseconds: int.fromEnvironment('API_TIMEOUT', defaultValue: 30000)),
      ))
    ..interceptors.addAll([
      AuthInterceptor(getIt()),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);

  @lazySingleton
  Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl(getIt());

  // API Client
  @lazySingleton
  ApiClient get apiClient => ApiClient(getIt());

  // Data Sources
  @lazySingleton
  AuthLocalDataSource get authLocalDataSource => AuthLocalDataSource(getIt(), getIt());

  @lazySingleton
  AuthRemoteDataSource get authRemoteDataSource => AuthRemoteDataSource(getIt());

  @lazySingleton
  UserRemoteDataSource get userRemoteDataSource => UserRemoteDataSource(getIt());

  @lazySingleton
  ListingRemoteDataSource get listingRemoteDataSource => ListingRemoteDataSource(getIt());

  @lazySingleton
  BarterRemoteDataSource get barterRemoteDataSource => BarterRemoteDataSource(getIt());

  @lazySingleton
  PaymentRemoteDataSource get paymentRemoteDataSource => PaymentRemoteDataSource(getIt());

      @lazySingleton
      CacheManager get cacheManager => CacheManager(getIt());

      // Push Notification Data Sources
      @lazySingleton
      PushNotificationRemoteDataSource get pushNotificationRemoteDataSource =>
          PushNotificationRemoteDataSourceImpl(
            firebaseMessaging: getIt(),
            localNotifications: getIt(),
          );

      // Map Data Sources
      @lazySingleton
      MapRemoteDataSource get mapRemoteDataSource => MapRemoteDataSourceImpl(
        googleMapsApiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: 'YOUR_API_KEY'),
      );

      // Help Data Sources
      @lazySingleton
      HelpRemoteDataSource get helpRemoteDataSource => HelpRemoteDataSourceImpl(
        baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.bogazicibarter.com/v1'),
      );

  // Repositories
  @lazySingleton
  AuthRepository get authRepository => AuthRepositoryImpl(getIt(), getIt(), getIt());

  @lazySingleton
  UserRepository get userRepository => UserRepositoryImpl(getIt(), getIt());

  @lazySingleton
  ListingRepository get listingRepository => ListingRepositoryImpl(getIt(), getIt());

  @lazySingleton
  BarterRepository get barterRepository => BarterRepositoryImpl(getIt(), getIt());

  @lazySingleton
  PaymentRepository get paymentRepository => PaymentRepositoryImpl(getIt(), getIt());

      @lazySingleton
      LocalizationRepository get localizationRepository => LocalizationRepositoryImpl(getIt());

      @lazySingleton
      NotificationRepository get notificationRepository => NotificationRepositoryImpl(getIt(), getIt(), getIt());

      @lazySingleton
      ChatRepository get chatRepository => ChatRepositoryImpl(getIt(), getIt());

      @lazySingleton
      MapRepository get mapRepository => MapRepositoryImpl(getIt());

      @lazySingleton
      HelpRepository get helpRepository => HelpRepositoryImpl(getIt());

  // Use Cases
  @lazySingleton
  LoginUseCase get loginUseCase => LoginUseCase(getIt());

  @lazySingleton
  RegisterUseCase get registerUseCase => RegisterUseCase(getIt());

  @lazySingleton
  LogoutUseCase get logoutUseCase => LogoutUseCase(getIt());

  @lazySingleton
  VerifyOtpUseCase get verifyOtpUseCase => VerifyOtpUseCase(getIt());

  @lazySingleton
  CreateListingUseCase get createListingUseCase => CreateListingUseCase(getIt());

  @lazySingleton
  GetListingsUseCase get getListingsUseCase => GetListingsUseCase(getIt());

  @lazySingleton
  UpdateListingUseCase get updateListingUseCase => UpdateListingUseCase(getIt());

  @lazySingleton
  DeleteListingUseCase get deleteListingUseCase => DeleteListingUseCase(getIt());

  @lazySingleton
  CreateOfferUseCase get createOfferUseCase => CreateOfferUseCase(getIt());

  @lazySingleton
  AcceptOfferUseCase get acceptOfferUseCase => AcceptOfferUseCase(getIt());

  @lazySingleton
  RejectOfferUseCase get rejectOfferUseCase => RejectOfferUseCase(getIt());

  @lazySingleton
  CompleteBarterUseCase get completeBarterUseCase => CompleteBarterUseCase(getIt());

  @lazySingleton
  ProcessPaymentUseCase get processPaymentUseCase => ProcessPaymentUseCase(getIt());

  @lazySingleton
  CreateEscrowUseCase get createEscrowUseCase => CreateEscrowUseCase(getIt());

  @lazySingleton
  ReleaseEscrowUseCase get releaseEscrowUseCase => ReleaseEscrowUseCase(getIt());

  @lazySingleton
  RefundPaymentUseCase get refundPaymentUseCase => RefundPaymentUseCase(getIt());

      @lazySingleton
      GetLocalizedStringUseCase get getLocalizedStringUseCase => GetLocalizedStringUseCase(getIt());

      @lazySingleton
      GetNotificationsUseCase get getNotificationsUseCase => GetNotificationsUseCase(getIt());

      @lazySingleton
      MarkAsReadUseCase get markAsReadUseCase => MarkAsReadUseCase(getIt());

      @lazySingleton
      MarkAllAsReadUseCase get markAllAsReadUseCase => MarkAllAsReadUseCase(getIt());

      @lazySingleton
      UpdateNotificationSettingsUseCase get updateNotificationSettingsUseCase => UpdateNotificationSettingsUseCase(getIt());

      // Push Notification Use Cases
      @lazySingleton
      RequestNotificationPermissionUseCase get requestNotificationPermissionUseCase => RequestNotificationPermissionUseCase(getIt());

      @lazySingleton
      CheckNotificationPermissionUseCase get checkNotificationPermissionUseCase => CheckNotificationPermissionUseCase(getIt());

      @lazySingleton
      GetDeviceTokenUseCase get getDeviceTokenUseCase => GetDeviceTokenUseCase(getIt());

      @lazySingleton
      SubscribeToTopicUseCase get subscribeToTopicUseCase => SubscribeToTopicUseCase(getIt());

      @lazySingleton
      UnsubscribeFromTopicUseCase get unsubscribeFromTopicUseCase => UnsubscribeFromTopicUseCase(getIt());

      @lazySingleton
      SendPushNotificationUseCase get sendPushNotificationUseCase => SendPushNotificationUseCase(getIt());

      @lazySingleton
      SchedulePushNotificationUseCase get schedulePushNotificationUseCase => SchedulePushNotificationUseCase(getIt());

      @lazySingleton
      CancelScheduledPushNotificationUseCase get cancelScheduledPushNotificationUseCase => CancelScheduledPushNotificationUseCase(getIt());

      @lazySingleton
      GetSubscribedTopicsUseCase get getSubscribedTopicsUseCase => GetSubscribedTopicsUseCase(getIt());

      @lazySingleton
      HandleBackgroundMessageUseCase get handleBackgroundMessageUseCase => HandleBackgroundMessageUseCase(getIt());

      @lazySingleton
      UpdatePushTokenUseCase get updatePushTokenUseCase => UpdatePushTokenUseCase(getIt());

      @lazySingleton
      RemovePushTokenUseCase get removePushTokenUseCase => RemovePushTokenUseCase(getIt());

      @lazySingleton
      InitializePushNotificationsUseCase get initializePushNotificationsUseCase => InitializePushNotificationsUseCase(getIt());

      // Map Use Cases
      @lazySingleton
      GetCurrentLocationUseCase get getCurrentLocationUseCase => GetCurrentLocationUseCase(getIt());

      @lazySingleton
      SearchPlacesUseCase get searchPlacesUseCase => SearchPlacesUseCase(getIt());

      @lazySingleton
      GetNearbyPlacesUseCase get getNearbyPlacesUseCase => GetNearbyPlacesUseCase(getIt());

      @lazySingleton
      GetRouteUseCase get getRouteUseCase => GetRouteUseCase(getIt());

      @lazySingleton
      CalculateDistanceUseCase get calculateDistanceUseCase => CalculateDistanceUseCase(getIt());

      @lazySingleton
      GeocodeAddressUseCase get geocodeAddressUseCase => GeocodeAddressUseCase(getIt());

      @lazySingleton
      ReverseGeocodeUseCase get reverseGeocodeUseCase => ReverseGeocodeUseCase(getIt());

      @lazySingleton
      SaveLocationUseCase get saveLocationUseCase => SaveLocationUseCase(getIt());

      @lazySingleton
      GetSavedLocationsUseCase get getSavedLocationsUseCase => GetSavedLocationsUseCase(getIt());

      @lazySingleton
      SearchMapUseCase get searchMapUseCase => SearchMapUseCase(getIt());

      @lazySingleton
      GetMapMarkersUseCase get getMapMarkersUseCase => GetMapMarkersUseCase(getIt());

      @lazySingleton
      UpdateUserLocationUseCase get updateUserLocationUseCase => UpdateUserLocationUseCase(getIt());

      @lazySingleton
      EnableLocationSharingUseCase get enableLocationSharingUseCase => EnableLocationSharingUseCase(getIt());

      @lazySingleton
      GetNearbyUsersUseCase get getNearbyUsersUseCase => GetNearbyUsersUseCase(getIt());

      @lazySingleton
      OpenInMapsUseCase get openInMapsUseCase => OpenInMapsUseCase(getIt());

      @lazySingleton
      GetMapDataUseCase get getMapDataUseCase => GetMapDataUseCase(getIt());

      @lazySingleton
      CheckLocationPermissionUseCase get checkLocationPermissionUseCase => CheckLocationPermissionUseCase(getIt());

      @lazySingleton
      RequestLocationPermissionUseCase get requestLocationPermissionUseCase => RequestLocationPermissionUseCase(getIt());

      // Help Use Cases
      @lazySingleton
      GetArticlesUseCase get getArticlesUseCase => GetArticlesUseCase(getIt());

      @lazySingleton
      GetArticleByIdUseCase get getArticleByIdUseCase => GetArticleByIdUseCase(getIt());

      @lazySingleton
      CreateArticleUseCase get createArticleUseCase => CreateArticleUseCase(getIt());

      @lazySingleton
      UpdateArticleUseCase get updateArticleUseCase => UpdateArticleUseCase(getIt());

      @lazySingleton
      DeleteArticleUseCase get deleteArticleUseCase => DeleteArticleUseCase(getIt());

      @lazySingleton
      SearchArticlesUseCase get searchArticlesUseCase => SearchArticlesUseCase(getIt());

      @lazySingleton
      GetCategoriesUseCase get getCategoriesUseCase => GetCategoriesUseCase(getIt());

      @lazySingleton
      GetCategoryByIdUseCase get getCategoryByIdUseCase => GetCategoryByIdUseCase(getIt());

      @lazySingleton
      GetSubcategoriesUseCase get getSubcategoriesUseCase => GetSubcategoriesUseCase(getIt());

      @lazySingleton
      CreateCategoryUseCase get createCategoryUseCase => CreateCategoryUseCase(getIt());

      @lazySingleton
      GetFAQsUseCase get getFAQsUseCase => GetFAQsUseCase(getIt());

      @lazySingleton
      GetPopularFAQsUseCase get getPopularFAQsUseCase => GetPopularFAQsUseCase(getIt());

      @lazySingleton
      GetPopularArticlesUseCase get getPopularArticlesUseCase => GetPopularArticlesUseCase(getIt());

      @lazySingleton
      GetRecentArticlesUseCase get getRecentArticlesUseCase => GetRecentArticlesUseCase(getIt());

      @lazySingleton
      MarkArticleAsHelpfulUseCase get markArticleAsHelpfulUseCase => MarkArticleAsHelpfulUseCase(getIt());

      @lazySingleton
      BookmarkArticleUseCase get bookmarkArticleUseCase => BookmarkArticleUseCase(getIt());

      @lazySingleton
      GetBookmarkedArticlesUseCase get getBookmarkedArticlesUseCase => GetBookmarkedArticlesUseCase(getIt());

      @lazySingleton
      GetSearchSuggestionsUseCase get getSearchSuggestionsUseCase => GetSearchSuggestionsUseCase(getIt());

      @lazySingleton
      SaveSearchTermUseCase get saveSearchTermUseCase => SaveSearchTermUseCase(getIt());

      @lazySingleton
      GetRecentSearchesUseCase get getRecentSearchesUseCase => GetRecentSearchesUseCase(getIt());

      @lazySingleton
      ClearSearchHistoryUseCase get clearSearchHistoryUseCase => ClearSearchHistoryUseCase(getIt());

      @lazySingleton
      SubmitHelpFeedbackUseCase get submitHelpFeedbackUseCase => SubmitHelpFeedbackUseCase(getIt());

      @lazySingleton
      GetHelpStatsUseCase get getHelpStatsUseCase => GetHelpStatsUseCase(getIt());

      @lazySingleton
      GetRecommendedArticlesUseCase get getRecommendedArticlesUseCase => GetRecommendedArticlesUseCase(getIt());

      @lazySingleton
      GetRelatedArticlesUseCase get getRelatedArticlesUseCase => GetRelatedArticlesUseCase(getIt());

      @lazySingleton
      IncrementArticleViewsUseCase get incrementArticleViewsUseCase => IncrementArticleViewsUseCase(getIt());

      @lazySingleton
      PublishArticleUseCase get publishArticleUseCase => PublishArticleUseCase(getIt());

      @lazySingleton
      UnpublishArticleUseCase get unpublishArticleUseCase => UnpublishArticleUseCase(getIt());

      @lazySingleton
      ReorderCategoriesUseCase get reorderCategoriesUseCase => ReorderCategoriesUseCase(getIt());

      @lazySingleton
      GetArticlesByCategoryUseCase get getArticlesByCategoryUseCase => GetArticlesByCategoryUseCase(getIt());

      @lazySingleton
      GetArticlesByAuthorUseCase get getArticlesByAuthorUseCase => GetArticlesByAuthorUseCase(getIt());

      @lazySingleton
      GetUserHelpSettingsUseCase get getUserHelpSettingsUseCase => GetUserHelpSettingsUseCase(getIt());

      @lazySingleton
      UpdateUserHelpSettingsUseCase get updateUserHelpSettingsUseCase => UpdateUserHelpSettingsUseCase(getIt());

      @lazySingleton
      GetChatsUseCase get getChatsUseCase => GetChatsUseCase(getIt());

      @lazySingleton
      SendMessageUseCase get sendMessageUseCase => SendMessageUseCase(getIt());

      @lazySingleton
      CreateChatUseCase get createChatUseCase => CreateChatUseCase(getIt());

  // BLoCs
  @lazySingleton
  AuthBloc get authBloc => AuthBloc(
        loginUseCase: getIt(),
        registerUseCase: getIt(),
        logoutUseCase: getIt(),
        verifyOtpUseCase: getIt(),
      );

  @lazySingleton
  ListingBloc get listingBloc => ListingBloc(
        createListingUseCase: getIt(),
        getListingsUseCase: getIt(),
        updateListingUseCase: getIt(),
        deleteListingUseCase: getIt(),
      );

  @lazySingleton
  BarterBloc get barterBloc => BarterBloc(
        createOfferUseCase: getIt(),
        acceptOfferUseCase: getIt(),
        rejectOfferUseCase: getIt(),
        completeBarterUseCase: getIt(),
      );

  @lazySingleton
  PaymentBloc get paymentBloc => PaymentBloc(
        processPaymentUsecase: getIt(),
      );

      @lazySingleton
      LocalizationBloc get localizationBloc => LocalizationBloc(
            repository: getIt(),
            getLocalizedStringUseCase: getIt(),
          );

      @lazySingleton
      NotificationBloc get notificationBloc => NotificationBloc(
            getNotificationsUseCase: getIt(),
            markAsReadUseCase: getIt(),
            markAllAsReadUseCase: getIt(),
            updateNotificationSettingsUseCase: getIt(),
            notificationRepository: getIt(),
          );

      @lazySingleton
      ChatBloc get chatBloc => ChatBloc(
            getChatsUseCase: getIt(),
            sendMessageUseCase: getIt(),
            createChatUseCase: getIt(),
            chatRepository: getIt(),
          );
}
