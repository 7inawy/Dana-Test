import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repo/auth_repository.dart';

class PreSignInUseCase extends UseCase<Unit, PreSignInParams> {
  final AuthRepository repository;
  PreSignInUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(PreSignInParams params) {
    return repository.preSignIn(phone: params.phone, password: params.password);
  }
}

class PreSignInParams extends Equatable {
  final String phone;
  final String password;

  const PreSignInParams({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}
