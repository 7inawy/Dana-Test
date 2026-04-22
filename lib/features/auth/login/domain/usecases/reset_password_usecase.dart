import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repo/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<Unit, String> {
  final AuthRepository repository;
  ResetPasswordUseCase({required this.repository});

  /// [params] = phone number
  @override
  Future<Either<Failure, Unit>> call(String phone) {
    return repository.resetPassword(phone: phone);
  }
}
