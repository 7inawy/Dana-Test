import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../../core/api/api_endpoint.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/app_error_messages.dart';
import '../model/user_model.dart';
import '../utils/auth_token_parser.dart';
import 'auth_api_client.dart';
import 'google_oauth_remote_data_source.dart';
import 'google_oauth_remote_data_source_impl.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final AuthApiClient _api;
  final GoogleOAuthRemoteDataSource _googleOAuth;

  AuthRemoteDataSourceImpl({required this.dio})
      : _api = AuthApiClient(dio),
        _googleOAuth = GoogleOAuthRemoteDataSourceImpl(dio: dio);

  static const String _kFallbackServerErrorAr =
      AppErrorMessages.fallbackServerErrorAr;
  static const String _kUnexpectedErrorAr = AppErrorMessages.unexpectedErrorAr;
  static const String _kMissingTokenAr = AppErrorMessages.missingTokenAr;

  // ── helpers ────────────────────────────────────────────────────────────────
  dynamic _decode(dynamic raw) => _api.decode(raw);

  String _safeBasename(String filePath) {
    // `path` package isn't used here; keep it lightweight and cross-platform.
    final sep = Platform.pathSeparator;
    int i = filePath.lastIndexOf(sep);
    if (i == -1) {
      final otherSep = sep == '/' ? '\\' : '/';
      i = filePath.lastIndexOf(otherSep);
    }
    return i == -1 ? filePath : filePath.substring(i + 1);
  }

  bool _isEmptyBody(dynamic raw) {
    if (raw == null) return true;
    if (raw is String) return raw.trim().isEmpty;
    if (raw is Map) return raw.isEmpty;
    if (raw is List) return raw.isEmpty;
    return false;
  }

  void _throwIfNotSuccess(dynamic decoded, int? statusCode,
      {required String fallback}) {
    _api.throwIfNotSuccess(decoded, statusCode, fallback: fallback);
  }

  String _requireToken(String? token) {
    final trimmed = token?.trim() ?? '';
    if (trimmed.isEmpty) throw const ServerException(message: _kMissingTokenAr);
    return trimmed;
  }

  Future<T> _run<T>({
    required Future<T> Function() body,
    required String dioFallback,
    ServerException Function(DioException e)? mapDio,
  }) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw (mapDio?.call(e) ?? _api.mapDioException(e, fallback: dioFallback));
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException(message: _kUnexpectedErrorAr);
    }
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
    return _run<void>(
      dioFallback: _kFallbackServerErrorAr,
      mapDio: (e) {
        // Backend sometimes returns 400 with an empty body for duplicate accounts.
        // Provide a stable message so the UI can offer "Login / Edit info".
        if (e.response?.statusCode == 400 && _isEmptyBody(e.response?.data)) {
          return const ServerException(message: 'Account already exists');
        }
        return _api.mapDioException(e, fallback: _kFallbackServerErrorAr);
      },
      body: () async {
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
          throw const ServerException(
            message: 'Use add-profile-image after signup',
          );
        }

        final response = await _api.postJson(
          ApiEndpoint.preSignUp,
          data: payload,
        );

        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode, fallback: 'فشل التسجيل');
      },
    );
  }

  @override
  Future<String> verifySignUp({
    required String phone,
    required String otp,
  }) async {
    return _run<String>(
      dioFallback: 'فشل التحقق من الكود',
      body: () async {
        final response = await _api.postJson(
          ApiEndpoint.verifySignUp,
          data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
        );

        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode,
            fallback: 'كود التحقق غير صحيح');

        final token = AuthTokenParser.extractAccessToken(decoded);
        return _requireToken(token);
      },
    );
  }

  @override
  Future<void> addPassword({required String password}) async {
    return _run<void>(
      dioFallback: _kFallbackServerErrorAr,
      body: () async {
        final response = await _api.postJson(
          ApiEndpoint.addPassword,
          data: {'password': password},
        );
        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode,
            fallback: 'فشل حفظ كلمة المرور');
      },
    );
  }

  @override
  Future<void> preSignIn({
    required String phone,
    required String password,
  }) async {
    return _run<void>(
      dioFallback: _kFallbackServerErrorAr,
      body: () async {
        final response = await _api.postJson(
          ApiEndpoint.preSignIn,
          data: {'phone': phone, 'password': password},
        );

        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode,
            fallback: 'بيانات الدخول غير صحيحة');
      },
    );
  }

  @override
  Future<UserModel> verifySignIn({
    required String phone,
    required String otp,
  }) async {
    return _run<UserModel>(
      dioFallback: _kFallbackServerErrorAr,
      body: () async {
        final response = await _api.postJson(
          ApiEndpoint.verifySignIn,
          data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
        );

        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode,
            fallback: 'فشل تسجيل الدخول');

        final token = _requireToken(AuthTokenParser.extractAccessToken(decoded));
        return UserModel.fromToken(token: token);
      },
    );
  }

  @override
  Future<void> resetPassword({required String phone}) async {
    return _run<void>(
      dioFallback: _kFallbackServerErrorAr,
      body: () async {
        final response = await _api.postJson(
          ApiEndpoint.resetPassword,
          data: {'phone': phone},
        );
        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode,
            fallback: 'فشل إرسال كود إعادة التعيين');
      },
    );
  }

  @override
  Future<String> verifyPasswordOtp({
    required String phone,
    required String otp,
  }) async {
    return _run<String>(
      dioFallback: 'فشل التحقق من الكود',
      body: () async {
        final response = await _api.postJson(
          ApiEndpoint.verifyPasswordOtp,
          data: {'phone': phone, 'otp': int.tryParse(otp) ?? otp},
        );
        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode,
            fallback: 'كود التحقق غير صحيح');
        return _requireToken(AuthTokenParser.extractAccessToken(decoded));
      },
    );
  }

  @override
  Future<void> changePassword({
    required String phone,
    required String password,
    required String token,
  }) async {
    return _run<void>(
      dioFallback: _kFallbackServerErrorAr,
      body: () async {
        final response = await _api.postJson(
          ApiEndpoint.changePassword,
          data: {'phone': phone, 'password': password},
          headers: {'Authorization': 'Bearer $token'},
        );
        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode,
            fallback: 'فشل تغيير كلمة المرور');
      },
    );
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
    return _run<void>(
      dioFallback: _kFallbackServerErrorAr,
      body: () async {
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
              filename: _safeBasename(profileImage.path),
            ),
        });

        final response = await dio.post(
          ApiEndpoint.createDoctor,
          data: formData,
        );

        final decoded = _decode(response.data);
        _throwIfNotSuccess(decoded, response.statusCode,
            fallback: 'فشل إنشاء حساب الطبيب');
      },
    );
  }

  @override
  Future<dynamic> googleSignIn() async {
    return _googleOAuth.googleSignIn();
  }

  @override
  Future<UserModel> googleComplete({
    required String requestId,
    required String phone,
    required String password,
    required String government,
    required String address,
    required List<ChildData> children,
  }) async {
    return _googleOAuth.googleComplete(
      requestId: requestId,
      phone: phone,
      password: password,
      government: government,
      address: address,
      children: children,
    );
  }
}
