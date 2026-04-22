import 'package:flutter/foundation.dart';

import '../log/app_logger.dart';

/// Central app configuration sourced from `--dart-define`.
///
/// Example:
/// `flutter run --dart-define=API_BASE_URL=http://3.64.255.173:3000/api`
class AppConfig {
  AppConfig._();

  /// Base URL including `/api` but excluding `/v1`.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://3.64.255.173:3000/api',
  );

  /// Sentry DSN for crash reporting (leave empty to disable).
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// Call once at startup to validate critical config.
  ///
  /// We don't hard-crash in release (it would be a bad UX), but we *do* surface
  /// a strong signal in logs so misconfigured releases are caught quickly.
  static void validate() {
    if (kReleaseMode && apiBaseUrl.startsWith('http://')) {
      AppLogger.warn(
        'Release build is configured with non-HTTPS API_BASE_URL=$apiBaseUrl',
      );
    }
  }
}
