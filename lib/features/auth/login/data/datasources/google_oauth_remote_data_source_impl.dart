import 'package:dana/core/api/api_endpoint.dart';
import 'package:dana/core/api/api_error.dart';
import 'package:dana/core/errors/app_error_messages.dart';
import 'package:dana/core/errors/exceptions.dart';
import 'package:dana/core/log/app_logger.dart';
import 'package:dana/features/auth/login/data/datasources/auth_api_client.dart';
import 'package:dana/features/auth/login/data/datasources/auth_remote_data_source.dart';
import 'package:dana/features/auth/login/data/datasources/google_oauth_remote_data_source.dart';
import 'package:dana/features/auth/login/data/model/user_model.dart';
import 'package:dana/features/auth/login/data/utils/auth_token_parser.dart';
import 'package:dio/dio.dart';

class GoogleOAuthRemoteDataSourceImpl implements GoogleOAuthRemoteDataSource {
  static const String _kFallbackServerErrorAr =
      AppErrorMessages.fallbackServerErrorAr;
  static const String _kUnexpectedErrorAr = AppErrorMessages.unexpectedErrorAr;
  static const String _kMissingTokenAr = AppErrorMessages.missingTokenAr;

  final Dio dio;
  final AuthApiClient _api;

  GoogleOAuthRemoteDataSourceImpl({required this.dio})
      : _api = AuthApiClient(dio);

  String? _tryExtractRedirectUriFromGoogleLocation(String location) {
    try {
      final uri = Uri.parse(location);
      final redirect = uri.queryParameters['redirect_uri'] ??
          uri.queryParameters['redirectUri'] ??
          uri.queryParameters['redirect'];
      final trimmed = redirect?.trim();
      return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    } catch (_) {
      return null;
    }
  }

  String _requireToken(String? token) {
    final trimmed = token?.trim() ?? '';
    if (trimmed.isEmpty) throw const ServerException(message: _kMissingTokenAr);
    return trimmed;
  }

  @override
  Future<dynamic> googleSignIn() async {
    try {
      Future<Response<dynamic>> call(
        String path, {
        Map<String, dynamic>? queryParameters,
      }) =>
          _api.getRaw(
            path,
            queryParameters: queryParameters,
            options: Options(
              followRedirects: false,
              // Accept 4xx here so we can decide whether to retry with params.
              validateStatus: (s) => s != null && s >= 200 && s < 500,
            ),
          );

      final expectedCallback =
          '${dio.options.baseUrl}${ApiEndpoint.googleCallback}';

      Response<dynamic> response = await call(ApiEndpoint.googleSignIn);

      final decoded0 = _api.decode(response.data);
      final msg0 = ApiError.messageFromDecoded(
        decoded0,
        fallback: '',
      ).toLowerCase();
      if (response.statusCode == 400 && msg0.contains('invalid input')) {
        AppLogger.warn(
          'GoogleOAuth: /v1/parent/google returned invalid input. Retrying with callback params.',
        );

        const paramNames = <String>[
          'redirect_uri',
          'redirectUri',
          'callback',
          'callbackUrl',
          'returnUrl',
        ];

        for (final name in paramNames) {
          response = await call(
            ApiEndpoint.googleSignIn,
            queryParameters: {name: expectedCallback},
          );
          final decoded = _api.decode(response.data);
          final msg = ApiError.messageFromDecoded(
            decoded,
            fallback: '',
          ).toLowerCase();
          if (!(response.statusCode == 400 && msg.contains('invalid input'))) {
            break;
          }
        }
      }

      final decoded1 = _api.decode(response.data);
      final msg1 =
          ApiError.messageFromDecoded(decoded1, fallback: '').toLowerCase();
      if (response.statusCode == 400 && msg1.contains('invalid input')) {
        AppLogger.warn(
          'GoogleOAuth: /v1/parent/google still invalid input. Falling back to /v1/parent/google/callback start.',
        );
        response = await call(ApiEndpoint.googleCallback);
      }

      final location = response.headers.value('location');
      if (location != null && location.trim().isNotEmpty) {
        final redirectUri = _tryExtractRedirectUriFromGoogleLocation(location);
        final shortLocation =
            location.length > 300 ? '${location.substring(0, 300)}…' : location;
        AppLogger.info(
          'GoogleOAuth: start status=${response.statusCode} location=$shortLocation',
        );
        AppLogger.info('GoogleOAuth: expected_callback=$expectedCallback');
        if (redirectUri != null) {
          AppLogger.info('GoogleOAuth: redirect_uri=$redirectUri');
        }
        return {'redirectUrl': location};
      }

      final decoded = _api.decode(response.data);
      _api.throwIfNotSuccess(decoded, response.statusCode,
          fallback: 'فشل تسجيل الدخول بجوجل');
      return decoded;
    } on DioException catch (e) {
      AppLogger.warn(
        'GoogleOAuth: /v1/parent/google failed '
        'status=${e.response?.statusCode} data=${e.response?.data}',
      );
      throw _api.mapDioException(e, fallback: _kFallbackServerErrorAr);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: _kUnexpectedErrorAr);
    }
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
    try {
      final payload = <String, dynamic>{
        'phone': phone,
        'password': password,
        'government': government,
        'address': address,
        'children': children.map((c) => c.toJson()).toList(),
      };

      final response = await _api.postJson(
        '${ApiEndpoint.googleComplete}/$requestId',
        data: payload,
      );

      final decoded = _api.decode(response.data);
      _api.throwIfNotSuccess(decoded, response.statusCode,
          fallback: 'فشل استكمال بيانات حساب جوجل');

      final token = _requireToken(AuthTokenParser.extractAccessToken(decoded));
      return UserModel.fromToken(token: token);
    } on DioException catch (e) {
      throw _api.mapDioException(e, fallback: _kFallbackServerErrorAr);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException(message: _kUnexpectedErrorAr);
    }
  }
}

