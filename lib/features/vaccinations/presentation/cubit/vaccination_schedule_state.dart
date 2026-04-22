import '../../data/models/child_vaccination_schedule_model.dart';

sealed class VaccinationScheduleState {
  const VaccinationScheduleState();
}

class VaccinationScheduleInitial extends VaccinationScheduleState {
  const VaccinationScheduleInitial();
}

class VaccinationScheduleLoading extends VaccinationScheduleState {
  const VaccinationScheduleLoading();
}

class VaccinationScheduleLoaded extends VaccinationScheduleState {
  final String childId;
  final List<ChildVaccinationScheduleItem> items;

  const VaccinationScheduleLoaded({required this.childId, required this.items});
}

class VaccinationScheduleError extends VaccinationScheduleState {
  final String message;
  const VaccinationScheduleError(this.message);
}
