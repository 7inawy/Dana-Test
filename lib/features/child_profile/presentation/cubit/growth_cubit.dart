import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../parent_profile/data/models/parent_profile_model.dart';
import '../../../parent_profile/data/repo/parent_profile_repository.dart';
import '../../data/models/growth_record_model.dart';
import '../../data/repo/growth_repo.dart';
import '../../domain/growth_monthly.dart';
import 'growth_state.dart';

class GrowthCubit extends Cubit<GrowthState> {
  final GrowthRepo repo;
  final ParentProfileRepository parentRepo;

  GrowthCubit({required this.repo, required this.parentRepo})
    : super(const GrowthInitial());

  ParentChildModel? _pickChild(ParentProfileModel me, String? preferredId) {
    if (preferredId != null && preferredId.isNotEmpty) {
      for (final c in me.children) {
        if (c.id == preferredId) return c;
      }
    }
    return me.children.isNotEmpty ? me.children.first : null;
  }

  Future<void> load({String? childId}) async {
    emit(const GrowthLoading());
    try {
      final me = await parentRepo.getMe();
      final child = _pickChild(me, childId);
      final resolvedId = child?.id ?? '';
      final childName = child?.childName ?? '';
      if (resolvedId.isEmpty) throw Exception('No child found');

      final records = await repo.getRecords(childId: resolvedId);
      GrowthRecord? latest;
      try {
        latest = await repo.getLatest(childId: resolvedId);
      } catch (_) {
        latest = records.isNotEmpty
            ? (records..sort((a, b) => a.recordDate.compareTo(b.recordDate)))
                  .last
            : null;
      }
      emit(
        GrowthLoaded(
          childId: resolvedId,
          childName: childName,
          birthDate: child?.birthDate,
          gender: child?.gender ?? '',
          profileImageUrl: child?.profileImageUrl,
          records: records,
          latest: latest,
          children: me.children,
        ),
      );
    } catch (e) {
      emit(GrowthError(ErrorMapper.message(e)));
    }
  }

  /// Returns `null` on success, or a stable error code for the UI to localize.
  Future<String?> submit({
    required double height,
    required double weight,
    required double headCircumference,
    DateTime? recordDate,
  }) async {
    final current = state;
    if (current is! GrowthLoaded) {
      await load();
    }
    final st = state;
    if (st is! GrowthLoaded) return 'growthNotLoaded';

    final day = recordDate ?? DateTime.now();
    if (growthMonthlyBucketExists(st.records, day)) {
      return 'growthDuplicateMonth';
    }

    emit(const GrowthLoading());
    try {
      await repo.postRecord(
        childId: st.childId,
        height: height,
        weight: weight,
        headCircumference: headCircumference,
        recordDate: day,
      );
      final records = await repo.getRecords(childId: st.childId);
      GrowthRecord? latest;
      try {
        latest = await repo.getLatest(childId: st.childId);
      } catch (_) {
        latest = records.isNotEmpty
            ? (records..sort((a, b) => a.recordDate.compareTo(b.recordDate)))
                  .last
            : null;
      }
      final me = await parentRepo.getMe();
      emit(
        GrowthLoaded(
          childId: st.childId,
          childName: st.childName,
          birthDate: st.birthDate,
          gender: st.gender,
          profileImageUrl: st.profileImageUrl,
          records: records,
          latest: latest,
          children: me.children,
        ),
      );
      return null;
    } catch (e) {
      emit(GrowthError(ErrorMapper.message(e)));
      return 'growthSubmitFailed';
    }
  }
}
