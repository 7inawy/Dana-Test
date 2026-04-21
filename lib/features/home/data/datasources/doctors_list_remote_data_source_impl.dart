import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/public_doctor_model.dart';
import 'doctors_list_remote_data_source.dart';

class DoctorsListRemoteDataSourceImpl implements DoctorsListRemoteDataSource {
  DoctorsListRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  dynamic _decode(dynamic raw) => raw is String ? jsonDecode(raw) : raw;

  dynamic _payload(dynamic decoded) {
    if (decoded is Map && decoded['response'] is Map) {
      return (decoded['response'] as Map)['data'];
    }
    if (decoded is Map) return decoded['data'];
    return null;
  }

  List<Map<String, dynamic>> _asDoctorMapList(dynamic payload) {
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    }
    if (payload is Map<String, dynamic>) {
      return [payload];
    }
    if (payload is Map) {
      return [payload.cast<String, dynamic>()];
    }
    return const [];
  }

  @override
  Future<List<PublicDoctorModel>> fetchDoctors() async {
    try {
      final res = await dio.get(ApiEndpoint.getAllDoctors);
      final decoded = _decode(res.data);
      final payload = _payload(decoded);
      return _asDoctorMapList(payload)
          .map(PublicDoctorModel.fromJson)
          .where((d) => d.id.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      final decoded = _decode(e.response?.data);
      final msg = (decoded is Map ? decoded['message'] : null)?.toString();
      throw ServerException(message: msg ?? 'Failed to load doctors');
    }
  }
}
