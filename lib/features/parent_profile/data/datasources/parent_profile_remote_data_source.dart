import 'dart:io';

import '../models/parent_profile_model.dart';

abstract class ParentProfileRemoteDataSource {
  Future<ParentProfileModel> getMe();

  /// Requests an OTP SMS to [phone] (normalized) for a pending phone update.
  Future<void> sendPhoneChangeOtp({required String phone});

  Future<ParentProfileModel> patchMe(Map<String, dynamic> body);

  Future<ParentProfileModel> patchMeWithOptionalFile({
    required Map<String, dynamic> bodyJson,
    File? file,
  });

  /// note 2: profile image upload is a dedicated endpoint.
  Future<void> addParentProfileImage({
    required String parentId,
    required File file,
  });

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
