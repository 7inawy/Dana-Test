import 'package:flutter/foundation.dart';

import '../log/app_logger.dart';

/// Central app configuration sourced from `--dart-define`.
///
/// Example:
/// `flutter run --dart-define=API_BASE_URL=https://rhostdev.qzz.io/api`
///
/// Use the host up to and including `/api` only. `lib/core/api/api_endpoint.dart`
/// paths already start with `/v1/...`, so do **not** set `.../api/v1` here or requests
/// become `/api/v1/v1/...`.
class AppConfig {
  AppConfig._();

  /// Base URL including `/api` but excluding `/v1`.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://rhostdev.qzz.io/api',
  );

  /// Socket.IO base URL.
  ///
  /// Our API base includes `/api` (see [apiBaseUrl]). Socket.IO is typically served
  /// from the same host root (e.g. `https://host.tld/socket.io`), so we strip a
  /// trailing `/api` if present.
  static String socketBaseUrl() {
    final raw = apiBaseUrl.trim();
    if (raw.isEmpty) return raw;
    final normalized = raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
    return normalized.endsWith('/api')
        ? normalized.substring(0, normalized.length - 4)
        : normalized;
  }

  /// Enable **debug-only** audit logging to disk / optional ingest.
  ///
  /// Intentionally defaults to `false` so it can't accidentally ship enabled.
  static const bool debugAuditEnabled = bool.fromEnvironment(
    'DEBUG_AUDIT_ENABLED',
    defaultValue: false,
  );

  /// Optional ingest URL for debug audit logs.
  ///
  /// Keep empty to disable. Prefer HTTPS when used outside local dev.
  static const String debugAuditIngestUrl =
      String.fromEnvironment('DEBUG_AUDIT_INGEST_URL');

  /// Optional certificate pins for API host (comma-separated SHA-256 hex).
  ///
  /// Provide at least 2 pins (current + next) for safe rotation.
  /// Example:
  /// `--dart-define=API_CERT_PINS_SHA256=ab12...,cd34...`
  static const String apiCertPinsSha256Csv =
      String.fromEnvironment('API_CERT_PINS_SHA256');

  /// Sentry DSN for crash reporting (leave empty to disable).
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  static List<String> apiCertPinsSha256() {
    final raw = apiCertPinsSha256Csv.trim();
    if (raw.isEmpty) return const <String>[];
    return raw
        .split(',')
        .map((s) => s.trim().toLowerCase())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }

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

    if (kReleaseMode && debugAuditEnabled) {
      AppLogger.warn('Release build has DEBUG_AUDIT_ENABLED=true (should be false).');
    }
  }
}
