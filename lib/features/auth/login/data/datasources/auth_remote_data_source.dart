// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import '../../../../../core/constant/api_constants.dart';
// import '../../../../../core/errors/exceptions.dart';
// import '../model/user_model.dart';

// // ── Child data class used in pre-signUp ──────────────────────────────────────
// class ChildData {
//   final String childName;
//   final String gender; // "male" | "female"
//   final String birthDate; // YYYY-MM-DD

//   const ChildData({
//     required this.childName,
//     required this.gender,
//     required this.birthDate,
//   });

//   Map<String, dynamic> toJson() => {
//     'childName': childName,
//     'gender': gender,
//     'birthDate': birthDate,
//   };
// }

// // ── Abstract ──────────────────────────────────────────────────────────────────
// abstract class AuthRemoteDataSource {
//   /// Step 1 – Register parent + children (OTP sent to email for now)
//   Future<void> preSignUp({
//     required String parentName,
//     required String email,
//     required String phone,
//     required String government,
//     required String address,
//     required String password,
//     required List<ChildData> children,
//     File? profileImage,
//   });

//   /// Step 2 – Verify sign-up OTP
//   Future<void> verifySignUp({
//     required String phone,
//     required String otp,
//   });

//   /// Step 3 – Pre sign-in (sends OTP)
//   Future<void> preSignIn({
//     required String phone,
//     required String password,
//   });

//   /// Step 4 – Verify sign-in OTP → returns token
//   Future<UserModel> verifySignIn({
//     required String phone,
//     required String otp,
//   });

//   /// Forgot password – sends OTP to phone
//   Future<void> resetPassword({required String phone});

//   /// Verify reset-password OTP
//   Future<void> verifyPasswordOtp({
//     required String phone,
//     required String otp,
//   });

//   /// Change password (authenticated)
//   Future<void> changePassword({
//     required String phone,
//     required String password,
//     required String token,
//   });

//   // ── Doctor endpoints ────────────────────────────────────────────────────────

//   /// Create doctor (admin-level, multipart)
//   Future<void> createDoctor({
//     required String doctorName,
//     required String email,
//     required String phone,
//     required String password,
//     required int detectionPrice,
//     required int expires,
//     required String specialty,
//     required List<String> availableDates,
//     required List<String> availableTimes,
//     File? profileImage,
//   });
// }

// // ── Implementation ────────────────────────────────────────────────────────────
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final Dio dio;

//   AuthRemoteDataSourceImpl({required this.dio});

//   // ── helpers ─────────────────────────────────────────────────────────────────

//   dynamic _decode(dynamic raw) =>
//       raw is String ? jsonDecode(raw) : raw;

//   void _throwIfError(dynamic data, int? statusCode, String fallback) {
//     if (statusCode != null && statusCode >= 200 && statusCode < 300) return;
//     final msg = _extractMessage(data) ?? fallback;
//     throw ServerException(message: msg);
//   }

//   String? _extractMessage(dynamic data) {
//     if (data is Map) {
//       final msg = data['message'];
//       if (msg != null) return msg.toString();
//       final errors = data['errors'];
//       if (errors is List && errors.isNotEmpty) return errors.first.toString();
//       if (errors is Map && errors.isNotEmpty) {
//         final v = errors.values.first;
//         return v is List ? v.first.toString() : v.toString();
//       }
//     }
//     return null;
//   }

//   // ── Parent Auth ──────────────────────────────────────────────────────────────

//   @override
//   Future<void> preSignUp({
//     required String parentName,
//     required String email,
//     required String phone,
//     required String government,
//     required String address,
//     required String password,
//     required List<ChildData> children,
//     File? profileImage,
//   }) async {
//     try {
//       final payload = {
//         'role': 'parent',
//         'parentName': parentName,
//         'email': email,
//         'phone': phone,
//         'government': government,
//         'address': address,
//         'password': password,
//         'children': children.map((c) => c.toJson()).toList(),
//       };

//       final formData = FormData.fromMap({
//         'data': jsonEncode(payload),
//         if (profileImage != null)
//           'file': await MultipartFile.fromFile(
//             profileImage.path,
//             filename: profileImage.path.split('/').last,
//           ),
//       });

//       final response = await dio.post(
//         ApiConstants.preSignUp, // POST /v1/parent/pre-SignUp
//         data: formData,
//       );

