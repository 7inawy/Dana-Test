import 'package:dana/core/api/api_error.dart';
import 'package:dana/core/api/api_response.dart';
import 'package:dana/core/errors/exceptions.dart';
import 'package:dio/dio.dart';

/// Internal helper to keep Dio/decoding/error handling consistent.
///
/// This is intentionally small and framework-agnostic: it doesn't know about
/// specific auth endpoints, only how to send requests and map errors.
class AuthApiClient {
  static const Map<String, dynamic> _jsonHeaders = <String, dynamic>{
    'Content-Type': 'application/json',
  };

  final Dio dio;

  const AuthApiClient(this.dio);

  bool _isSuccessStatus(int? statusCode) =>
      statusCode != null && statusCode >= 200 && statusCode < 300;

  dynamic decode(dynamic raw) => ApiResponse.decode(raw);

  void throwIfNotSuccess(
    dynamic decoded,
    int? statusCode, {
    required String fallback,
  }) {
    if (_isSuccessStatus(statusCode)) return;
    final msg = ApiError.messageFromDecoded(decoded, fallback: fallback);
    throw ServerException(message: msg);
  }

  ServerException mapDioException(DioException e, {required String fallback}) {
    final decoded = decode(e.response?.data);
    return ServerException(
      message: ApiError.messageFromDecoded(decoded, fallback: fallback),
    );
  }

  Future<Response<dynamic>> postJson(
    String path, {
    required Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    bool followRedirects = true,
    bool Function(int?)? validateStatus,
  }) {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: {..._jsonHeaders, if (headers != null) ...headers},
        followRedirects: followRedirects,
        validateStatus: validateStatus,
      ),
    );
  }

  Future<Response<dynamic>> getRaw(
    String path, {
    Map<String, dynamic>? queryParameters,
    required Options options,
  }) {
    return dio.get(path, queryParameters: queryParameters, options: options);
  }
}

