// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injection_container.dart';

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars

class GetItInjectableX {
  GetItInjectableX._();

  static final GetItInjectableX _singleton = GetItInjectableX._();

  factory GetItInjectableX() {
    return _singleton;
  }

  GetIt _getIt = GetIt.instance;

  GetIt init({
    String? environment,
    EnvironmentFilter? environmentFilter,
  }) {
    final gh = GetItHelper(_getIt, environment, environmentFilter);
    gh.lazySingleton<Dio>(() => Dio(BaseOptions(
      baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.bogazicibarter.com/v1'),
      connectTimeout: const Duration(milliseconds: int.fromEnvironment('API_TIMEOUT', defaultValue: 30000)),
      receiveTimeout: const Duration(milliseconds: int.fromEnvironment('API_TIMEOUT', defaultValue: 30000)),
    ))
    ..interceptors.addAll([
      AuthInterceptor(gh<AuthInterceptor>()),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]));

    gh.lazySingleton<SharedPreferences>(() => throwIfNotRegistered(() async => SharedPreferences.getInstance()));

    gh.lazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

    gh.lazySingleton<Connectivity>(() => Connectivity());

    gh.lazySingleton<NetworkInfo>(() => NetworkInfoImpl(gh<NetworkInfo>()));

    gh.lazySingleton<ApiClient>(() => ApiClient(gh<ApiClient>()));

    gh.lazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource(gh<AuthLocalDataSource>(), gh<AuthLocalDataSource>()));

