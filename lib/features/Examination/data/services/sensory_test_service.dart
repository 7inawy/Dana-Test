import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';
import '../model/sensory_test_models.dart';

class SensoryTestService {
  final Dio dio;

  SensoryTestService(this.dio);

  Future<List<SensoryQuestion>> getQuestions() async {
    final res = await dio.get(ApiEndpoint.sensoryTestList);
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map &&
              data['response'] is Map &&
              (data['response'] as Map)['data'] is List)
        ? (data['response'] as Map)['data'] as List
        : null;
    if (list == null) {
      throw const FormatException(
        'Unexpected sensory-test questions response shape',
      );
    }
    return list
        .whereType<Map>()
        .map((e) => SensoryQuestion.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<SensoryTestResult> submit({
    required String childId,
    required List<SensoryTestAnswer> answers,
  }) async {
    final res = await dio.post(
      ApiEndpoint.sensoryTestSubmit(childId),
      data: {'answers': answers.map((a) => a.toJson()).toList()},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    final data = res.data;
    if (data is Map) {
      return SensoryTestResult.fromJson(data.cast<String, dynamic>());
    }
    throw const FormatException(
      'Unexpected sensory-test submit response shape',
    );
  }
}
