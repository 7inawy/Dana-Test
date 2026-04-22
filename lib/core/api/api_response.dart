import 'dart:convert';

import '../errors/exceptions.dart';

class ApiResponse {
  ApiResponse._();

  static dynamic decode(dynamic raw) => raw is String ? jsonDecode(raw) : raw;

  /// Unwraps common backend envelopes into a JSON map.
  ///
  /// Supported:
  /// - `{ response: { data: {...} } }`
  /// - `{ status, message, data: {...} }`
  /// - `{ ... }` (already a map)
  static Map<String, dynamic> unwrapMap(dynamic decoded) {
    if (decoded is Map) {
      final response = decoded['response'];
      if (response is Map && response['data'] is Map) {
        return (response['data'] as Map).cast<String, dynamic>();
      }
      final data = decoded['data'];
      if (data is Map) return data.cast<String, dynamic>();
      return decoded.cast<String, dynamic>();
    }
    throw const ServerException(message: 'Unexpected response shape');
  }

  /// Unwraps common backend envelopes into a JSON list.
  ///
  /// Supported:
  /// - `{ response: { data: [...] } }`
  /// - `{ status, message, data: [...] }`
  /// - `[...]` (already a list)
  static List<dynamic> unwrapList(dynamic decoded) {
    if (decoded is Map) {
      final response = decoded['response'];
      if (response is Map && response['data'] is List) {
        return response['data'] as List;
      }
      final data = decoded['data'];
      if (data is List) return data;
    }
    if (decoded is List) return decoded;
    throw const ServerException(message: 'Unexpected response shape');
  }
}
