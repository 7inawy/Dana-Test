import '../model/sensory_test_models.dart';
import '../services/sensory_test_service.dart';

class SensoryTestRepo {
  final SensoryTestService service;

  SensoryTestRepo(this.service);

  Future<List<SensoryQuestion>> getQuestions() => service.getQuestions();

  Future<SensoryTestResult> submit({
    required String childId,
    required List<SensoryTestAnswer> answers,
  }) => service.submit(childId: childId, answers: answers);
}
