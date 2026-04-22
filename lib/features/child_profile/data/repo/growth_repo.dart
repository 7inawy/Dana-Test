import '../models/growth_record_model.dart';
import '../services/growth_service.dart';

class GrowthRepo {
  final GrowthService service;

  GrowthRepo(this.service);

  Future<List<GrowthRecord>> getRecords({required String childId}) =>
      service.getRecords(childId: childId);

  Future<GrowthRecord> getLatest({required String childId}) =>
      service.getLatest(childId: childId);

  Future<GrowthRecord> postRecord({
    required String childId,
    required double height,
    required double weight,
    required double headCircumference,
    required DateTime recordDate,
  }) => service.postRecord(
    childId: childId,
    height: height,
    weight: weight,
    headCircumference: headCircumference,
    recordDate: recordDate,
  );
}
