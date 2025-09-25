import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  final bool _enableLogging = kDebugMode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_enableLogging) {
      _log('API REQUEST', '''
Method: ${options.method}
URL: ${options.baseUrl}${options.path}
Headers: ${options.headers}
Query: ${options.queryParameters}
Body: ${options.data}
''');
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_enableLogging) {
      _log('API RESPONSE', '''
Status: ${response.statusCode}
URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}
Response: ${response.data}
''');
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_enableLogging) {
      _log('API ERROR', '''
Status: ${err.response?.statusCode ?? 'Unknown'}
URL: ${err.requestOptions.baseUrl}${err.requestOptions.path}
Error: ${err.error}
Response: ${err.response?.data}
''');
    }

    return handler.next(err);
  }

  void _log(String title, String message) {
    debugPrint('''
╔══════════════════════════════════════════════════════════════════╗
║ $title
╠══════════════════════════════════════════════════════════════════╣
$message
╚══════════════════════════════════════════════════════════════════╝
''');
  }
}
