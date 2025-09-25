import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object?> get props => [];
}

class ChangeLocaleRequested extends LocalizationEvent {
  final Locale locale;

  const ChangeLocaleRequested(this.locale);

  @override
  List<Object?> get props => [locale];
}

class GetCurrentLocaleRequested extends LocalizationEvent {}

class GetSupportedLocalesRequested extends LocalizationEvent {}

class GetLocalizedStringRequested extends LocalizationEvent {
  final String key;
  final List<String>? args;

  const GetLocalizedStringRequested(this.key, {this.args});

  @override
  List<Object?> get props => [key, args];
}

class GetValidationMessageRequested extends LocalizationEvent {
  final String key;
  final List<String>? args;

  const GetValidationMessageRequested(this.key, {this.args});

  @override
  List<Object?> get props => [key, args];
}

class GetAuthValidationMessageRequested extends LocalizationEvent {
  final String key;

  const GetAuthValidationMessageRequested(this.key);

  @override
  List<Object?> get props => [key];
}

class GetBarterValidationMessageRequested extends LocalizationEvent {
  final String key;

  const GetBarterValidationMessageRequested(this.key);

  @override
  List<Object?> get props => [key];
}

class FormatNumberRequested extends LocalizationEvent {
  final double number;
  final String? currency;

  const FormatNumberRequested(this.number, {this.currency});

  @override
  List<Object?> get props => [number, currency];
}

class FormatDateRequested extends LocalizationEvent {
  final DateTime date;
  final bool short;
  final bool withTime;

  const FormatDateRequested(this.date, {this.short = false, this.withTime = false});

  @override
  List<Object?> get props => [date, short, withTime];
}

class GetRelativeTimeRequested extends LocalizationEvent {
  final DateTime dateTime;

  const GetRelativeTimeRequested(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}

class LoadAllTranslationsRequested extends LocalizationEvent {
  final Locale locale;

  const LoadAllTranslationsRequested(this.locale);

  @override
  List<Object?> get props => [locale];
}
