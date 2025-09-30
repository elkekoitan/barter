import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/localization_repository.dart';

class LocalizationRepositoryImpl implements LocalizationRepository {
  static const String _localeKey = 'current_locale';
  final SharedPreferences _preferences;

  const LocalizationRepositoryImpl(this._preferences);

  @override
  Future<Either<Failure, Locale>> getCurrentLocale() async {
    try {
      final String? localeCode = _preferences.getString(_localeKey);

      if (localeCode == null) {
        // Return device locale or default to Turkish
        final Locale deviceLocale = WidgetsBinding.instance.window.locale;
        final Locale defaultLocale = isLocaleSupportedSync(deviceLocale) ? deviceLocale : const Locale('tr');
        return Right(defaultLocale);
      }

      final List<String> parts = localeCode.split('_');
      final String languageCode = parts[0];
      final String? countryCode = parts.length > 1 ? parts[1] : null;

      final Locale locale = countryCode != null ? Locale(languageCode, countryCode) : Locale(languageCode);
      return Right(locale);
    } catch (e) {
      return Left(CacheFailure('Failed to get current locale: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> setCurrentLocale(Locale locale) async {
    try {
      final String localeCode = locale.countryCode != null ? '${locale.languageCode}_${locale.countryCode}' : locale.languageCode;
      await _preferences.setString(_localeKey, localeCode);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to set current locale: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Locale>>> getSupportedLocales() async {
    try {
      return const Right([
        Locale('tr'), // Turkish
        Locale('en'), // English
        Locale('ar'), // Arabic
      ]);
    } catch (e) {
      return Left(ServerFailure('Failed to get supported locales: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLocaleSupported(Locale locale) async {
    try {
      final Either<Failure, List<Locale>> result = await getSupportedLocales();
      return result.fold(
        (failure) => Left(failure),
        (locales) => Right(locales.any((l) => l.languageCode == locale.languageCode)),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to check locale support: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> getLocalizedString(String key, {List<String>? args}) async {
    try {
      final Either<Failure, Locale> currentLocaleResult = await getCurrentLocale();
      return await currentLocaleResult.fold(
        (failure) => Left(failure),
        (locale) async {
          try {
            final String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
            final Map<String, dynamic> translations = json.decode(jsonString);

            String? value = _getNestedValue(translations, key);
            if (value == null) {
              return Right(key); // Fallback to key if translation not found
            }

            if (args != null && args.isNotEmpty) {
              value = _replaceArguments(value, args);
            }

            return Right(value);
          } catch (e) {
            return Left(ServerFailure('Failed to load translation: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get localized string: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> getValidationMessage(String key, {List<String>? args}) async {
    try {
      final Either<Failure, Locale> currentLocaleResult = await getCurrentLocale();
      return await currentLocaleResult.fold(
        (failure) => Left(failure),
        (locale) async {
          try {
            final String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
            final Map<String, dynamic> translations = json.decode(jsonString);
            final Map<String, dynamic> validationMessages = translations['validation_messages'] ?? {};

            String? message = _getNestedValue(validationMessages, key);
            if (message == null) {
              return Right('Validation error'); // Fallback
            }

            if (args != null && args.isNotEmpty) {
              message = _replaceArguments(message, args);
            }

            return Right(message);
          } catch (e) {
            return Left(ServerFailure('Failed to load validation message: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get validation message: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> getAuthValidationMessage(String key) async {
    try {
      final Either<Failure, Locale> currentLocaleResult = await getCurrentLocale();
      return await currentLocaleResult.fold(
        (failure) => Left(failure),
        (locale) async {
          try {
            final String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
            final Map<String, dynamic> translations = json.decode(jsonString);
            final Map<String, dynamic> authValidation = translations['auth_validation'] ?? {};

            String? message = _getNestedValue(authValidation, key);
            return Right(message ?? 'Authentication error');
          } catch (e) {
            return Left(ServerFailure('Failed to load auth validation message: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get auth validation message: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> getBarterValidationMessage(String key) async {
    try {
      final Either<Failure, Locale> currentLocaleResult = await getCurrentLocale();
      return await currentLocaleResult.fold(
        (failure) => Left(failure),
        (locale) async {
          try {
            final String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
            final Map<String, dynamic> translations = json.decode(jsonString);
            final Map<String, dynamic> barterValidation = translations['barter_validation'] ?? {};

            String? message = _getNestedValue(barterValidation, key);
            return Right(message ?? 'Barter error');
          } catch (e) {
            return Left(ServerFailure('Failed to load barter validation message: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get barter validation message: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> formatNumber(double number, {String? currency}) async {
    try {
      final Either<Failure, Locale> currentLocaleResult = await getCurrentLocale();
      return await currentLocaleResult.fold(
        (failure) => Left(failure),
        (locale) async {
          try {
            final String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
            final Map<String, dynamic> translations = json.decode(jsonString);

            final String currencySymbol = currency ?? translations['currency_symbol'] ?? '₺';
            final String formattedNumber = _formatNumberWithLocale(number, translations);

            return Right('$formattedNumber $currencySymbol');
          } catch (e) {
            return Left(ServerFailure('Failed to format number: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to format number: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> formatDate(DateTime date, {bool short = false, bool withTime = false}) async {
    try {
      final Either<Failure, Locale> currentLocaleResult = await getCurrentLocale();
      return await currentLocaleResult.fold(
        (failure) => Left(failure),
        (locale) async {
          try {
            final String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
            final Map<String, dynamic> translations = json.decode(jsonString);

            String pattern;
            if (withTime) {
              pattern = translations['date_format']['with_time'] ?? 'dd/MM/yyyy HH:mm';
            } else if (short) {
              pattern = translations['date_format']['short'] ?? 'dd/MM/yyyy';
            } else {
              pattern = translations['date_format']['long'] ?? 'dd MMMM yyyy';
            }

            final String formatted = _formatDateWithPattern(date, pattern, locale.languageCode);
            return Right(formatted);
          } catch (e) {
            return Left(ServerFailure('Failed to format date: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to format date: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> getRelativeTime(DateTime dateTime) async {
    try {
      final Either<Failure, Locale> currentLocaleResult = await getCurrentLocale();
      return await currentLocaleResult.fold(
        (failure) => Left(failure),
        (locale) async {
          try {
            final String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
            final Map<String, dynamic> translations = json.decode(jsonString);

            final Duration difference = DateTime.now().difference(dateTime);

            if (difference.inMinutes < 1) {
              return Right(translations['just_now'] ?? 'Just now');
            } else if (difference.inHours < 1) {
              return Right(translations['minutes_ago']?.replaceFirst('{}', difference.inMinutes.toString()) ?? '${difference.inMinutes} minutes ago');
            } else if (difference.inDays < 1) {
              return Right(translations['hours_ago']?.replaceFirst('{}', difference.inHours.toString()) ?? '${difference.inHours} hours ago');
            } else {
              return Right(translations['days_ago']?.replaceFirst('{}', difference.inDays.toString()) ?? '${difference.inDays} days ago');
            }
          } catch (e) {
            return Left(ServerFailure('Failed to get relative time: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get relative time: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAllTranslations(Locale locale) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
      final Map<String, dynamic> translations = json.decode(jsonString);
      return Right(translations);
    } catch (e) {
      return Left(ServerFailure('Failed to load all translations: ${e.toString()}'));
    }
  }

  // Helper methods
  bool isLocaleSupportedSync(Locale locale) {
    return ['tr', 'en', 'ar'].contains(locale.languageCode);
  }

  String? _getNestedValue(Map<String, dynamic> map, String key) {
    final List<String> keys = key.split('.');
    dynamic current = map;

    for (String k in keys) {
      if (current is Map<String, dynamic> && current.containsKey(k)) {
        current = current[k];
      } else {
        return null;
      }
    }

    return current is String ? current : null;
  }

  String _replaceArguments(String template, List<String> args) {
    String result = template;
    for (int i = 0; i < args.length; i++) {
      result = result.replaceFirst('{}', args[i]);
    }
    return result;
  }

  String _formatNumberWithLocale(double number, Map<String, dynamic> translations) {
    final String decimalSep = translations['number_format']['decimal_separator'] ?? ',';
    final String thousandSep = translations['number_format']['thousand_separator'] ?? '.';

    final List<String> parts = number.toStringAsFixed(2).split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    // Add thousand separators
    final RegExp regex = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(regex, (match) => '${match.group(1)}$thousandSep');

    return '$integerPart$decimalSep$decimalPart';
  }

  String _formatDateWithPattern(DateTime date, String pattern, String locale) {
    // Simple date formatting - in a real app, you'd use intl package
    final Map<String, Map<String, String>> monthNames = {
      'tr': {
        '1': 'Ocak', '2': 'Şubat', '3': 'Mart', '4': 'Nisan', '5': 'Mayıs', '6': 'Haziran',
        '7': 'Temmuz', '8': 'Ağustos', '9': 'Eylül', '10': 'Ekim', '11': 'Kasım', '12': 'Aralık'
      },
      'en': {
        '1': 'January', '2': 'February', '3': 'March', '4': 'April', '5': 'May', '6': 'June',
        '7': 'July', '8': 'August', '9': 'September', '10': 'October', '11': 'November', '12': 'December'
      },
      'ar': {
        '1': 'يناير', '2': 'فبراير', '3': 'مارس', '4': 'أبريل', '5': 'مايو', '6': 'يونيو',
        '7': 'يوليو', '8': 'أغسطس', '9': 'سبتمبر', '10': 'أكتوبر', '11': 'نوفمبر', '12': 'ديسمبر'
      }
    };

    String formatted = pattern
        .replaceAll('dd', date.day.toString().padLeft(2, '0'))
        .replaceAll('MM', date.month.toString().padLeft(2, '0'))
        .replaceAll('yyyy', date.year.toString())
        .replaceAll('HH', date.hour.toString().padLeft(2, '0'))
        .replaceAll('mm', date.minute.toString().padLeft(2, '0'));

    // Replace month names
    final int monthIndex = date.month;
    final String? monthName = monthNames[locale]?[monthIndex.toString()];
    if (monthName != null) {
      formatted = formatted.replaceAll('MMMM', monthName);
    }

    return formatted;
  }
}
