import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repo/auth_repository.dart';

class VerifySignUpUseCase extends UseCase<String, VerifySignUpParams> {
  final AuthRepository repository;
  VerifySignUpUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(VerifySignUpParams params) {
    return repository.verifySignUp(phone: params.phone, otp: params.otp);
  }
}

class VerifySignUpParams extends Equatable {
  final String phone;
  final String otp;

  const VerifySignUpParams({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}
