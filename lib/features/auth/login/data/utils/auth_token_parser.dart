/// Shared parsing helpers for auth-related backend payloads.
///
/// The backend is not fully consistent in token nesting, so keep this logic in
/// one place and reuse it across:
/// - Remote data sources (e.g. Google complete, verify OTP)
/// - Deep link handlers (Google OAuth callbacks)
class AuthTokenParser {
  static String? extractAccessToken(dynamic decoded) {
    if (decoded is! Map) return null;

    // Common: { accessToken: { access_token: "..." } }
    final accessToken = decoded['accessToken'];
    if (accessToken is Map) {
      final token = accessToken['access_token']?.toString().trim();
      if (token != null && token.isNotEmpty) return token;
    }
    if (accessToken is String) {
      final token = accessToken.trim();
      if (token.isNotEmpty) return token;
    }

    // Notes format: { token: { response: {...}, accessToken: { access_token: "..." } } }
    final tokenWrapper = decoded['token'];
    if (tokenWrapper is Map) {
      final nested = tokenWrapper['accessToken'];
      if (nested is Map) {
        final token = nested['access_token']?.toString().trim();
        if (token != null && token.isNotEmpty) return token;
      }
      if (nested is String) {
        final token = nested.trim();
        if (token.isNotEmpty) return token;
      }
    }

    return null;
  }

  static String? extractTempKey(dynamic decoded) {
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
}

