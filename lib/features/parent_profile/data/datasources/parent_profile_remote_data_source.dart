import 'dart:io';

import '../models/parent_profile_model.dart';

abstract class ParentProfileRemoteDataSource {
  Future<ParentProfileModel> getMe();

  Future<ParentProfileModel> patchMe(Map<String, dynamic> body);

  Future<ParentChildModel> addChild({
    required String childName,
    required String gender,
    required DateTime birthDate,
  });

  Future<ParentChildModel> updateChild({
    required String childId,
    required String childName,
    required String gender,
    required DateTime birthDate,
    File? profileImage,
  });
}
