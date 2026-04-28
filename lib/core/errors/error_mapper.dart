import 'package:dio/dio.dart';

import 'exceptions.dart';

class ErrorMapper {
  ErrorMapper._();

  static String message(Object error) {
    if (error is ServerException) return error.message;
    if (error is FormatException) return error.message;

    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final msg = data['message'];
        if (msg != null) return msg.toString();
        final response = data['response'];
        if (response is Map && response['message'] != null) {
          return response['message'].toString();
        }
      }
      return error.message ?? 'Network error';
    }

    return error.toString();
  }
}
