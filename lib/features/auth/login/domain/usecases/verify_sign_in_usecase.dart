import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repo/auth_repository.dart';

class VerifySignInUseCase extends UseCase<UserEntity, VerifySignInParams> {
  final AuthRepository repository;
  VerifySignInUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(VerifySignInParams params) {
    return repository.verifySignIn(phone: params.phone, otp: params.otp);
  }
}

class VerifySignInParams extends Equatable {
  final String phone;
  final String otp;

  const VerifySignInParams({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}
