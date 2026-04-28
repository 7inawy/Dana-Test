import '../models/skill_api_models.dart';
import '../services/skills_service.dart';

class SkillsRepo {
  final SkillsService service;

  SkillsRepo(this.service);

  Future<List<SkillApiModel>> getSkills() => service.getSkills();

  Future<List<SkillChecklistItemApiModel>> getChecklist({
    required String skillId,
    required String childId,
  }) => service.getChecklist(skillId: skillId, childId: childId);

  Future<void> toggleItem({
    required String childId,
    required String itemId,
    required bool checked,
  }) => service.toggleItem(childId: childId, itemId: itemId, checked: checked);
}
