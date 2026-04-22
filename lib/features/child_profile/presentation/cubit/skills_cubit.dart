import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../parent_profile/data/models/parent_profile_model.dart';
import '../../../parent_profile/data/repo/parent_profile_repository.dart';
import '../../data/models/skill_api_models.dart';
import '../../data/repo/skills_repo.dart';
import 'skills_state.dart';

class SkillsCubit extends Cubit<SkillsState> {
  final SkillsRepo repo;
  final ParentProfileRepository parentRepo;

  SkillsCubit({required this.repo, required this.parentRepo})
      : super(const SkillsInitial());

  ParentChildModel? _pickChild(ParentProfileModel me, String? preferredId) {
    if (preferredId != null && preferredId.isNotEmpty) {
      for (final c in me.children) {
        if (c.id == preferredId) return c;
      }
    }
    return me.children.isNotEmpty ? me.children.first : null;
  }

  Future<({Map<String, int> checked, Map<String, int> total})> _progressMaps({
    required String childId,
    required List<SkillApiModel> skills,
  }) async {
    final checked = <String, int>{};
    final total = <String, int>{};
    await Future.wait(
      skills.map((s) async {
        try {
          final items = await repo.getChecklist(skillId: s.id, childId: childId);
          final c = items.where((e) => e.checked).length;
          checked[s.id] = c;
          total[s.id] = items.length;
        } catch (_) {
          checked[s.id] = 0;
          total[s.id] = 0;
        }
      }),
    );
    return (checked: checked, total: total);
  }

  Future<void> loadSkills({String? childId}) async {
    emit(const SkillsLoading());
    try {
      final me = await parentRepo.getMe();
      final child = _pickChild(me, childId);
      final resolvedId = child?.id ?? '';
      if (resolvedId.isEmpty) throw Exception('No child found');
      final skills = await repo.getSkills();
      final maps = await _progressMaps(childId: resolvedId, skills: skills);
      emit(
        SkillsLoaded(
          childId: resolvedId,
          skills: skills,
          skillCheckedById: maps.checked,
          skillTotalById: maps.total,
        ),
      );
    } catch (e) {
      emit(SkillsError(ErrorMapper.message(e)));
    }
  }

  Future<void> loadChecklist(String skillId) async {
    final current = state;
    if (current is! SkillsLoaded && current is! ChecklistLoaded) return;
    late final String childId;
    late final List<SkillApiModel> skills;
    late final Map<String, int> checkedMap;
    late final Map<String, int> totalMap;
    if (current is SkillsLoaded) {
      childId = current.childId;
      skills = current.skills;
      checkedMap = Map<String, int>.from(current.skillCheckedById);
      totalMap = Map<String, int>.from(current.skillTotalById);
    } else {
      final cl = current as ChecklistLoaded;
      childId = cl.childId;
      skills = cl.skills;
      checkedMap = Map<String, int>.from(cl.skillCheckedById);
      totalMap = Map<String, int>.from(cl.skillTotalById);
    }

    emit(
      ChecklistLoading(
        childId: childId,
        skills: skills,
        skillId: skillId,
        skillCheckedById: checkedMap,
        skillTotalById: totalMap,
      ),
    );
    try {
      final items = await repo.getChecklist(skillId: skillId, childId: childId);
      final done = items.where((e) => e.checked).length;
      checkedMap[skillId] = done;
      totalMap[skillId] = items.length;
      emit(
        ChecklistLoaded(
          childId: childId,
          skills: skills,
          skillId: skillId,
          items: items,
          skillCheckedById: checkedMap,
          skillTotalById: totalMap,
        ),
      );
    } catch (e) {
      emit(SkillsError(ErrorMapper.message(e)));
    }
  }

  Future<void> toggle({
    required String skillId,
    required String itemId,
    required bool checked,
  }) async {
    final current = state;
    if (current is! ChecklistLoaded) return;
    try {
      await repo.toggleItem(childId: current.childId, itemId: itemId, checked: checked);
      final items = await repo.getChecklist(skillId: skillId, childId: current.childId);
      final done = items.where((e) => e.checked).length;
      final checkedMap = Map<String, int>.from(current.skillCheckedById);
      final totalMap = Map<String, int>.from(current.skillTotalById);
      checkedMap[skillId] = done;
      totalMap[skillId] = items.length;
      emit(
        ChecklistLoaded(
          childId: current.childId,
          skills: current.skills,
          skillId: skillId,
          items: items,
          skillCheckedById: checkedMap,
          skillTotalById: totalMap,
        ),
      );
    } catch (e) {
      emit(SkillsError(ErrorMapper.message(e)));
    }
  }
}
