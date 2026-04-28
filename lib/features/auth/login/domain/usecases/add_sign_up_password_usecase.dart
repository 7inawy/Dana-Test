import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repo/auth_repository.dart';

class AddSignUpPasswordUseCase extends UseCase<Unit, AddSignUpPasswordParams> {
  final AuthRepository repository;
  AddSignUpPasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(AddSignUpPasswordParams params) {
    return repository.addPassword(password: params.password);
  }
}

class AddSignUpPasswordParams extends Equatable {
  final String password;
  const AddSignUpPasswordParams({required this.password});

  @override
  List<Object?> get props => [password];
}

