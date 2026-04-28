import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';
import '../models/child_vaccination_schedule_model.dart';

class VaccinationsCatalogService {
  final Dio dio;

  VaccinationsCatalogService(this.dio);

  /// GET /v1/vaccinations — master vaccine definitions (Postman: plain array or wrapped list).
  Future<List<VaccineDefinition>> getMasterVaccines() async {
    final res = await dio.get(ApiEndpoint.vaccinations);
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map && data['data'] is List)
        ? data['data'] as List
        : (data is Map &&
              data['response'] is Map &&
              (data['response'] as Map)['data'] is List)
        ? (data['response'] as Map)['data'] as List
        : null;
    if (list == null) {
      throw const FormatException('Unexpected vaccinations catalog response shape');
    }
    return list
        .whereType<Map>()
        .map((e) => VaccineDefinition.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