//       final data = _decode(response.data);
//       _throwIfError(data, response.statusCode, 'فشل التسجيل');
//     } on DioException catch (e) {
//       final data = _decode(e.response?.data);
//       throw ServerException(
//           message: _extractMessage(data) ?? 'حدث خطأ في الخادم');
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ServerException(message: 'حدث خطأ غير متوقع');
//     }
//   }

//   @override
//   Future<void> verifySignUp({
//     required String phone,
//     required String otp,
//   }) async {
//     try {
//       final response = await dio.post(
//         ApiConstants.verifySignUp, // POST /v1/parent/verify-signUp
//         data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );

//       final data = _decode(response.data);
//       _throwIfError(data, response.statusCode, 'كود التحقق غير صحيح');
//     } on DioException catch (e) {
//       final data = _decode(e.response?.data);
//       throw ServerException(
//           message: _extractMessage(data) ?? 'فشل التحقق من الكود');
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ServerException(message: 'حدث خطأ غير متوقع');
//     }
//   }

//   @override
//   Future<void> preSignIn({
//     required String phone,
//     required String password,
//   }) async {
//     try {
//       final response = await dio.post(
//         ApiConstants.preSignIn, // POST /v1/parent/pre-signIn
//         data: {'phone': phone, 'password': password},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );

//       final data = _decode(response.data);
//       _throwIfError(data, response.statusCode, 'بيانات الدخول غير صحيحة');
//     } on DioException catch (e) {
//       final data = _decode(e.response?.data);
//       throw ServerException(
//           message: _extractMessage(data) ?? 'حدث خطأ في الخادم');
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ServerException(message: 'حدث خطأ غير متوقع');
//     }
//   }

//   @override
//   Future<UserModel> verifySignIn({
//     required String phone,
//     required String otp,
//   }) async {
//     try {
//       final response = await dio.post(
//         ApiConstants.verifySignIn, // POST /v1/parent/verify-signIn
//         data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );

//       dynamic data = _decode(response.data);
//       if (response.statusCode != null &&
//           response.statusCode! >= 200 &&
//           response.statusCode! < 300) {
//         // The API returns { token: "JWT_TOKEN" }
//         final token = data['token'] as String?;
//         if (token == null || token.isEmpty) {
//           throw const ServerException(message: 'لم يتم استلام التوكن');
//         }
//         return UserModel.fromToken(token: token, phone: phone);
//       }
//       throw ServerException(
//           message: _extractMessage(data) ?? 'فشل تسجيل الدخول');
//     } on DioException catch (e) {
//       final data = _decode(e.response?.data);
//       throw ServerException(
//           message: _extractMessage(data) ?? 'حدث خطأ في الخادم');
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ServerException(message: 'حدث خطأ غير متوقع');
//     }
//   }

//   @override
//   Future<void> resetPassword({required String phone}) async {
//     try {
//       final response = await dio.post(
//         ApiConstants.resetPassword, // POST /v1/parent/reset-password
//         data: {'phone': phone},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );
//       final data = _decode(response.data);
//       _throwIfError(data, response.statusCode, 'فشل إرسال كود إعادة التعيين');
//     } on DioException catch (e) {
//       final data = _decode(e.response?.data);
//       throw ServerException(
//           message: _extractMessage(data) ?? 'حدث خطأ في الخادم');
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ServerException(message: 'حدث خطأ غير متوقع');
//     }
//   }

//   @override
//   Future<void> verifyPasswordOtp({
//     required String phone,
//     required String otp,
//   }) async {
//     try {
//       final response = await dio.post(
//         ApiConstants.verifyPasswordOtp, // POST /v1/parent/verify-password-otp
//         data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );
//       final data = _decode(response.data);
//       _throwIfError(data, response.statusCode, 'كود التحقق غير صحيح');
//     } on DioException catch (e) {
//       final data = _decode(e.response?.data);
//       throw ServerException(
//           message: _extractMessage(data) ?? 'فشل التحقق من الكود');
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ServerException(message: 'حدث خطأ غير متوقع');
//     }
//   }

