import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/localization_repository.dart';
import '../../../domain/usecases/localization/get_localized_string_usecase.dart';
import 'localization_event.dart';
import 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  final LocalizationRepository _repository;
  final GetLocalizedStringUseCase _getLocalizedStringUseCase;

  LocalizationBloc({
    required LocalizationRepository repository,
    required GetLocalizedStringUseCase getLocalizedStringUseCase,
  })  : _repository = repository,
        _getLocalizedStringUseCase = getLocalizedStringUseCase,
        super(LocalizationInitial()) {
    on<ChangeLocaleRequested>(_onChangeLocaleRequested);
    on<GetCurrentLocaleRequested>(_onGetCurrentLocaleRequested);
    on<GetSupportedLocalesRequested>(_onGetSupportedLocalesRequested);
    on<GetLocalizedStringRequested>(_onGetLocalizedStringRequested);
    on<GetValidationMessageRequested>(_onGetValidationMessageRequested);
    on<GetAuthValidationMessageRequested>(_onGetAuthValidationMessageRequested);
    on<GetBarterValidationMessageRequested>(_onGetBarterValidationMessageRequested);
    on<FormatNumberRequested>(_onFormatNumberRequested);
    on<FormatDateRequested>(_onFormatDateRequested);
    on<GetRelativeTimeRequested>(_onGetRelativeTimeRequested);
    on<LoadAllTranslationsRequested>(_onLoadAllTranslationsRequested);
  }

  Future<void> _onChangeLocaleRequested(
    ChangeLocaleRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    emit(LocalizationLoading());

    final result = await _repository.setCurrentLocale(event.locale);

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (_) => emit(LocaleChanged(event.locale)),
    );
  }

  Future<void> _onGetCurrentLocaleRequested(
    GetCurrentLocaleRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    emit(LocalizationLoading());

    final result = await _repository.getCurrentLocale();

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (locale) => emit(CurrentLocaleLoaded(locale)),
    );
  }

  Future<void> _onGetSupportedLocalesRequested(
    GetSupportedLocalesRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    emit(LocalizationLoading());

    final result = await _repository.getSupportedLocales();

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (locales) => emit(SupportedLocalesLoaded(locales)),
    );
  }

  Future<void> _onGetLocalizedStringRequested(
    GetLocalizedStringRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    final result = await _getLocalizedStringUseCase.call(event.key, args: event.args);

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (value) => emit(LocalizedStringLoaded(event.key, value)),
    );
  }

  Future<void> _onGetValidationMessageRequested(
    GetValidationMessageRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    final result = await _repository.getValidationMessage(event.key, args: event.args);

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (message) => emit(ValidationMessageLoaded(event.key, message)),
    );
  }

  Future<void> _onGetAuthValidationMessageRequested(
    GetAuthValidationMessageRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    final result = await _repository.getAuthValidationMessage(event.key);

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (message) => emit(AuthValidationMessageLoaded(event.key, message)),
    );
  }

  Future<void> _onGetBarterValidationMessageRequested(
    GetBarterValidationMessageRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    final result = await _repository.getBarterValidationMessage(event.key);

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (message) => emit(BarterValidationMessageLoaded(event.key, message)),
    );
  }

  Future<void> _onFormatNumberRequested(
    FormatNumberRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    final result = await _repository.formatNumber(event.number, currency: event.currency);

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (formattedValue) => emit(NumberFormatted(event.number, formattedValue)),
    );
  }

  Future<void> _onFormatDateRequested(
    FormatDateRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    final result = await _repository.formatDate(
      event.date,
      short: event.short,
      withTime: event.withTime,
    );

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (formattedDate) => emit(DateFormatted(event.date, formattedDate)),
    );
  }

  Future<void> _onGetRelativeTimeRequested(
    GetRelativeTimeRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    final result = await _repository.getRelativeTime(event.dateTime);

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (relativeTime) => emit(RelativeTimeLoaded(event.dateTime, relativeTime)),
    );
  }

  Future<void> _onLoadAllTranslationsRequested(
    LoadAllTranslationsRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    emit(LocalizationLoading());

    final result = await _repository.getAllTranslations(event.locale);

    result.fold(
      (failure) => emit(LocalizationError(failure.message)),
      (translations) => emit(AllTranslationsLoaded(translations)),
    );
  }

  // Helper method to get current locale
  Locale getCurrentLocale() {
    final currentState = state;
    if (currentState is CurrentLocaleLoaded) {
      return currentState.locale;
    }
    return const Locale('tr'); // Default fallback
  }

  // Helper method to get supported locales
  List<Locale> getSupportedLocales() {
    final currentState = state;
    if (currentState is SupportedLocalesLoaded) {
      return currentState.locales;
    }
    return const [Locale('tr'), Locale('en'), Locale('ar')]; // Default fallback
  }
}
