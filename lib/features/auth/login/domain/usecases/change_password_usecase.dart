import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repo/auth_repository.dart';

class ChangePasswordUseCase extends UseCase<Unit, ChangePasswordParams> {
  final AuthRepository repository;
  ChangePasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(ChangePasswordParams params) {
    return repository.changePassword(
      phone: params.phone,
      password: params.password,
      token: params.token,
    );
  }
}

class ChangePasswordParams extends Equatable {
  final String phone;
  final String password;
  final String token;

  const ChangePasswordParams({
    required this.phone,
    required this.password,
    required this.token,
  });

  @override
  List<Object?> get props => [phone, password, token];
}
