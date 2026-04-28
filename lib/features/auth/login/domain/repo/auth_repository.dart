import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  // ── Sign Up Flow (2 steps) ──────────────────────────────────────────────────

  /// Step 1: إرسال بيانات الأب والأطفال
  Future<Either<Failure, Unit>> preSignUp({
    required String parentName,
    required String email,
    required String phone,
    required String government,
    required String address,
    required String password,
    required List<ChildData> children,
    File? profileImage,
  });

  /// Step 2: تأكيد كود OTP بعد التسجيل
  Future<Either<Failure, String>> verifySignUp({
    required String phone,
    required String otp,
  });

  /// Step 3: حفظ كلمة المرور بعد verify-signUp (يحتاج Bearer)
  Future<Either<Failure, Unit>> addPassword({required String password});

  // ── Sign In Flow (2 steps) ──────────────────────────────────────────────────

  /// Step 1: إرسال رقم الهاتف وكلمة المرور → يبعت OTP
  Future<Either<Failure, Unit>> preSignIn({
    required String phone,
    required String password,
  });

  /// Step 2: تأكيد OTP → يرجع التوكن
  Future<Either<Failure, UserEntity>> verifySignIn({
    required String phone,
    required String otp,
  });

  // ── Reset Password Flow (2 steps) ──────────────────────────────────────────

  /// Step 1: إرسال رقم الهاتف → يبعت OTP
  Future<Either<Failure, Unit>> resetPassword({required String phone});

  /// Step 2: تأكيد OTP
  Future<Either<Failure, String>> verifyPasswordOtp({
    required String phone,
    required String otp,
  });

  // ── Change Password (Authenticated) ────────────────────────────────────────

  Future<Either<Failure, Unit>> changePassword({
    required String phone,
    required String password,
    required String token,
  });

  // ── Doctor ──────────────────────────────────────────────────────────────────

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
  });

  // ── Google Auth ──────────────────────────────────────────────────────────────
  Future<Either<Failure, dynamic>> googleSignIn();

  Future<Either<Failure, UserEntity>> googleComplete({
    required String requestId,
    required String phone,
    required String password,
    required String government,
    required String address,
    required List<ChildData> children,
  });
}
