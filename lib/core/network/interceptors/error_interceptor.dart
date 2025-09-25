import 'package:dio/dio.dart';
import '../../errors/error_handler.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException to our Failure types
    final failure = ErrorHandler.handleError(err);

    // You could emit this failure to a global error stream here
    // For now, we just pass it along
    return handler.next(err);
  }
}
