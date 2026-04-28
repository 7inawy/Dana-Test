import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';

class ChildVaccinationService {
  final Dio dio;

  ChildVaccinationService(this.dio);

  Future<Response> markVaccineTaken({
    required String childId,
    required String vaccinationId,
    required DateTime takenDate,
  }) {
    return dio.patch(
      ApiEndpoint.childVaccinationTakePath(childId, vaccinationId),
      data: {'takenDate': takenDate.toUtc().toIso8601String()},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }
}
