import '../../data/models/skill_api_models.dart';

sealed class SkillsState {
  const SkillsState();
}

class SkillsInitial extends SkillsState {
  const SkillsInitial();
}

class SkillsLoading extends SkillsState {
  const SkillsLoading();
}

class SkillsLoaded extends SkillsState {
  final String childId;
  final List<SkillApiModel> skills;

  /// Checked item count per skill id (from checklist API).
  final Map<String, int> skillCheckedById;

  /// Total checklist items per skill id.
  final Map<String, int> skillTotalById;

  const SkillsLoaded({
    required this.childId,
    required this.skills,
    this.skillCheckedById = const {},
    this.skillTotalById = const {},
  });
}

class ChecklistLoading extends SkillsState {
  final String childId;
  final List<SkillApiModel> skills;
  final String skillId;
  final Map<String, int> skillCheckedById;
  final Map<String, int> skillTotalById;

  const ChecklistLoading({
    required this.childId,
    required this.skills,
    required this.skillId,
    this.skillCheckedById = const {},
    this.skillTotalById = const {},
  });
}

class ChecklistLoaded extends SkillsState {
  final String childId;
  final List<SkillApiModel> skills;
  final String skillId;
  final List<SkillChecklistItemApiModel> items;
  final Map<String, int> skillCheckedById;
  final Map<String, int> skillTotalById;

  const ChecklistLoaded({
    required this.childId,
    required this.skills,
    required this.skillId,
    required this.items,
    this.skillCheckedById = const {},
    this.skillTotalById = const {},
  });
}

class SkillsError extends SkillsState {
  final String message;
  const SkillsError(this.message);
}
