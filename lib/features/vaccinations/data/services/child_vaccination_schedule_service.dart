import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';
import '../models/child_vaccination_schedule_model.dart';

class ChildVaccinationScheduleService {
  final Dio dio;

  ChildVaccinationScheduleService(this.dio);

  Future<void> generateSchedule({required String childId}) async {
    await dio.post(
      '${ApiEndpoint.childVaccinationsGenerate}$childId/childVaccinations/generate',
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<List<ChildVaccinationScheduleItem>> getSchedule({
    required String childId,
  }) async {
    final res = await dio.get(
      '${ApiEndpoint.childVaccinations}$childId/childVaccinations',
    );
    final data = res.data;

    // Postman examples show a plain array response for this endpoint.
    final list = data is List
        ? data
        : (data is Map &&
              data['response'] is Map &&
              (data['response'] as Map)['data'] is List)
        ? (data['response'] as Map)['data'] as List
        : null;

    if (list == null) {
      throw const FormatException(
        'Unexpected vaccination schedule response shape',
      );
    }

    return list
        .whereType<Map>()
        .map(
          (e) =>
              ChildVaccinationScheduleItem.fromJson(e.cast<String, dynamic>()),
        )
        .toList();
  }
}
