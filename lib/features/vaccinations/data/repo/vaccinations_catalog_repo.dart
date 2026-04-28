import '../models/child_vaccination_schedule_model.dart';
import '../services/vaccinations_catalog_service.dart';

class VaccinationsCatalogRepo {
  final VaccinationsCatalogService service;

  VaccinationsCatalogRepo(this.service);

  Future<List<VaccineDefinition>> getMasterVaccines() =>
      service.getMasterVaccines();
}
