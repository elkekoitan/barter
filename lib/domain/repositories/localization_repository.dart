import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../core/errors/failures.dart';

abstract class LocalizationRepository {
  Future<Either<Failure, Locale>> getCurrentLocale();
  Future<Either<Failure, void>> setCurrentLocale(Locale locale);
  Future<Either<Failure, List<Locale>>> getSupportedLocales();
  Future<Either<Failure, bool>> isLocaleSupported(Locale locale);
  Future<Either<Failure, String>> getLocalizedString(String key, {List<String>? args});
  Future<Either<Failure, String>> getValidationMessage(String key, {List<String>? args});
  Future<Either<Failure, String>> getAuthValidationMessage(String key);
  Future<Either<Failure, String>> getBarterValidationMessage(String key);
  Future<Either<Failure, String>> formatNumber(double number, {String? currency});
  Future<Either<Failure, String>> formatDate(DateTime date, {bool short = false, bool withTime = false});
  Future<Either<Failure, String>> getRelativeTime(DateTime dateTime);
  Future<Either<Failure, Map<String, dynamic>>> getAllTranslations(Locale locale);
}
