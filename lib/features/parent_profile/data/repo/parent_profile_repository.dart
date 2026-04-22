import 'dart:io';

import 'package:dana/core/utils/parent_phone_utils.dart';

import '../datasources/parent_profile_remote_data_source.dart';
import '../models/parent_profile_model.dart';

class ParentProfileRepository {
  final ParentProfileRemoteDataSource remote;

  ParentProfileRepository(this.remote);

  Future<ParentProfileModel> getMe() => remote.getMe();

  Future<ParentProfileModel> updateProfile({
    required String parentName,
    required String email,
    required String phone,
    required String government,
    required String address,
  }) => remote.patchMe({
    'parentName': parentName.trim(),
    'email': email.trim().toLowerCase(),
    'phone': ParentPhoneUtils.normalizeForApi(phone),
    'government': government.trim(),
    'address': address.trim(),
  });

  Future<ParentChildModel> addChild({
    required String childName,
    required String gender,
    required DateTime birthDate,
  }) => remote.addChild(
    childName: childName,
    gender: gender,
    birthDate: birthDate,
  );

  Future<ParentChildModel> updateChild({
    required String childId,
    required String childName,
    required String gender,
    required DateTime birthDate,
    File? profileImage,
  }) => remote.updateChild(
    childId: childId,
    childName: childName,
    gender: gender,
    birthDate: birthDate,
    profileImage: profileImage,
  );
}
