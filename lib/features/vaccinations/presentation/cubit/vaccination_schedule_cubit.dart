import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../parent_profile/data/models/parent_profile_model.dart';
import '../../../parent_profile/data/repo/parent_profile_repository.dart';
import '../../data/repo/child_vaccination_repo.dart';
import '../../data/repo/child_vaccination_schedule_repo.dart';
import 'vaccination_schedule_state.dart';

class VaccinationScheduleCubit extends Cubit<VaccinationScheduleState> {
  final ParentProfileRepository parentRepo;
  final ChildVaccinationScheduleRepo scheduleRepo;
  final ChildVaccinationRepo vaccinationRepo;

  VaccinationScheduleCubit({
    required this.parentRepo,
    required this.scheduleRepo,
    required this.vaccinationRepo,
  }) : super(const VaccinationScheduleInitial());

  ParentChildModel? _pickChild(ParentProfileModel me, String? preferredId) {
    if (preferredId != null && preferredId.isNotEmpty) {
      for (final c in me.children) {
        if (c.id == preferredId) return c;
      }
    }
    return me.children.isNotEmpty ? me.children.first : null;
  }

  Future<void> load({String? childId}) async {
    emit(const VaccinationScheduleLoading());
    try {
      final me = await parentRepo.getMe();
      final child = _pickChild(me, childId);
      final resolvedId = child?.id ?? '';
      if (resolvedId.isEmpty) {
        throw Exception('No child found for this parent');
      }
      final items = await scheduleRepo.getSchedule(childId: resolvedId);
      emit(VaccinationScheduleLoaded(childId: resolvedId, items: items));
    } catch (e) {
      emit(VaccinationScheduleError(e.toString()));
    }
  }

  Future<void> generateAndLoad({String? childId}) async {
    emit(const VaccinationScheduleLoading());
    try {
      final me = await parentRepo.getMe();
      final child = _pickChild(me, childId);
      final resolvedId = child?.id ?? '';
      if (resolvedId.isEmpty) {
        throw Exception('No child found for this parent');
      }
      await scheduleRepo.generateSchedule(childId: resolvedId);
      final items = await scheduleRepo.getSchedule(childId: resolvedId);
      emit(VaccinationScheduleLoaded(childId: resolvedId, items: items));
    } catch (e) {
      emit(VaccinationScheduleError(e.toString()));
    }
  }

  Future<void> markTaken({
    required String childId,
    required String vaccinationId,
    required DateTime takenDate,
  }) async {
    emit(const VaccinationScheduleLoading());
    try {
      await vaccinationRepo.markTaken(
        childId: childId,
        vaccinationId: vaccinationId,
        takenDate: takenDate,
      );
      final items = await scheduleRepo.getSchedule(childId: childId);
      emit(VaccinationScheduleLoaded(childId: childId, items: items));
    } catch (e) {
      emit(VaccinationScheduleError(e.toString()));
    }
  }
}
