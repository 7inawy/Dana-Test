import 'package:dio/dio.dart';

class ApiManger {
  final Dio dio;

  ApiManger(this.dio);

  Future<Response> getData({
    required String endPoint,
    Map<String, dynamic>? qureyParmetes,
    Map<String, dynamic>? headers,
  }) {
    return dio.get(
      endPoint,
      queryParameters: qureyParmetes,
      options: Options(headers: headers),
    );
  }

  Future<Response> postData({
    required String endPoint,
    Map<String, dynamic>? qureyParmetes,
    Object? body,
    Map<String, dynamic>? headers,
  }) {
    return dio.post(
      endPoint,
      queryParameters: qureyParmetes,
      data: body,
      options: Options(headers: headers),
    );
  }
}
