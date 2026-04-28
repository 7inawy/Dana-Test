import '../services/child_vaccination_service.dart';

class ChildVaccinationRepo {
  final ChildVaccinationService service;

  ChildVaccinationRepo(this.service);

  Future<void> markTaken({
    required String childId,
    required String vaccinationId,
    required DateTime takenDate,
  }) async {
    await service.markVaccineTaken(
      childId: childId,
      vaccinationId: vaccinationId,
      takenDate: takenDate,
    );
  }
}