//   @override
//   Future<void> changePassword({
//     required String phone,
//     required String password,
//     required String token,
//   }) async {
//     try {
//       final response = await dio.post(
//         ApiConstants.changePassword, // POST /v1/parent/change-password
//         data: {'phone': phone, 'password': password},
//         options: Options(headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         }),
//       );
//       final data = _decode(response.data);
//       _throwIfError(data, response.statusCode, 'فشل تغيير كلمة المرور');
//     } on DioException catch (e) {
//       final data = _decode(e.response?.data);
//       throw ServerException(
//           message: _extractMessage(data) ?? 'حدث خطأ في الخادم');
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ServerException(message: 'حدث خطأ غير متوقع');
//     }
//   }

//   // ── Doctor ───────────────────────────────────────────────────────────────────

//   @override
//   Future<void> createDoctor({
//     required String doctorName,
//     required String email,
//     required String phone,
//     required String password,
//     required int detectionPrice,
//     required int expires,
//     required String specialty,
//     required List<String> availableDates,
//     required List<String> availableTimes,
//     File? profileImage,
//   }) async {
//     try {
//       final payload = {
//         'doctorName': doctorName,
//         'email': email,
//         'phone': phone,
//         'password': password,
//         'detectionPrice': detectionPrice,
//         'expirtes': expires,
//         'specialty': specialty,
//         'avilableDate': availableDates,
//         'avilableTime': availableTimes,
//       };

//       final formData = FormData.fromMap({
//         'data': jsonEncode(payload),
//         if (profileImage != null)
//           'file': await MultipartFile.fromFile(
//             profileImage.path,
//             filename: profileImage.path.split('/').last,
//           ),
//       });

//       final response = await dio.post(
//         ApiConstants.createDoctor, // POST /v1/doctor
//         data: formData,
//       );

//       final data = _decode(response.data);
//       _throwIfError(data, response.statusCode, 'فشل إنشاء حساب الطبيب');
//     } on DioException catch (e) {
//       final data = _decode(e.response?.data);
//       throw ServerException(
//           message: _extractMessage(data) ?? 'حدث خطأ في الخادم');
//     } catch (e) {
//       if (e is ServerException) rethrow;
//       throw const ServerException(message: 'حدث خطأ غير متوقع');
//     }
//   }
// }

import 'dart:io';
import '../model/user_model.dart';

// ── Child data class used in pre-signUp ──────────────────────────────────────
class ChildData {
  final String childName;
  final String gender; // "male" | "female"
  final String birthDate; // YYYY-MM-DD

  const ChildData({
    required this.childName,
    required this.gender,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
    'childName': childName,
    'gender': gender,
    'birthDate': birthDate,
  };
}

// ── Abstract ──────────────────────────────────────────────────────────────────
abstract class AuthRemoteDataSource {
  /// Step 1 – Register parent + children (OTP sent to email for now)
  Future<void> preSignUp({
    required String parentName,
    required String email,
    required String phone,
    required String government,
    required String address,
    required String password,
    required List<ChildData> children,
    File? profileImage,
  });

  /// Step 2 – Verify sign-up OTP
  Future<String> verifySignUp({required String phone, required String otp});

  /// Set password after verify-signUp (Bearer token) — `/v1/parent/add-password`
  Future<void> addPassword({required String password});

  /// Pre sign-in (sends OTP)
  Future<void> preSignIn({required String phone, required String password});

  /// Step 4 – Verify sign-in OTP → returns token
  Future<UserModel> verifySignIn({required String phone, required String otp});

  /// Forgot password – sends OTP to phone
  Future<void> resetPassword({required String phone});

  /// Verify reset-password OTP
  /// Some backends return a short-lived token to authorize password change.
  Future<String> verifyPasswordOtp({required String phone, required String otp});

  /// Change password (authenticated)
  Future<void> changePassword({
    required String phone,
    required String password,
    required String token,
  });

  // ── Doctor endpoints ────────────────────────────────────────────────────────

  /// Create doctor (admin-level, multipart)
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
  });

  // ── Parent / Google OAuth ────────────────────────────────────────────────────
  /// Start Google sign-in.
  /// Backend typically returns a redirect URL / session ID, or performs a redirect.
  Future<dynamic> googleSignIn();

  /// Complete Google sign-in by filling the missing parent profile fields.
  ///
  /// Endpoint: `POST /v1/parent/google/compelete/:requestId`
  Future<UserModel> googleComplete({
    required String requestId,
    required String phone,
    required String password,
    required String government,
    required String address,
    required List<ChildData> children,
  });
}
