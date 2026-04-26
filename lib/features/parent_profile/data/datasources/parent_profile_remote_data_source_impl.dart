import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';
import '../../../../core/api/api_error.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/parent_profile_model.dart';
import 'parent_profile_remote_data_source.dart';

class ParentProfileRemoteDataSourceImpl
    implements ParentProfileRemoteDataSource {
  final Dio dio;

  ParentProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ParentProfileModel> patchMe(Map<String, dynamic> body) async {
    try {
      final res = await dio.patch(
        ApiEndpoint.parentMe,
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final decoded = ApiResponse.decode(res.data);
      final data = ApiResponse.unwrapMap(decoded);
      return ParentProfileModel.fromJson(data);
    } on DioException catch (e) {
      final msg = ApiError.messageFromDio(
        e,
        fallback: 'Failed to update profile',
        decode: ApiResponse.decode,
      );
      throw ServerException(message: msg);
    }
  }

  @override
  Future<ParentProfileModel> patchMeWithOptionalFile({
    required Map<String, dynamic> bodyJson,
    File? file,
  }) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode(bodyJson),
        if (file != null)
          'file': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split(RegExp(r'[\\/]')).last,
          ),
      });
      final res = await dio.patch(ApiEndpoint.parentMe, data: formData);
      final decoded = ApiResponse.decode(res.data);
      final data = ApiResponse.unwrapMap(decoded);
      return ParentProfileModel.fromJson(data);
    } on DioException catch (e) {
      final msg = ApiError.messageFromDio(
        e,
        fallback: 'Failed to update profile',
        decode: ApiResponse.decode,
      );
      throw ServerException(message: msg);
    }
  }

  @override
  Future<ParentProfileModel> getMe() async {
    try {
      final res = await dio.get(ApiEndpoint.parentMe);
      final decoded = ApiResponse.decode(res.data);
      final data = ApiResponse.unwrapMap(decoded);
      return ParentProfileModel.fromJson(data);
    } on DioException catch (e) {
      final msg = ApiError.messageFromDio(
        e,
        fallback: 'Failed to load profile',
        decode: ApiResponse.decode,
      );
      throw ServerException(message: msg);
    }
  }

  @override
  Future<void> addParentProfileImage({
    required String parentId,
    required File file,
  }) async {
    try {
      final fd = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(RegExp(r'[\\/]')).last,
        ),
      });
      await dio.patch(ApiEndpoint.parentAddProfileImagePath(parentId), data: fd);
    } on DioException catch (e) {
      final msg = ApiError.messageFromDio(
        e,
        fallback: 'Failed to upload profile image',
        decode: ApiResponse.decode,
      );
      throw ServerException(message: msg);
    }
  }

  /// POST /addChild may return a full parent, a nested child map, or a minimal body
  /// while the child is still persisted. When we cannot parse a child from the body,
  /// [getMe] is used so the client matches the server (same as app refresh).
  ParentChildModel? _childFromAddChildBody(Map<String, dynamic> data) {
    final fromParent = ParentProfileModel.fromJson(data);
    if (fromParent.children.isNotEmpty) {
      return fromParent.children.last;
    }
    for (final key in <String>['child', 'newChild', 'createdChild']) {
      final v = data[key];
      if (v is Map) {
        try {
          return ParentChildModel.fromJson(v.cast<String, dynamic>());
        } catch (_) {}
      }
    }
    if (data['childName'] != null &&
        data['_id'] != null &&
        data['children'] == null) {
      return ParentChildModel.fromJson(data);
    }
    return null;
  }

  ParentChildModel _pickChildFromProfile(
    ParentProfileModel profile, {
    required String childName,
    required String gender,
    required DateTime birthDate,
  }) {
    bool sameCalendarDay(DateTime? a, DateTime b) {
      if (a == null) return false;
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    final wantName = childName.trim();
    final wantGender = gender.toLowerCase();
    for (final c in profile.children) {
      if (c.childName.trim() == wantName &&
          c.gender.toLowerCase() == wantGender &&
          sameCalendarDay(c.birthDate, birthDate)) {
        return c;
      }
    }
    return profile.children.last;
  }

  @override
  Future<ParentChildModel> addChild({
    required String childName,
    required String gender,
    required DateTime birthDate,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoint.parentAddChild,
        data: {
          'childName': childName,
          'gender': gender,
          'birthDate': birthDate.toIso8601String(),
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final decoded = ApiResponse.decode(res.data);
      final data = ApiResponse.unwrapMap(decoded);
      final fromBody = _childFromAddChildBody(data);
      if (fromBody != null) return fromBody;

      final refreshed = await getMe();
      if (refreshed.children.isEmpty) {
        throw const ServerException(message: 'Child was not created');
      }
      return _pickChildFromProfile(
        refreshed,
        childName: childName,
        gender: gender,
        birthDate: birthDate,
      );
    } on DioException catch (e) {
      final msg = ApiError.messageFromDio(
        e,
        fallback: 'Failed to add child',
        decode: ApiResponse.decode,
      );
      throw ServerException(message: msg);
    }
  }

  @override
  Future<ParentChildModel> updateChild({
    required String childId,
    required String childName,
    required String gender,
    required DateTime birthDate,
    File? profileImage,
  }) async {
    try {
      final payload = {
        'childName': childName,
        'gender': gender,
        'birthDate': birthDate.toIso8601String(),
      };
      final res = await dio.patch(
        '${ApiEndpoint.parentUpdateChild}$childId',
        data: payload,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final decoded = ApiResponse.decode(res.data);
      final data = ApiResponse.unwrapMap(decoded);
      // Backend may return either:
      // - a full parent profile (with `children: [...]`)
      // - or the updated child object directly (common): `{ _id, childName, ... }`
      ParentChildModel child;
      if (data['children'] is List) {
        final children = ParentProfileModel.fromJson(data).children;
        final updated = children.where((c) => c.id == childId).toList();
        if (updated.isEmpty) {
          throw const ServerException(message: 'Child was not updated');
        }
        child = updated.first;
      } else {
        child = ParentChildModel.fromJson(data);
        if (child.id.isEmpty) {
          throw const ServerException(message: 'Child was not updated');
        }
      }

      // note 2: profile image update is now a separate endpoint.
      if (profileImage != null) {
        final fd = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split(RegExp(r'[\\/]')).last,
          ),
        });
        await dio.patch(ApiEndpoint.childAddProfileImagePath(childId), data: fd);
      }

      return child;
    } on DioException catch (e) {
      final msg = ApiError.messageFromDio(
        e,
        fallback: 'Failed to update child',
        decode: ApiResponse.decode,
      );
      throw ServerException(message: msg);
    }
  }
}
