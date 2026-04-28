import '../config/app_config.dart';

/// Backwards-compatible alias for the app base URL.
///
/// Prefer using `AppConfig.apiBaseUrl` directly in new code.
class ApiConstant {
  static final String baseUrl = AppConfig.apiBaseUrl;
}
