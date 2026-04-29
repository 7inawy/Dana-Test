import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../config/app_config.dart';

/// Debug-mode audit logger (NDJSON) for Cursor debug sessions.
///
/// Writes to `debug-c17967.log` in the app documents directory.
class DebugAuditLog {
  DebugAuditLog._();

  static const String _fileName = 'debug-c17967.log';
  static String? _resolvedPath;
  static const String _ingestPath =
      '/ingest/04ab7b94-97ee-4aab-8890-77e58fff42d6';

  static bool get _enabled => !kReleaseMode && AppConfig.debugAuditEnabled;

  static Future<void> init() async {
    if (!_enabled) return;
    // #region agent log
    try {
      final dir = await getApplicationDocumentsDirectory();
      _resolvedPath = '${dir.path}${Platform.pathSeparator}$_fileName';
    } catch (_) {
      _resolvedPath = _fileName;
    }
    // #endregion
  }

  static Uri? _ingestUri() {
    final raw = AppConfig.debugAuditIngestUrl.trim();
    if (raw.isEmpty) return null;
    final u = Uri.tryParse(raw);
    if (u == null) return null;

    // Allow local HTTP only for explicit local dev usage.
    final isLocalHttp =
        (u.scheme == 'http') && (u.host == '127.0.0.1' || u.host == '10.0.2.2');
    if (isLocalHttp) return u.replace(path: _ingestPath);

    // Otherwise require HTTPS to avoid accidental plaintext leaks.
    if (u.scheme != 'https') return null;
    return u.replace(path: _ingestPath);
  }

  static void log({
    required String runId,
    required String hypothesisId,
    required String location,
    required String message,
    Map<String, Object?>? data,
  }) {
    if (!_enabled) return;
    // #region agent log
    try {
      final path = _resolvedPath ?? _fileName;
      final payload = <String, Object?>{
        'sessionId': 'c17967',
        'runId': runId,
        'hypothesisId': hypothesisId,
        'location': location,
        'message': message,
        'data': data ?? const <String, Object?>{},
        'logPath': path,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Best-effort local file (works for desktop runs).
      try {
        File(path).writeAsStringSync(
          '${jsonEncode(payload)}\n',
          mode: FileMode.append,
          flush: true,
        );
      } catch (_) {}

      // Optional ingest (explicitly configured).
      final ingest = _ingestUri();
      if (ingest != null) {
        try {
          final client = HttpClient()
            ..connectionTimeout = const Duration(milliseconds: 500);
          client.postUrl(ingest).then((req) {
            req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
            req.headers.set('X-Debug-Session-Id', 'c17967');
            req.write(jsonEncode(payload));
            return req.close();
          }).then((res) => res.drain<void>()).catchError((_) {});
        } catch (_) {}
      }
    } catch (_) {
      // Never crash the app due to audit logging.
    }
    // #endregion
  }
}

