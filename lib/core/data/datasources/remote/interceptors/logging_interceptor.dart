import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _logger.i('🚀 REQUEST[${options.method}] => PATH: ${options.uri}');
    _logger.d('Headers: ${options.headers}');
    if (options.data != null) {
      _logger.d('Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.i(
      '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}',
    );
    _logger.d('Response: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    _logger.e(
      '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri}',
      error: err.error,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}