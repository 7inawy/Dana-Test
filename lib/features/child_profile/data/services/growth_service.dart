import 'package:dio/dio.dart';

import '../models/growth_record_model.dart';

class GrowthService {
  final Dio dio;

  GrowthService(this.dio);

  Future<List<GrowthRecord>> getRecords({required String childId}) async {
    final res = await dio.get('/v1/child/$childId/growth');
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map &&
              data['response'] is Map &&
              (data['response'] as Map)['data'] is List)
        ? (data['response'] as Map)['data'] as List
        : null;
    if (list == null)
      throw const FormatException('Unexpected growth records response shape');
    return list
        .whereType<Map>()
        .map((e) => GrowthRecord.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<GrowthRecord> getLatest({required String childId}) async {
    final res = await dio.get('/v1/child/$childId/growth/latest');
    final data = res.data;
    if (data is Map && data['data'] is Map) {
      return GrowthRecord.fromJson(
        (data['data'] as Map).cast<String, dynamic>(),
      );
    }
    if (data is Map) return GrowthRecord.fromJson(data.cast<String, dynamic>());
    throw const FormatException('Unexpected latest growth response shape');
  }

  Future<GrowthRecord> postRecord({
    required String childId,
    required double height,
    required double weight,
    required double headCircumference,
    required DateTime recordDate,
  }) async {
    final res = await dio.post(
      '/v1/child/$childId/growth',
      data: {
        'height': height,
        'weight': weight,
        'headCircumference': headCircumference,
        'recordDate':
            '${recordDate.year.toString().padLeft(4, '0')}-${recordDate.month.toString().padLeft(2, '0')}-${recordDate.day.toString().padLeft(2, '0')}',
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    final data = res.data;
    if (data is Map && data['data'] is Map) {
      return GrowthRecord.fromJson(
        (data['data'] as Map).cast<String, dynamic>(),
      );
    }
    if (data is Map) return GrowthRecord.fromJson(data.cast<String, dynamic>());
    throw const FormatException('Unexpected post growth response shape');
  }
}
