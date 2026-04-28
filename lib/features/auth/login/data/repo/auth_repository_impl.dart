import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/log/app_logger.dart';
import '../../../../../core/utils/parent_phone_utils.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repo/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // ── helper ──────────────────────────────────────────────────────────────────
  // Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
  //   if (!await networkInfo.isConnected) {
  //     return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
  //   }
  //   try {
  //     return Right(await call());
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(message: e.message));
  //   } catch (_) {
  //     return const Left(UnknownFailure(message: 'حدث خطأ غير متوقع'));
  //   }
  // }
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    // `internet_connection_checker_plus` can report false negatives on some
    // Android emulators/devices (DNS/VPN/captive portal). Blocking all auth
    // calls here makes the app look "unwired" even when the API is reachable.
    //
    // Prefer attempting the HTTP request and surfacing real failures via Dio.
    try {
      final connected = await networkInfo.isConnected;
      if (!connected) {
        AppLogger.warn(
          'Connectivity check reported offline; attempting request anyway',
        );
      }
    } catch (e) {
      AppLogger.warn(
        'Connectivity check failed ($e); attempting request anyway',
      );
    }
    try {
      final result = await call();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown exception in AuthRepository', error: e);
      return const Left(UnknownFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  // ── Sign Up ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> preSignUp({
    required String parentName,
    required String email,
    required String phone,
    required String government,
    required String address,
    required String password,
    required List<ChildData> children,
    File? profileImage,
  }) => _guard(() async {
    final p = ParentPhoneUtils.normalizeForApi(phone);
    final em = email.trim().toLowerCase();
    await remoteDataSource.preSignUp(
      parentName: parentName.trim(),
      email: em,
      phone: p,
      government: government,
      address: address,
      password: password,
      children: children,
      profileImage: profileImage,
    );
    return unit;
  });

  @override
  Future<Either<Failure, String>> verifySignUp({
    required String phone,
    required String otp,
  }) => _guard(() async {
    final token = await remoteDataSource.verifySignUp(
      phone: ParentPhoneUtils.normalizeForApi(phone),
      otp: otp,
    );
    return token;
  });

  @override
  Future<Either<Failure, Unit>> addPassword({required String password}) =>
      _guard(() async {
        await remoteDataSource.addPassword(password: password);
        return unit;
      });

  // ── Sign In ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> preSignIn({
    required String phone,
    required String password,
  }) => _guard(() async {
    await remoteDataSource.preSignIn(
      phone: ParentPhoneUtils.normalizeForApi(phone),
      password: password,
    );
    return unit;
  });

  @override
  Future<Either<Failure, UserEntity>> verifySignIn({
    required String phone,
    required String otp,
  }) => _guard(
    () => remoteDataSource.verifySignIn(
      phone: ParentPhoneUtils.normalizeForApi(phone),
      otp: otp,
    ),
  );

  // ── Reset Password ───────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> resetPassword({required String phone}) =>
      _guard(() async {
        await remoteDataSource.resetPassword(
          phone: ParentPhoneUtils.normalizeForApi(phone),
        );
        return unit;
      });

  @override
  Future<Either<Failure, String>> verifyPasswordOtp({
    required String phone,
    required String otp,
  }) => _guard(() async {
    final token = await remoteDataSource.verifyPasswordOtp(
      phone: ParentPhoneUtils.normalizeForApi(phone),
      otp: otp,
    );
    return token;
  });

  // ── Change Password ──────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String phone,
    required String password,
    required String token,
  }) => _guard(() async {
    await remoteDataSource.changePassword(
      phone: ParentPhoneUtils.normalizeForApi(phone),
      password: password,
      token: token,
    );
    return unit;
  });

  // ── Doctor ───────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> createDoctor({
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
  }) => _guard(() async {
    await remoteDataSource.createDoctor(
      doctorName: doctorName,
      email: email.trim().toLowerCase(),
      phone: ParentPhoneUtils.normalizeForApi(phone),
      password: password,
      detectionPrice: detectionPrice,
      expires: expires,
      specialty: specialty,
      availableDates: availableDates,
      availableTimes: availableTimes,
      profileImage: profileImage,
    );
    return unit;
  });

  // ── Google Auth ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, dynamic>> googleSignIn() => _guard(
        () => remoteDataSource.googleSignIn(),
      );

  @override
  Future<Either<Failure, UserEntity>> googleComplete({
    required String requestId,
    required String phone,
    required String password,
    required String government,
    required String address,
    required List<ChildData> children,
  }) =>
      _guard(
        () => remoteDataSource.googleComplete(
          requestId: requestId.trim(),
          phone: ParentPhoneUtils.normalizeForApi(phone),
          password: password,
          government: government,
          address: address,
          children: children,
        ),
      );
}
