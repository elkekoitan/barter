import 'package:dio/dio.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is FormatException) {
      return const ValidationFailure('Invalid data format');
    } else if (error is TypeError) {
      return const ValidationFailure('Invalid data type');
    } else {
      return UnknownFailure(error.toString());
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          'Request timeout',
          details: 'Please check your internet connection and try again',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return const ValidationFailure('Request cancelled');

      case DioExceptionType.unknown:
      case DioExceptionType.connectionError:
        return NetworkFailure(
          'Network error',
          details: 'Please check your internet connection',
        );

      default:
        return UnknownFailure(error.message ?? 'Unknown network error');
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure('No response from server');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          _getErrorMessage(data, 'Bad request'),
          details: _getErrorDetails(data),
        );

      case 401:
        return const AuthFailure('Unauthorized access');

      case 403:
        return const PermissionFailure('Access forbidden');

      case 404:
        return const NotFoundFailure('Resource not found');

      case 409:
        return ValidationFailure(
          _getErrorMessage(data, 'Conflict'),
          details: _getErrorDetails(data),
        );

      case 422:
        return ValidationFailure(
          _getErrorMessage(data, 'Validation failed'),
          details: _getErrorDetails(data),
        );

      case 429:
        return const TimeoutFailure('Too many requests');

      case 500:
        return ServerFailure(
          'Internal server error',
          code: 500,
          details: _getErrorDetails(data),
        );

      case 502:
      case 503:
        return ServerFailure(
          'Service unavailable',
          code: statusCode,
          details: 'Please try again later',
        );

      default:
        return ServerFailure(
          _getErrorMessage(data, 'Server error'),
          code: statusCode,
          details: _getErrorDetails(data),
        );
    }
  }

  static String _getErrorMessage(dynamic data, String defaultMessage) {
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return data['message'].toString();
    }
    return defaultMessage;
  }

  static String? _getErrorDetails(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('details')) {
        return data['details'].toString();
      }
      if (data.containsKey('error')) {
        return data['error'].toString();
      }
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map) {
          return errors.values.join(', ');
        }
        return errors.toString();
      }
    }
    return null;
  }
}
