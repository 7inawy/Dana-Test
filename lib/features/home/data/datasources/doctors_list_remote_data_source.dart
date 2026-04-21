import '../models/public_doctor_model.dart';

abstract class DoctorsListRemoteDataSource {
  Future<List<PublicDoctorModel>> fetchDoctors();
}
