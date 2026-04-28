import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dana/core/api/api_error.dart';
import 'package:dana/core/api/api_endpoint.dart';
import 'package:dana/core/api/api_response.dart';
import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/log/app_logger.dart';
import 'package:dana/core/navigation/app_navigator.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dio/dio.dart';

class GoogleOAuthDeepLinkHandler {
  GoogleOAuthDeepLinkHandler._();

  static StreamSubscription<Uri>? _sub;
  static bool _started = false;

  static bool _isGoogleCallback(Uri uri) {
    // Backend callback is a normal HTTPS URL:
    // https://rhostdev.qzz.io/api/v1/parent/google/callback?...oauth params...
    return uri.path == ApiEndpoint.googleCallback ||
        uri.path.endsWith(ApiEndpoint.googleCallback);
  }

  static String? _extractTempKey(dynamic decoded) {
    if (decoded is! Map) return null;
    final direct = decoded['tempKey'] ?? decoded['temp_key'];
    final directStr = direct?.toString().trim();
    if (directStr != null && directStr.isNotEmpty) return directStr;

    final tokenWrapper = decoded['token'];
    if (tokenWrapper is Map) {
      final nested = tokenWrapper['tempKey'] ?? tokenWrapper['temp_key'];
      final s = nested?.toString().trim();
      if (s != null && s.isNotEmpty) return s;
    }
    return null;
  }

  static String? _extractAccessToken(dynamic decoded) {
    if (decoded is! Map) return null;

    final accessToken = decoded['accessToken'];
    if (accessToken is Map) {
      final token = accessToken['access_token']?.toString().trim();
      if (token != null && token.isNotEmpty) return token;
    }
    final tokenWrapper = decoded['token'];
    if (tokenWrapper is Map) {
      final nested = tokenWrapper['accessToken'];
      if (nested is Map) {
        final token = nested['access_token']?.toString().trim();
        if (token != null && token.isNotEmpty) return token;
      }
    }
    return null;
  }

  static Future<void> start() async {
    if (_started) return;
    _started = true;

    final appLinks = AppLinks();

    Future<void> handle(Uri uri) async {
      if (!_isGoogleCallback(uri)) return;

      AppLogger.info('GoogleOAuth: received callback deep link: $uri');
      try {
        final dio = sl<Dio>();
        final res = await dio.getUri(
          uri,
          options: Options(
            followRedirects: false,
            validateStatus: (s) => s != null && s >= 200 && s < 500,
          ),
        );

        final decoded = ApiResponse.decode(res.data);
        final token = _extractAccessToken(decoded);
        if (token != null && token.isNotEmpty) {
          await sl<AuthSession>().setToken(token);
          AppNavigator.key.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.home,
            (r) => false,
          );
          return;
        }

        final tempKey = _extractTempKey(decoded);
        if (tempKey != null && tempKey.isNotEmpty) {
          AppNavigator.key.currentState?.pushNamed(
            AppRoutes.googleComplete,
            arguments: tempKey,
          );
          return;
        }

        final msg = ApiError.messageFromDecoded(
          decoded,
          fallback: 'Google callback did not return token/tempKey',
        );
        AppLogger.warn('GoogleOAuth: callback parse failed: $msg');
      } catch (e, st) {
        AppLogger.error('GoogleOAuth: deep link handler failed', error: e, stackTrace: st);
      }
    }

    // Handle cold start.
    try {
      final uri = await appLinks.getInitialLink();
      if (uri != null) {
        unawaited(handle(uri));
      }
    } catch (e) {
      AppLogger.warn('GoogleOAuth: getInitialLink failed: $e');
    }

    // Handle warm links.
    _sub = appLinks.uriLinkStream.listen(
      (uri) => unawaited(handle(uri)),
      onError: (e) => AppLogger.warn('GoogleOAuth: uriLinkStream error: $e'),
    );
  }

  static Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _started = false;
  }
}

