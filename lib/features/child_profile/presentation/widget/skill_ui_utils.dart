import '../../data/models/skill_api_models.dart';

/// Up to four skills from the API: those with at least one checklist item first,
/// then the rest in server order (so the list is never empty just because totals are still 0).
List<SkillApiModel> visibleSkillsUpToFour(
  List<SkillApiModel> skills,
  Map<String, int> totalBySkillId,
) {
  if (skills.isEmpty) return const [];
  final withItems = skills
      .where((s) => (totalBySkillId[s.id] ?? 0) > 0)
      .toList();
  if (withItems.length >= 4) return withItems.take(4).toList();
  final seen = withItems.map((e) => e.id).toSet();
  final rest = skills.where((s) => !seen.contains(s.id));
  return [...withItems, ...rest].take(4).toList();
}
