import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repo/auth_repository.dart';

class VerifyPasswordOtpUseCase extends UseCase<String, VerifyPasswordOtpParams> {
  final AuthRepository repository;
  VerifyPasswordOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(VerifyPasswordOtpParams params) {
    return repository.verifyPasswordOtp(phone: params.phone, otp: params.otp);
  }
}

class VerifyPasswordOtpParams extends Equatable {
  final String phone;
  final String otp;

  const VerifyPasswordOtpParams({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}
