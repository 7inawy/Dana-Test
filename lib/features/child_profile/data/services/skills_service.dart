import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';
import '../models/skill_api_models.dart';

class SkillsService {
  final Dio dio;

  SkillsService(this.dio);

  Future<List<SkillApiModel>> getSkills() async {
    final res = await dio.get(ApiEndpoint.skills);
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map &&
              data['response'] is Map &&
              (data['response'] as Map)['data'] is List)
        ? (data['response'] as Map)['data'] as List
        : null;
    if (list == null)
      throw const FormatException('Unexpected skills response shape');
    return list
        .whereType<Map>()
        .map((e) => SkillApiModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<List<SkillChecklistItemApiModel>> getChecklist({
    required String skillId,
    required String childId,
  }) async {
    final res = await dio.get(ApiEndpoint.skillsChecklist(skillId, childId));
    final data = res.data;
    final list = data is List
        ? data
        : (data is Map &&
              data['response'] is Map &&
              (data['response'] as Map)['data'] is List)
        ? (data['response'] as Map)['data'] as List
        : null;
    if (list == null)
      throw const FormatException('Unexpected checklist response shape');
    return list
        .whereType<Map>()
        .map(
          (e) => SkillChecklistItemApiModel.fromJson(e.cast<String, dynamic>()),
        )
        .toList();
  }

  Future<void> toggleItem({
    required String childId,
    required String itemId,
    required bool checked,
  }) async {
    await dio.post(
      ApiEndpoint.skillsToggleChild(childId),
      data: {'itemId': itemId, 'checked': checked},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }
}
