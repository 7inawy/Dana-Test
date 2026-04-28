import '../models/child_vaccination_schedule_model.dart';
import '../services/child_vaccination_schedule_service.dart';

class ChildVaccinationScheduleRepo {
  final ChildVaccinationScheduleService service;

  ChildVaccinationScheduleRepo(this.service);

  Future<void> generateSchedule({required String childId}) =>
      service.generateSchedule(childId: childId);

  Future<List<ChildVaccinationScheduleItem>> getSchedule({
    required String childId,
  }) => service.getSchedule(childId: childId);
}
