import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../../core/api/api_endpoint.dart';
import '../../../../../core/api/api_error.dart';
import '../../../../../core/api/api_response.dart';
import '../../../../../core/errors/exceptions.dart';
import '../model/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  // ✅ صح
  AuthRemoteDataSourceImpl({required this.dio});
  // ── helpers ─────────────────────────────────────────────────────────────────

  void _throwIfError(dynamic data, int? statusCode, String fallback) {
    if (statusCode != null && statusCode >= 200 && statusCode < 300) return;
    final msg = ApiError.messageFromDecoded(data, fallback: fallback);
    throw ServerException(message: msg);
  }

  bool _isEmptyBody(dynamic raw) {
    if (raw == null) return true;
    if (raw is String) return raw.trim().isEmpty;
    if (raw is Map) return raw.isEmpty;
    if (raw is List) return raw.isEmpty;
    return false;
  }

  // ── Parent Auth ──────────────────────────────────────────────────────────────

  @override
  Future<void> preSignUp({
    required String parentName,
    required String email,
    required String phone,
    required String government,
    required String address,
    required String password,
    required List<ChildData> children,
    File? profileImage,
  }) async {
    try {
      // Updated contract (note 2): pre-sign-up body is raw JSON (not multipart).
      // Shape stays the same: `{ parent: {...}, children: [...] }`.
      final parentMap = <String, dynamic>{
        'parentName': parentName,
        'email': email,
        'phone': phone,
        'government': government,
        'address': address,
      };
      if (password.isNotEmpty) {
        parentMap['password'] = password;
      }
      final payload = {
        'parent': parentMap,
        'children': children.map((c) => c.toJson()).toList(),
      };
      if (profileImage != null) {
        // New image upload routes require a known parentId; pre-sign-up doesn't have it.
        throw const ServerException(message: 'Use add-profile-image after signup');
      }

      final response = await dio.post(
        ApiEndpoint.preSignUp,

        // ApiConstant.preSignUp, // POST /v1/parent/pre-SignUp
        data: payload,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = ApiResponse.decode(response.data);
      _throwIfError(data, response.statusCode, 'فشل التسجيل');
    } on DioException catch (e) {
      // Backend sometimes returns 400 with an empty body for duplicate accounts.
      // Provide a stable message so the UI can offer "Login / Edit info".
      if (e.response?.statusCode == 400 && _isEmptyBody(e.response?.data)) {
        throw const ServerException(message: 'Account already exists');
      }
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'حدث خطأ في الخادم',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }

  @override
  Future<String> verifySignUp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        // ApiConstant.baseUrl + ApiEndpoint.verifySignUp,
        ApiEndpoint.verifySignUp, // POST /v1/parent/verify-signUp
        data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = ApiResponse.decode(response.data);
      _throwIfError(data, response.statusCode, 'كود التحقق غير صحيح');

      final accessToken = (data is Map ? data['accessToken'] : null);
      final token =
          (accessToken is Map ? accessToken['access_token'] : null) as String?;
      if (token == null || token.trim().isEmpty) {
        throw const ServerException(message: 'لم يتم استلام التوكن');
      }
      return token;
    } on DioException catch (e) {
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'فشل التحقق من الكود',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }

  @override
  Future<void> addPassword({required String password}) async {
    try {
      final response = await dio.post(
        ApiEndpoint.addPassword,
        data: {'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = ApiResponse.decode(response.data);
      _throwIfError(data, response.statusCode, 'فشل حفظ كلمة المرور');
    } on DioException catch (e) {
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'حدث خطأ في الخادم',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }

  @override
  Future<void> preSignIn({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        // ApiConstant.baseUrl + ApiEndpoint.preSignIn,
        ApiEndpoint.preSignIn, // POST /v1/parent/pre-signIn
        data: {'phone': phone, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = ApiResponse.decode(response.data);
      _throwIfError(data, response.statusCode, 'بيانات الدخول غير صحيحة');
    } on DioException catch (e) {
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'حدث خطأ في الخادم',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }

  @override
  Future<UserModel> verifySignIn({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoint.verifySignIn,
        data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = ApiResponse.decode(response.data);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // ✅ التوكن جوه accessToken.access_token
        final accessToken = (data is Map ? data['accessToken'] : null);
        final token =
            (accessToken is Map ? accessToken['access_token'] : null)
                as String?;

        if (token == null || token.isEmpty) {
          throw const ServerException(message: 'لم يتم استلام التوكن');
        }

        return UserModel.fromToken(token: token);
      }

      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'فشل تسجيل الدخول',
        ),
      );
    } on DioException catch (e) {
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'حدث خطأ في الخادم',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }

  @override
  Future<void> resetPassword({required String phone}) async {
    try {
      final response = await dio.post(
        // ApiConstant.baseUrl+ApiEndpoint.resetPassword,
        ApiEndpoint.resetPassword, // POST /v1/parent/reset-password
        data: {'phone': phone},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = ApiResponse.decode(response.data);
      _throwIfError(data, response.statusCode, 'فشل إرسال كود إعادة التعيين');
    } on DioException catch (e) {
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'حدث خطأ في الخادم',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }

  @override
  Future<void> verifyPasswordOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        // ApiConstant.baseUrl+ApiEndpoint.verifyPasswordOtp,
        ApiEndpoint.verifyPasswordOtp, // POST /v1/parent/verify-password-otp
        data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = ApiResponse.decode(response.data);
      _throwIfError(data, response.statusCode, 'كود التحقق غير صحيح');
    } on DioException catch (e) {
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'فشل التحقق من الكود',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }

  @override
  Future<void> changePassword({
    required String phone,
    required String password,
    required String token,
  }) async {
    try {
      final response = await dio.post(
        // ApiConstant.baseUrl+ApiEndpoint.changePassword,
        ApiEndpoint.changePassword, // POST /v1/parent/change-password
        data: {'phone': phone, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final data = ApiResponse.decode(response.data);
      _throwIfError(data, response.statusCode, 'فشل تغيير كلمة المرور');
    } on DioException catch (e) {
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'حدث خطأ في الخادم',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }

  // ── Doctor ───────────────────────────────────────────────────────────────────

  @override
  Future<void> createDoctor({
    required String doctorName,
    required String email,
    required String phone,
    required String password,
    required int detectionPrice,
    required int expires,
    required String specialty,
    required List<String> availableDates,
    required List<String> availableTimes,
    File? profileImage,
  }) async {
    try {
      final payload = {
        'doctorName': doctorName,
        'email': email,
        'phone': phone,
        'password': password,
        'detectionPrice': detectionPrice,
        'expirtes': expires,
        'specialty': specialty,
        'avilableDate': availableDates,
        'avilableTime': availableTimes,
      };

      final formData = FormData.fromMap({
        'data': jsonEncode(payload),
        if (profileImage != null)
          'file': await MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split('/').last,
          ),
      });

      final response = await dio.post(
        // ApiConstant.baseUrl+ApiEndpoint.createDoctor,
        ApiEndpoint.createDoctor, // POST /v1/doctor
        data: formData,
      );

      final data = ApiResponse.decode(response.data);
      _throwIfError(data, response.statusCode, 'فشل إنشاء حساب الطبيب');
    } on DioException catch (e) {
      final data = ApiResponse.decode(e.response?.data);
      throw ServerException(
        message: ApiError.messageFromDecoded(
          data,
          fallback: 'حدث خطأ في الخادم',
        ),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: 'حدث خطأ غير متوقع');
    }
  }
}
