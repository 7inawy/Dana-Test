import 'package:dio/dio.dart';

import '../api/api_endpoint.dart';
import '../log/app_logger.dart';
import '../navigation/app_navigator.dart';
import '../utils/app_routes.dart';
import 'auth_session.dart';

class DioUnauthorizedInterceptor extends Interceptor {
  final AuthSession _session;

  DioUnauthorizedInterceptor(this._session);

  static bool _handling = false;

  bool _isAuthFailure(DioException err) {
    final code = err.response?.statusCode;
    return code == 401 || code == 403;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      if (_handling || !_isAuthFailure(err)) {
        handler.next(err);
        return;
      }

      final path = err.requestOptions.uri.path;
      if (ApiEndpoint.isPublicParentAuthPath(path)) {
        handler.next(err);
        return;
      }

      _handling = true;
      await _session.clear();

      // Navigate to login and clear backstack.
      final nav = AppNavigator.key.currentState;
      if (nav != null) {
        nav.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    } catch (e) {
      AppLogger.error('Failed handling unauthorized response', error: e);
    } finally {
      _handling = false;
    }

    handler.next(err);
  }
}
