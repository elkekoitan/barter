import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LocalizationState extends Equatable {
  const LocalizationState();

  @override
  List<Object?> get props => [];
}

class LocalizationInitial extends LocalizationState {}

class LocalizationLoading extends LocalizationState {}

class CurrentLocaleLoaded extends LocalizationState {
  final Locale locale;

  const CurrentLocaleLoaded(this.locale);

  @override
  List<Object?> get props => [locale];
}

class SupportedLocalesLoaded extends LocalizationState {
  final List<Locale> locales;

  const SupportedLocalesLoaded(this.locales);

  @override
  List<Object?> get props => [locales];
}

class LocaleChanged extends LocalizationState {
  final Locale locale;

  const LocaleChanged(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LocalizedStringLoaded extends LocalizationState {
  final String key;
  final String value;

  const LocalizedStringLoaded(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}

class ValidationMessageLoaded extends LocalizationState {
  final String key;
  final String message;

  const ValidationMessageLoaded(this.key, this.message);

  @override
  List<Object?> get props => [key, message];
}

class AuthValidationMessageLoaded extends LocalizationState {
  final String key;
  final String message;

  const AuthValidationMessageLoaded(this.key, this.message);

  @override
  List<Object?> get props => [key, message];
}

class BarterValidationMessageLoaded extends LocalizationState {
  final String key;
  final String message;

  const BarterValidationMessageLoaded(this.key, this.message);

  @override
  List<Object?> get props => [key, message];
}

class NumberFormatted extends LocalizationState {
  final double number;
  final String formattedValue;

  const NumberFormatted(this.number, this.formattedValue);

  @override
  List<Object?> get props => [number, formattedValue];
}

class DateFormatted extends LocalizationState {
  final DateTime date;
  final String formattedDate;

  const DateFormatted(this.date, this.formattedDate);

  @override
  List<Object?> get props => [date, formattedDate];
}

class RelativeTimeLoaded extends LocalizationState {
  final DateTime dateTime;
  final String relativeTime;

  const RelativeTimeLoaded(this.dateTime, this.relativeTime);

  @override
  List<Object?> get props => [dateTime, relativeTime];
}

class AllTranslationsLoaded extends LocalizationState {
  final Map<String, dynamic> translations;

  const AllTranslationsLoaded(this.translations);

  @override
  List<Object?> get props => [translations];
}

class LocalizationError extends LocalizationState {
  final String message;
  final String? code;

  const LocalizationError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}