    gh.lazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(gh<AuthRemoteDataSource>()));

    gh.lazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(gh<ApiClient>()));

    gh.lazySingleton<ListingRemoteDataSource>(() => ListingRemoteDataSourceImpl(gh<ApiClient>()));

    gh.lazySingleton<BarterRemoteDataSource>(() => BarterRemoteDataSourceImpl(gh<ApiClient>()));

    gh.lazySingleton<PaymentRemoteDataSource>(() => PaymentRemoteDataSource(gh<PaymentRemoteDataSource>()));

    gh.lazySingleton<CacheManager>(() => CacheManagerImpl(gh<SharedPreferences>()));

    gh.lazySingleton<PushNotificationRemoteDataSource>(() => PushNotificationRemoteDataSourceImpl(
      firebaseMessaging: gh<FirebaseMessaging>(),
      localNotifications: gh<FlutterLocalNotificationsPlugin>(),
    ));

    gh.lazySingleton<MapRemoteDataSource>(() => MapRemoteDataSourceImpl(
      googleMapsApiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: 'YOUR_API_KEY'),
    ));

    gh.lazySingleton<HelpRemoteDataSource>(() => HelpRemoteDataSourceImpl(
      baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.bogazicibarter.com/v1'),
    ));

    gh.lazySingleton<AuthRepository>(() => AuthRepositoryImpl(gh<AuthRemoteDataSource>(), gh<AuthLocalDataSource>(), gh<NetworkInfo>()));

    gh.lazySingleton<UserRepository>(() => UserRepositoryImpl(gh<UserRemoteDataSource>(), gh<AuthLocalDataSource>()));

    gh.lazySingleton<ListingRepository>(() => ListingRepositoryImpl(gh<ListingRemoteDataSource>(), gh<NetworkInfo>()));

    gh.lazySingleton<BarterRepository>(() => BarterRepositoryImpl(gh<BarterRemoteDataSource>(), gh<NetworkInfo>()));

    gh.lazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(gh<PaymentRemoteDataSource>(), gh<NetworkInfo>()));

    gh.lazySingleton<LocalizationRepository>(() => LocalizationRepositoryImpl(gh<SharedPreferences>()));

    gh.lazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(gh<NotificationRemoteDataSource>(), gh<AuthLocalDataSource>(), gh<NetworkInfo>()));

    gh.lazySingleton<ChatRepository>(() => ChatRepositoryImpl(gh<AuthRemoteDataSource>(), gh<AuthLocalDataSource>(), gh<NetworkInfo>()));

    gh.lazySingleton<MapRepository>(() => MapRepositoryImpl(gh<MapRemoteDataSource>()));

    gh.lazySingleton<HelpRepository>(() => HelpRepositoryImpl(gh<HelpRemoteDataSource>()));

    gh.lazySingleton<LoginUseCase>(() => LoginUseCase(gh<AuthRepository>(), gh<NetworkInfo>()));

    gh.lazySingleton<RegisterUseCase>(() => RegisterUseCase(gh<AuthRepository>(), gh<NetworkInfo>()));

    gh.lazySingleton<LogoutUseCase>(() => LogoutUseCase(gh<AuthRepository>()));

    gh.lazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(gh<AuthRepository>(), gh<NetworkInfo>()));

    gh.lazySingleton<CreateListingUseCase>(() => CreateListingUseCase(gh<ListingRepository>()));

    gh.lazySingleton<GetListingsUseCase>(() => GetListingsUseCase(gh<ListingRepository>()));

    gh.lazySingleton<UpdateListingUseCase>(() => UpdateListingUseCase(gh<ListingRepository>()));

    gh.lazySingleton<DeleteListingUseCase>(() => DeleteListingUseCase(gh<ListingRepository>()));

    gh.lazySingleton<CreateOfferUseCase>(() => CreateOfferUseCase(gh<BarterRepository>()));

    gh.lazySingleton<AcceptOfferUseCase>(() => AcceptOfferUseCase(gh<BarterRepository>()));

    gh.lazySingleton<RejectOfferUseCase>(() => RejectOfferUseCase(gh<BarterRepository>()));

    gh.lazySingleton<CompleteBarterUseCase>(() => CompleteBarterUseCase(gh<BarterRepository>()));

    gh.lazySingleton<ProcessPaymentUseCase>(() => ProcessPaymentUseCase(gh<PaymentRepository>()));

    gh.lazySingleton<CreateEscrowUseCase>(() => CreateEscrowUseCase(gh<PaymentRepository>()));

    gh.lazySingleton<ReleaseEscrowUseCase>(() => ReleaseEscrowUseCase(gh<PaymentRepository>()));

    gh.lazySingleton<RefundPaymentUseCase>(() => RefundPaymentUseCase(gh<PaymentRepository>()));

    gh.lazySingleton<GetLocalizedStringUseCase>(() => GetLocalizedStringUseCase(gh<LocalizationRepository>()));

    gh.lazySingleton<GetNotificationsUseCase>(() => GetNotificationsUseCase(gh<NotificationRepository>()));

    gh.lazySingleton<MarkAsReadUseCase>(() => MarkAsReadUseCase(gh<NotificationRepository>()));

    gh.lazySingleton<MarkAllAsReadUseCase>(() => MarkAllAsReadUseCase(gh<NotificationRepository>()));

    gh.lazySingleton<UpdateNotificationSettingsUseCase>(() => UpdateNotificationSettingsUseCase(gh<NotificationRepository>()));

    gh.lazySingleton<GetChatsUseCase>(() => GetChatsUseCase(gh<ChatRepository>()));

    gh.lazySingleton<SendMessageUseCase>(() => SendMessageUseCase(gh<ChatRepository>()));

    gh.lazySingleton<CreateChatUseCase>(() => CreateChatUseCase(gh<ChatRepository>()));

    gh.lazySingleton<AuthBloc>(() => AuthBloc(
      loginUseCase: gh<LoginUseCase>(),
      registerUseCase: gh<RegisterUseCase>(),
      logoutUseCase: gh<LogoutUseCase>(),
      verifyOtpUseCase: gh<VerifyOtpUseCase>(),
    ));

    gh.lazySingleton<ListingBloc>(() => ListingBloc(
      createListingUseCase: gh<CreateListingUseCase>(),
      getListingsUseCase: gh<GetListingsUseCase>(),
      updateListingUseCase: gh<UpdateListingUseCase>(),
      deleteListingUseCase: gh<DeleteListingUseCase>(),
    ));

    gh.lazySingleton<BarterBloc>(() => BarterBloc(
      createOfferUseCase: gh<CreateOfferUseCase>(),
      acceptOfferUseCase: gh<AcceptOfferUseCase>(),
      rejectOfferUseCase: gh<RejectOfferUseCase>(),
      completeBarterUseCase: gh<CompleteBarterUseCase>(),
    ));

    gh.lazySingleton<PaymentBloc>(() => PaymentBloc(
      processPaymentUsecase: gh<ProcessPaymentUseCase>(),
    ));

    gh.lazySingleton<LocalizationBloc>(() => LocalizationBloc(
      repository: gh<LocalizationRepository>(),
      getLocalizedStringUseCase: gh<GetLocalizedStringUseCase>(),
    ));

    gh.lazySingleton<NotificationBloc>(() => NotificationBloc(
      getNotificationsUseCase: gh<GetNotificationsUseCase>(),
      markAsReadUseCase: gh<MarkAsReadUseCase>(),
      markAllAsReadUseCase: gh<MarkAllAsReadUseCase>(),
      updateNotificationSettingsUseCase: gh<UpdateNotificationSettingsUseCase>(),
      notificationRepository: gh<NotificationRepository>(),
    ));

    gh.lazySingleton<ChatBloc>(() => ChatBloc(
      getChatsUseCase: gh<GetChatsUseCase>(),
      sendMessageUseCase: gh<SendMessageUseCase>(),
      createChatUseCase: gh<CreateChatUseCase>(),
      chatRepository: gh<ChatRepository>(),
    ));

    return _getIt;
  }

  T call<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
    dynamic param3,
    dynamic param4,
    dynamic param5,
    dynamic param6,
    dynamic param7,
    dynamic param8,
    dynamic param9,
    dynamic param10,
  }) {
    return _getIt.call(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      param3: param3,
      param4: param4,
      param5: param5,
      param6: param6,
      param7: param7,
      param8: param8,
      param9: param9,
      param10: param10,
    );
  }

  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
    dynamic param3,
    dynamic param4,
    dynamic param5,
    dynamic param6,
    dynamic param7,
    dynamic param8,
    dynamic param9,
    dynamic param10,
  }) {
    return _getIt.get(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      param3: param3,
      param4: param4,
      param5: param5,
      param6: param6,
      param7: param7,
      param8: param8,
      param9: param9,
      param10: param10,
    );
  }

  T read<T extends Object>({String? instanceName}) {
    return _getIt.get(instanceName: instanceName);
  }

  bool isRegistered<T extends Object>({Object? instance, String? instanceName}) {
    return _getIt.isRegistered<T>(instance: instance, instanceName: instanceName);
  }

  void registerFactory<T extends Object>(
    FactoryFunc<T> factoryfunc, {
    String? instanceName,
  }) {
    _getIt.registerFactory(factoryfunc, instanceName: instanceName);
  }

  void registerFactoryParam<T extends Object, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10>(
    FactoryFuncParam<T, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10> factoryfunc, {
    String? instanceName,
  }) {
    _getIt.registerFactoryParam(factoryfunc, instanceName: instanceName);
  }

  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryfunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
  }) {
    _getIt.registerLazySingleton(factoryfunc, instanceName: instanceName, dispose: dispose);
  }

  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  }) {
    _getIt.registerSingleton(instance, instanceName: instanceName, signalsReady: signalsReady, dispose: dispose);
  }

  void registerSingletonWithDependencies<T extends Object>(
    FactoryFunc<T> factoryfunc, {
    String? instanceName,
    Iterable<Type> dependsOn,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  }) {
    _getIt.registerSingletonWithDependencies(
      factoryfunc,
      instanceName: instanceName,
      dependsOn: dependsOn,
      signalsReady: signalsReady,
      dispose: dispose,
    );
  }

  void reset() {
    _getIt.reset();
  }

  void resetLazySingleton<T extends Object>({
    Object? instance,
    String? instanceName,
    DisposingFunc<T>? dispose,
  }) {
    _getIt.resetLazySingleton<T>(instance: instance, instanceName: instanceName, dispose: dispose);
  }

  void unregister<T extends Object>({
    Object? instance,
    String? instanceName,
    DisposingFunc<T>? dispose,
  }) {
    _getIt.unregister<T>(instance: instance, instanceName: instanceName, dispose: dispose);
  }

  bool allReadySync() {
    return _getIt.allReadySync();
  }

  Future<bool> allReady() {
    return _getIt.allReady();
  }

  Future<void> resetScope() {
    return _getIt.resetScope();
  }

  void signalReady(Object? instance) {
    _getIt.signalReady(instance);
  }

  bool isReadySync<T extends Object>({Object? instance, String? instanceName}) {
    return _getIt.isReadySync<T>(instance: instance, instanceName: instanceName);
  }

  Future<bool> isReady<T extends Object>({Object? instance, String? instanceName}) {
    return _getIt.isReady<T>(instance: instance, instanceName: instanceName);
  }

  bool hasScope(String scopeName) {
    return _getIt.hasScope(scopeName);
  }

  void popScope() {
    _getIt.popScope();
  }

  void pushScope(String scopeName, {ScopeDisposeFunc? disposeFunc}) {
    _getIt.pushScope(scopeName, disposeFunc: disposeFunc);
  }

  String get currentScopeName => _getIt.currentScopeName;

  void onScopeChanged(void Function(String scopeName) callback) {
    _getIt.onScopeChanged(callback);
  }
}

