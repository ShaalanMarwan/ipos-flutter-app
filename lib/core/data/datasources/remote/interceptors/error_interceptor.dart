import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ErrorInterceptor extends Interceptor {
  final _logger = Logger();

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    _logger.e(
      'API Error',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    // Log request details
    _logger.d('Request: ${err.requestOptions.method} ${err.requestOptions.uri}');
    _logger.d('Headers: ${err.requestOptions.headers}');
    
    if (err.requestOptions.data != null) {
      _logger.d('Body: ${err.requestOptions.data}');
    }

    // Log response if available
    if (err.response != null) {
      _logger.d('Response Status: ${err.response!.statusCode}');
      _logger.d('Response Data: ${err.response!.data}');
    }

    handler.next(err);
  }
}