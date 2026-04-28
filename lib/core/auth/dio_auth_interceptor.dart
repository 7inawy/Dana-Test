import 'package:dio/dio.dart';

import '../api/api_endpoint.dart';
import 'auth_session.dart';

class DioAuthInterceptor extends Interceptor {
  final AuthSession _session;

  DioAuthInterceptor(this._session);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final path = options.uri.path;
      if (ApiEndpoint.isPublicParentAuthPath(path)) {
        handler.next(options);
        return;
      }
      final token = await _session.token();
      if (token != null && token.trim().isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // If secure storage fails, proceed without auth header.
    }
    handler.next(options);
  }
}
