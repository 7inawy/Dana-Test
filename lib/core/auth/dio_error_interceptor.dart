import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/error_mapper.dart';
import '../log/app_logger.dart';

/// Cross-cutting network behavior for Dio.
///
/// - Adds a consistent timeout.
/// - Normalizes Dio error messages for debugging (without leaking headers/body).
class DioErrorInterceptor extends Interceptor {
  String _truncate(Object? value, {int max = 1200}) {
    final s = value?.toString() ?? '';
    if (s.length <= max) return s;
    return '${s.substring(0, max)}…';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Ensure a reasonable default timeout even if callers override options.
    options
      ..connectTimeout ??= const Duration(seconds: 15)
      ..receiveTimeout ??= const Duration(seconds: 15);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kReleaseMode) {
      final msg = ErrorMapper.message(err);
      AppLogger.debug(
        'HTTP error: ${err.requestOptions.method} ${err.requestOptions.uri} → $msg',
      );
      final status = err.response?.statusCode;
      if (status != null) {
        AppLogger.debug(
          'HTTP response: status=$status data=${_truncate(err.response?.data)}',
        );
      }
    }
    handler.next(err);
  }
}
