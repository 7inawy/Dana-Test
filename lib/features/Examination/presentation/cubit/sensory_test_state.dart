import '../../data/model/sensory_test_models.dart';

sealed class SensoryTestState {
  const SensoryTestState();
}

class SensoryTestInitial extends SensoryTestState {
  const SensoryTestInitial();
}

class SensoryTestLoading extends SensoryTestState {
  const SensoryTestLoading();
}

class SensoryTestLoaded extends SensoryTestState {
  final List<SensoryQuestion> questions;
  const SensoryTestLoaded(this.questions);
}

class SensoryTestSubmitting extends SensoryTestState {
  final List<SensoryQuestion> questions;
  const SensoryTestSubmitting(this.questions);
}

class SensoryTestSubmitted extends SensoryTestState {
  final SensoryTestResult result;
  const SensoryTestSubmitted(this.result);
}

class SensoryTestSubmitError extends SensoryTestState {
  final List<SensoryQuestion> questions;
  final String message;
  const SensoryTestSubmitError(this.questions, this.message);
}

class SensoryTestError extends SensoryTestState {
  final String message;
  const SensoryTestError(this.message);
}