T throwIfNotRegistered<T>() {
  throw Exception('Type $T is not registered in GetIt');
}

class GetItHelper {
  final GetIt _getIt;
  final String? _environment;
  final EnvironmentFilter? _environmentFilter;

  GetItHelper(this._getIt, this._environment, this._environmentFilter);

  void lazySingleton<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
  }) {
    _getIt.registerLazySingleton(factoryFunc, instanceName: instanceName, dispose: dispose);
  }

  void factory<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    _getIt.registerFactory(factoryFunc, instanceName: instanceName);
  }

  void singleton<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  }) {
    _getIt.registerSingleton(factoryFunc(), instanceName: instanceName, signalsReady: signalsReady, dispose: dispose);
  }

  T call<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
    dynamic param3,
    dynamic param4,
    dynamic param5,
    dynamic param6,
    dynamic param7,
    dynamic param8,
    dynamic param9,
    dynamic param10,
  }) {
    return _getIt.call(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      param3: param3,
      param4: param4,
      param5: param5,
      param6: param6,
      param7: param7,
      param8: param8,
      param9: param9,
      param10: param10,
    );
  }

  T operator <T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
    dynamic param3,
    dynamic param4,
    dynamic param5,
    dynamic param6,
    dynamic param7,
    dynamic param8,
    dynamic param9,
    dynamic param10,
  }) {
    return _getIt.get(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      param3: param3,
      param4: param4,
      param5: param5,
      param6: param6,
      param7: param7,
      param8: param8,
      param9: param9,
      param10: param10,
    );
  }
}
