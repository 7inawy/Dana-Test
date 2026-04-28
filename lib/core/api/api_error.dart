import 'package:dio/dio.dart';

class ApiError {
  ApiError._();

  static String messageFromDecoded(
    dynamic decoded, {
    required String fallback,
  }) {
    if (decoded is Map) {
      final msg = decoded['message'];
      if (msg != null) return msg.toString();

      final response = decoded['response'];
      if (response is Map && response['message'] != null) {
        return response['message'].toString();
      }

      final errors = decoded['errors'];
      if (errors is List && errors.isNotEmpty) return errors.first.toString();
      if (errors is Map && errors.isNotEmpty) {
        final v = errors.values.first;
        return v is List ? v.first.toString() : v.toString();
      }
    }
    return fallback;
  }

  static String messageFromDio(
    DioException e, {
    required String fallback,
    required dynamic Function(dynamic raw) decode,
  }) {
    final decoded = decode(e.response?.data);
    return messageFromDecoded(decoded, fallback: fallback);
  }
}
