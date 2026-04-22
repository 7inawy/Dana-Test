import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../parent_profile/data/repo/parent_profile_repository.dart';
import '../../data/model/sensory_test_models.dart';
import '../../data/repo/sensory_test_repo.dart';
import 'sensory_test_state.dart';

class SensoryTestCubit extends Cubit<SensoryTestState> {
  final SensoryTestRepo repo;
  final ParentProfileRepository parentRepo;

  SensoryTestCubit({required this.repo, required this.parentRepo})
    : super(const SensoryTestInitial());

  Future<void> loadQuestions() async {
    emit(const SensoryTestLoading());
    try {
      final questions = await repo.getQuestions();
      emit(SensoryTestLoaded(questions));
    } catch (e) {
      emit(SensoryTestError(ErrorMapper.message(e)));
    }
  }

  Future<SensoryTestResult?> submit(
    Map<String, int> answersByQuestionId,
  ) async {
    final current = state;
    final questions = current is SensoryTestLoaded
        ? current.questions
        : current is SensoryTestSubmitting
        ? current.questions
        : <SensoryQuestion>[];
    emit(SensoryTestSubmitting(questions));

    try {
      final me = await parentRepo.getMe();
      final childId = me.children.isNotEmpty ? me.children.first.id : '';
      if (childId.isEmpty) throw Exception('No child found');

      final answers = answersByQuestionId.entries
          .map(
            (e) => SensoryTestAnswer(questionId: e.key, selectedValue: e.value),
          )
          .toList();

      final result = await repo.submit(childId: childId, answers: answers);
      emit(SensoryTestSubmitted(result));
      return result;
    } catch (e) {
      emit(SensoryTestSubmitError(questions, ErrorMapper.message(e)));
      return null;
    }
  }
}
