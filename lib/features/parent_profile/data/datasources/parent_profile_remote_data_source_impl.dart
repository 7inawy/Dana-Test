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
      // Backend returns whole parent; fallback to re-fetch via getMe for correctness.
      final children = ParentProfileModel.fromJson(data).children;
      if (children.isEmpty) {
        throw const ServerException(message: 'Child was not created');
      }
      return children.last;
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

      final formData = FormData.fromMap({
        'data': jsonEncode(payload),
        if (profileImage != null)
          'file': await MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split('/').last,
          ),
      });

      final res = await dio.patch(
        '${ApiEndpoint.parentUpdateChild}$childId',
        data: formData,
      );

      final decoded = ApiResponse.decode(res.data);
      final data = ApiResponse.unwrapMap(decoded);
      final children = ParentProfileModel.fromJson(data).children;
      final updated = children.where((c) => c.id == childId).toList();
      if (updated.isEmpty) {
        throw const ServerException(message: 'Child was not updated');
      }
      return updated.first;
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
