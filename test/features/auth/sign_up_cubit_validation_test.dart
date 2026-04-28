import 'dart:io';

import 'package:dana/features/auth/login/domain/repo/auth_repository.dart';
import 'package:dana/features/auth/login/domain/entities/user_entity.dart';
import 'package:dana/features/auth/login/data/datasources/auth_remote_data_source.dart';
import 'package:dana/features/auth/login/domain/usecases/add_sign_up_password_usecase.dart';
import 'package:dana/features/auth/login/domain/usecases/change_password_usecase.dart';
import 'package:dana/features/auth/login/domain/usecases/pre_sign_up_usecase.dart';
import 'package:dana/features/auth/login/domain/usecases/verify_sign_up_usecase.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/sign_up_state.dart';
import 'package:dartz/dartz.dart';
import 'package:dana/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  Never _unimplemented() => throw UnimplementedError('Not needed for this test');

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
  }) async => _unimplemented();

  @override
  Future<Either<Failure, String>> verifySignUp({
    required String phone,
    required String otp,
  }) async => _unimplemented();

  @override
  Future<Either<Failure, Unit>> addPassword({required String password}) async =>
      _unimplemented();

  @override
  Future<Either<Failure, Unit>> preSignIn({
    required String phone,
    required String password,
  }) async => _unimplemented();

  @override
  Future<Either<Failure, UserEntity>> verifySignIn({
    required String phone,
    required String otp,
  }) async => _unimplemented();

  @override
  Future<Either<Failure, Unit>> resetPassword({required String phone}) async =>
      _unimplemented();

  @override
  Future<Either<Failure, String>> verifyPasswordOtp({
    required String phone,
    required String otp,
  }) async => _unimplemented();

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String phone,
    required String password,
    required String token,
  }) async => _unimplemented();

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
  }) async => _unimplemented();

  @override
  Future<Either<Failure, dynamic>> googleSignIn() async => _unimplemented();

  @override
  Future<Either<Failure, UserEntity>> googleComplete({
    required String requestId,
    required String phone,
    required String password,
    required String government,
    required String address,
    required List<ChildData> children,
  }) async => _unimplemented();
}

SignUpCubit _buildCubit() {
  final repo = _FakeAuthRepository();
  return SignUpCubit(
    preSignUpUseCase: PreSignUpUseCase(repository: repo),
    verifySignUpUseCase: VerifySignUpUseCase(repository: repo),
    addSignUpPasswordUseCase: AddSignUpPasswordUseCase(repository: repo),
    changePasswordUseCase: ChangePasswordUseCase(repository: repo),
  );
}

void main() {
  group('SignUpCubit validation', () {
    test('step 3 rejects invalid phone and email', () async {
      final cubit = _buildCubit();
      addTearDown(cubit.close);

      cubit.updatePhone('123');
      cubit.updateEmail('not-an-email');

      final err = cubit.validateStep3();
      expect(err, isNotNull);
    });

    test('step 3 accepts Egyptian phone + valid email', () async {
      final cubit = _buildCubit();
      addTearDown(cubit.close);

      cubit.updatePhone('01012345678');
      cubit.updateEmail('test@example.com');

      final err = cubit.validateStep3();
      expect(err, isNull);
    });

    test('step 4 rejects short password', () async {
      final cubit = _buildCubit();
      addTearDown(cubit.close);

      cubit.updatePassword('123');
      final err = cubit.validateStep4();
      expect(err, isNotNull);
    });

    test('onStep1Next emits failure then resets to initial', () async {
      final cubit = _buildCubit();
      addTearDown(cubit.close);

      // No step1 fields set => should fail.
      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SignUpFailure>(),
          isA<SignUpInitial>(),
        ]),
      );

      final ok = cubit.onStep1Next();
      expect(ok, isFalse);
    });
  });
}

