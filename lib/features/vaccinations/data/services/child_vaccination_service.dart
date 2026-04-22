import 'package:dio/dio.dart';

class ChildVaccinationService {
  final Dio dio;

  ChildVaccinationService(this.dio);

  Future<Response> markVaccineTaken({
    required String childId,
    required String vaccinationId,
    required DateTime takenDate,
  }) {
    return dio.patch(
      '/v1/child/$childId/childVaccinations/$vaccinationId/take',
      data: {'takenDate': takenDate.toUtc().toIso8601String()},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }
}
