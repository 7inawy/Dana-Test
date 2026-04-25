import '../log/debug_audit_log.dart';

/// Helpers to normalize inconsistent backend response envelopes.
///
/// Supported shapes:
/// - Plain list: `[...]`
/// - Plain map: `{...}`
/// - Data envelope: `{ data: ... }`
/// - Response envelope: `{ response: { data: ... } }`

class ResponseUnwrap {
  ResponseUnwrap._();

  static dynamic unwrap(dynamic root) {
    if (root is Map) {
      final response = root['response'];
      if (response is Map && response.containsKey('data'))
        return response['data'];
      if (root.containsKey('data')) return root['data'];
    }
    return root;
  }

  static List unwrapList(dynamic root) {
    final unwrapped = unwrap(root);
    if (unwrapped is List) return unwrapped;
    DebugAuditLog.log(
      runId: 'pre-fix',
      hypothesisId: 'H4',
      location: 'lib/core/api/response_unwrap.dart:unwrapList',
      message: 'Unexpected response shape (expected list)',
      data: {'rootType': root.runtimeType.toString(), 'unwrappedType': unwrapped.runtimeType.toString()},
    );
    throw const FormatException('Unexpected response shape: expected list');
  }

  static Map unwrapMap(dynamic root) {
    final unwrapped = unwrap(root);
    if (unwrapped is Map) return unwrapped;
    DebugAuditLog.log(
      runId: 'pre-fix',
      hypothesisId: 'H4',
      location: 'lib/core/api/response_unwrap.dart:unwrapMap',
      message: 'Unexpected response shape (expected map)',
      data: {'rootType': root.runtimeType.toString(), 'unwrappedType': unwrapped.runtimeType.toString()},
    );
    throw const FormatException('Unexpected response shape: expected map');
  }
}
