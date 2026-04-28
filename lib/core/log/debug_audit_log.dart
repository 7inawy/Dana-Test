import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Debug-mode audit logger (NDJSON) for Cursor debug sessions.
///
/// Writes to `debug-c17967.log` in the app documents directory.
class DebugAuditLog {
  DebugAuditLog._();

  static const String _fileName = 'debug-c17967.log';
  static String? _resolvedPath;
  static const String _ingestPath = '/ingest/04ab7b94-97ee-4aab-8890-77e58fff42d6';

  static Future<void> init() async {
    // #region agent log
    try {
      final dir = await getApplicationDocumentsDirectory();
      _resolvedPath = '${dir.path}${Platform.pathSeparator}$_fileName';
    } catch (_) {
      _resolvedPath = _fileName;
    }
    // #endregion
  }

  static Uri _preferredIngestUri() {
    // Prefer emulator-friendly host loopback when running on Android.
    if (Platform.isAndroid) {
      return Uri.parse('http://10.0.2.2:7806$_ingestPath');
    }
    return Uri.parse('http://127.0.0.1:7806$_ingestPath');
  }

  static void log({
    required String runId,
    required String hypothesisId,
    required String location,
    required String message,
    Map<String, Object?>? data,
  }) {
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

      // Best-effort HTTP ingest (works when the app can reach host loopback).
      try {
        final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 250);
        final uri = _preferredIngestUri();
        client.postUrl(uri).then((req) {
          req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
          req.headers.set('X-Debug-Session-Id', 'c17967');
          req.write(jsonEncode(payload));
          return req.close();
        }).then((res) => res.drain<void>()).catchError((_) {});
      } catch (_) {}
    } catch (_) {
      // Never crash the app due to audit logging.
    }
    // #endregion
  }
}

